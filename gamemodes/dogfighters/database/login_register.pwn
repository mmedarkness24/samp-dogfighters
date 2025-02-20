#include <yoursql>
#include "dogfighters\database\loginRegisterSensitiveData.pwn"
#include "dogfighters\server\serverInfo\Gamemode\ModeInfo.pwn"
#include "dogfighters\server\serverInfo\Players\ServerPlayers.pwn"
#include "dogfighters\server\menuDialogs\DialogID.pwn"

//simple login and register system using YourSQL.
//Original github repo: https://github.com/Gammix/SAMP-YourSQL/


forward OnLoginSystemInit();
forward OnLoginSystemExit();
forward LoginSystem_OnPlayerConnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward LoginSystem_OnPlayerDisconnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward LoginSystem_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward LoginSystem_OnPlayerDeath(playerid, killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public OnLoginSystemInit()
{
	//open the database file
	//since i am only using one database file, i won't be creating any variable with tag "SQL:" to store the db id
	//the returning values with "yoursql_open" are whole numbers so the first one would be "SQL:0"
	yoursql_open(LOGIN_PASS_DBUSR);

    //create/verify a table named LOGIN_PASS_TBL_USR where we will store all the user data
    yoursql_verify_table(SQL:0, LOGIN_PASS_TBL_USR);

    //verify column in table LOGIN_PASS_TBL_USR names "Name" to store user names
    yoursql_verify_column(SQL:0, LOGIN_PASS_TBL_USRNAME, SQL_STRING);
    //verify column "Password" to store user account password (SHA256 hashed)
    yoursql_verify_column(SQL:0, LOGIN_PASS_TBL_USRPASS, SQL_STRING);
    //verify column "Kills" to store user kills count
    yoursql_verify_column(SQL:0, LOGIN_PASS_TBL_USRKILLS, SQL_NUMBER);
    //verify column "Deaths" to store user deaths count
    yoursql_verify_column(SQL:0, LOGIN_PASS_TBL_USRDEATHS, SQL_NUMBER);
    //verify column "Score" to store user score count
    yoursql_verify_column(SQL:0, LOGIN_PASS_TBL_USRSCORE, SQL_NUMBER);

    return 1;
}

public OnLoginSystemExit()
{
	//close the database, stored in index 0
    yoursql_close(SQL:0);

	return 1;
}

public LoginSystem_OnPlayerConnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	//ServerPlayerResetPersonalTimer(playerid, serverPlayers);
	new namePlayer[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, namePlayer, MAX_PLAYER_NAME + 1);

	//check if the player is registered or not
	new
	    SQLRow:rowid = yoursql_get_row(SQL:0, LOGIN_PASS_TBL_USR, "Name = %s", namePlayer)
	;
	if (rowid != SQL_INVALID_ROW)//if registered
	{
		if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
			ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, DIALOG_STYLE_PASSWORD, "User Accounts:", "You are registered, please insert your password to continue:", "Login", "Exit");
		else
			ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, DIALOG_STYLE_PASSWORD, "Аккаунт:", "Ваш ник зарегистрирован. Введите пароль для продолжения", "Логин", "Выйти");
	    
	}
	else//if new user
	{
		if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
			ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, DIALOG_STYLE_PASSWORD, "User Accounts:", "You are not recognized on the database, please insert a password to sing-in and continue:", "Register", "");
		else
			ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, DIALOG_STYLE_PASSWORD, "Аккаунт:", "Вы ещё не зарегистрированы на данном сервере. Введите пароль для регистрации:", "Зарегистрироваться", "Выйти");
	}

	return 1;
}

public LoginSystem_OnPlayerDisconnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	//save player's score
	new
		namePlayer[MAX_PLAYER_NAME + 1]
	;
	GetPlayerName(playerid, namePlayer, MAX_PLAYER_NAME + 1);

	//save player score
	yoursql_set_field_int(SQL:0, LOGIN_PASS_TBL_USR, yoursql_get_row(SQL:0, LOGIN_PASS_TBL_USR, "Name = %s", namePlayer), GetPlayerScore(playerid));

	return 1;
}

public LoginSystem_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	switch (dialogid)
	{
		case DIALOG_ID_REGISTER://if response for register dialog
		{
		    if (! response)//if the player presses 'ESC' button
		    {
		        return Kick(playerid);
		    }
		    else
		    {
		        if (! inputtext[0] || strlen(inputtext) < 4 || strlen(inputtext) > 50)//if the player's password is empty or not between 4 - 50 in length
		        {
					if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
						SendClientMessage(playerid, 0xFF0000FF, "ERROR: Your password must be between 4 - 50 characters.");//give warning message and reshow the dialog
					else
						SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Пароль ограничен 4 - 50 символами.");//give warning message and reshow the dialog
		            
					if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
						return ShowPlayerDialog(playerid, 
												DIALOG_ID_REGISTER, 
												DIALOG_STYLE_PASSWORD, 
												"User Accounts:", "You are not recognized on the database, please insert a password to sing-in and continue:", 
												"Register", 
												"Exit");
					else
						return ShowPlayerDialog(playerid, 
												DIALOG_ID_REGISTER, 
												DIALOG_STYLE_PASSWORD, 
												"Аккаунт:", 
												"Ваш ник ещё не зарегистрирован на данном сервере. Введите пароль для регистрации:", 
												"Регистрация", 
												"Выход");
		        }

		        //we create the new row the same way we verufy it using "yoursql_get_row"
		        new
				    namePlayer[MAX_PLAYER_NAME + 1]
				;
				GetPlayerName(playerid, namePlayer, MAX_PLAYER_NAME + 1);
		        yoursql_set_row(SQL:0, LOGIN_PASS_TBL_USR, "Name = %s", namePlayer);//create new row with the specific "name"

		        //hash player inputtext with SHA256
		        new
		            password[128]
				;
				SHA256_PassHash(inputtext, LOGIN_PASS_SALT, password, sizeof(password));
				yoursql_set_field(SQL:0, LOGIN_PASS_TBL_USRPASS_SML, yoursql_get_row(SQL:0, LOGIN_PASS_TBL_USR, "Name = %s", namePlayer), password);//set the password


				if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
					SendClientMessage(playerid, 0x00FF00FF, "SUCCESS: You have successfully registered your account in the server.");
				else
					SendClientMessage(playerid, 0x00FF00FF, "КРУТ!: Ваш ник теперь зарегистрирован на этом сервере.");
		        
		    }
		}
		case DIALOG_ID_LOGIN://if response for login dialog
		{
		    if (! response)//if the player presses 'ESC' button
		    {
		        return Kick(playerid);
		    }
		    else
			{
			    //read player row and retrieve password
		        new
				    namePlayer[MAX_PLAYER_NAME + 1]
				;
				GetPlayerName(playerid, namePlayer, MAX_PLAYER_NAME + 1);

				//read the hashed password
				new
				    acc_password[128]
				;
				yoursql_get_field(SQL:0, LOGIN_PASS_TBL_USRPASS_SML, yoursql_get_row(SQL:0, LOGIN_PASS_TBL_USR, "Name = %s", namePlayer), acc_password);

				//read the current input password and hash it
				new
		            password[128]
				;
				SHA256_PassHash(inputtext, LOGIN_PASS_SALT, password, sizeof(password));

		        if (! inputtext[0] || strcmp(password, acc_password))//if the player's password idoesn't match with the account password
		        {
					if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
						SendClientMessage(playerid, 0xFF0000FF, "ERROR: Incorrect password.");//give warning message and reshow the dialog
					else
						SendClientMessage(playerid, 0xFF0000FF, "ОШИБКА: Неверный пароль.");//give warning message and reshow the dialog
		            
					if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
						return ShowPlayerDialog(playerid, 
												DIALOG_ID_LOGIN, DIALOG_STYLE_PASSWORD, 
												"User Accounts:", 
												"You are registered, please insert your password to continue or create a new account by changing your nickname:", 
												"Login", 
												"Exit");
					else
						return ShowPlayerDialog(playerid, 
												DIALOG_ID_LOGIN, DIALOG_STYLE_PASSWORD, 
												"Аккаунт:", 
												"Вы ввели неверный пароль. Попробуйте снова, либо создайте новый аккаунт, сменив свой ник.:", 
												"Login", 
												"Exit");
		            
		        }

		        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
					SendClientMessage(playerid, 0x00FF00FF, "SUCCESS: You have successfully logged in your account, enjoy playing!");
				else
					SendClientMessage(playerid, 0x00FF00FF, "КРУТ!: Вы успешно авторизовались под своим логином. Желаем вам приятной игры!");
		    }
		}
	}

	return 1;
}

public LoginSystem_OnPlayerDeath(playerid, killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new namePlayer[MAX_PLAYER_NAME + 1], SQLRow:	rowid;
	
	if (killerid != INVALID_PLAYER_ID)
	{
	    //save killerid's kills
		GetPlayerName(killerid, namePlayer, MAX_PLAYER_NAME + 1);
		
		yoursql_set_field_int(SQL:0, LOGIN_PASS_TBL_USRKILLS_SML, rowid, yoursql_get_field_int(SQL:0, LOGIN_PASS_TBL_USRKILLS_SML, rowid) + 1);//add 1 to killer kills
	}

	//save playerid's deaths
	GetPlayerName(playerid, namePlayer, MAX_PLAYER_NAME + 1);
	
	yoursql_set_field_int(SQL:0, LOGIN_PASS_TBL_USRDEATHS_SML, rowid, yoursql_get_field_int(SQL:0, LOGIN_PASS_TBL_USRDEATHS_SML, rowid) + 1);//add 1 to player deaths

	return 1;
}
