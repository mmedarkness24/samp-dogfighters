#include <a_samp>
#include <core>
#include <float>

#include "sscanf2.inc"

#include "dogfighters/main.pwn"

#define DEBUG_MODE true

#define MODE_NAME 			"Dogfighters"
#define MODE_VER_MAJOR 		"0.0.1"
#define MODE_VER_UPDATE 	"upd:03.02.2025"
#define MODE_AUTHOR 		"d7.KrEoL"
#define MODE_MAX_PLAYERS 	64

#define COLOR_SYSTEM_MAIN 0x0D6EFDFF
#define COLOR_SYSTEM_DISCORD 0x00A2FFFF
#define COLOR_SYSTEM_RED 0xFF0000FF
#define COLOR_SYSTEM_GREEN 0x00FF00FF
#define COLOR_SYSTEM_BLUE 0x0000FFFF

#define COLOR_MAIN {0D6EFD}
#define COLOR_DISCORD {00A2FF}
#define COLOR_RED {FF0000}
#define COLOR_GREEN {00FF00}
#define COLOR_BLUE {0000FF}

#define VEHICLES_MINIMAL_MODEL_ID 400
#define VEHICLES_MAXIMAL_MODEL_ID 605
#define VEHICLES_FORBIDDEN_MODELS_CHECK vehID == 435 || vehID == 411 || vehID == 450 || vehID == 464 || vehID == 465 || vehID == 501 || vehID == 537 || vehID == 538 || vehID == 564 || vehID == 569 || vehID == 570 || vehID == 590 || vehID == 594

#if !defined dcmd
	#define dcmd(%1,%2,%3) if(!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, " "))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#endif

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

forward setPlayerConnectionStatus(playerid, bool:isConnectedStatus);

forward sendLocalizedMessage(message_ru[], message_en[], color);

forward destroyPlayerVehicle(playerid);

new _serverPlayers[MODE_MAX_PLAYERS][serverPlayer];

main()
{
		print("\n----------------------------------");
		printf("Running %s Gamemode\n", MODE_NAME);
		printf("Author: %s", MODE_AUTHOR);
		printf("Version: %s (%s)", MODE_VER_MAJOR, MODE_VER_UPDATE);
		if (GetMaxPlayers() > MODE_MAX_PLAYERS)
		{
		    printf("\n[!WARNING!]: Server max players (%d) is more then this mode is supporting (%d)!", GetMaxPlayers(), MODE_MAX_PLAYERS);
		    print("[!IMPORTANT!]: Some systems may not work correctly, please change \"maxplayers\" to value \"64\" or lower in server.cfg!");
		}
		print("----------------------------------\n");
}

public OnGameModeInit()
{
	new string[45];
	format(string, sizeof(string), "%s ver. %s", MODE_NAME, MODE_VER_MAJOR);
	SetGameModeText(string);
	format(string, sizeof(string), "mapname %s", MODE_VER_UPDATE);
	SendRconCommand(string);
	format(string, sizeof(string), "language English, Russian");
	SendRconCommand(string);
	
	//UsePedAnims(0);
	AddPlayerClass(181,342.61,2533.93,17,270.1425,0,0,0,0,-1,-1);
	AddPlayerClass(179,293.7,2031.31,18,270.1425,0,0,0,0,-1,-1);
	AddPlayerClass(287,-1409.96,496.92,19,270.1425,0,0,0,0,-1,-1);
	return 1;
}

public OnGameModeExit()
{
	print("Unloading Dogfighters Gamemode (exit)");
	return 1;
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Dogfighters ~g~Server",5000,5);
	setPlayerConnectionStatus(playerid, true);
	showSelectLanguageDialog(playerid, _serverPlayers);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	setPlayerConnectionStatus(playerid, false);
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#if DEBUG_MODE == true
    printf("OnDialogResponse %d %d %d %d %s", playerid, dialogid, response, listitem, inputtext);
    #endif
	switch(dialogid)
	{
	    case 0:
	    {
		}
	    case DIALOG_SELECT_LANGUAGE:
	    {
			_serverPlayers[playerid][language] = !response;
			if (_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
			    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "You will now receive english language messages from server");
			else
			    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Сообщения от сервера теперь будут приходить на Русском");
	    }
   }
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(vehicle,7,cmdtext);
	dcmd(veh,3,cmdtext);
	dcmd(car,3,cmdtext);
	
	dcmd(heal,4,cmdtext);
	dcmd(hp,2,cmdtext);
	dcmd(armour,6,cmdtext);
	dcmd(arm,3,cmdtext);
	
	dcmd(repair,6,cmdtext);
	dcmd(rep,3,cmdtext);
	dcmd(r,1,cmdtext);
	
	dcmd(teleport,8,cmdtext);
	dcmd(tp,2,cmdtext);
	
	dcmd(language,8,cmdtext);
	dcmd(lang,4,cmdtext);
	dcmd(setlang,7,cmdtext);
	return 0;
}

dcmd_vehicle(playerid, params[])
{
    #if DEBUG_MODE == true
	    printf("cmd: vehicle[pre](playerid=%d params[0]=%s, params[1]=%s, params[2]=%s, params[3]=%s)", playerid, params[0], params[2], params[2]);
	#endif
    if (isnull(params))
    {
        showSelectVehicleDialog(playerid, _serverPlayers);
    }
	new vehID, color1, color2;
	vehID = strval(params[0]);
	
	color1 = strval(params[2]);
	color2 = strval(params[3]);
	if (color1 == 0 && color2 == 0)
	{
	    color1 = random(255);
	    color2 = random(255);
	}
	#if DEBUG_MODE == true
	    printf("cmd: vehicle(%d, params=%s, vehID=%d, color1=%d, color2=%d)", playerid, params, vehID, color1, color2);
	#endif
	if (vehID < 400 || vehID > 605)
	{
	    if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID! 171");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID автомобиля 173");
		return 1;
	}
	if (VEHICLES_FORBIDDEN_MODELS_CHECK)
	{
	    if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID! 179");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID автомобиля 181");
		return 1;
	}
 	destroyPlayerVehicle(playerid);
	new Float:x, Float:y, Float:z, Float:facingAngle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, facingAngle);
	new result = CreateVehicle(vehID, x, y, z + 2, facingAngle, color1, color2, -1, 0);
	if (!result || result == INVALID_VEHICLE_ID)
	{
		if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID! 191");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID автомобиля 193");
	}
	_serverPlayers[playerid][vehicleID] = result;
	result = PutPlayerInVehicle(playerid, _serverPlayers[playerid][vehicleID], 0);
	if (!result)
	{
	    if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Unknown error when creating vehicle! 200");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неизвестная ошибка при создании авто! 201");
		destroyPlayerVehicle(playerid);
		return 1;
	}
	if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Vehicle created!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Авто создано!");
		    
	new messageEnglish[MAX_PLAYER_NAME + 46];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has taken a new vehicle: %d", _serverPlayers[playerid][name], playerid, vehID);
	
	new messageRussian[MAX_PLAYER_NAME + 46];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] заспавнил новый транспорт: %d", _serverPlayers[playerid][name], playerid, vehID);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
    //SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);
	return 1;
}

dcmd_veh(playerid, params[])
{
	return dcmd_vehicle(playerid, params);
}

dcmd_car(playerid, params[])
{
	return dcmd_vehicle(playerid, params);
}

dcmd_heal(playerid, params[])
{
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	/*new message[MAX_PLAYER_NAME + 33];
	format(message, sizeof(message), "Player %s [%d] has been healed", serverPlayers[playerid][name], playerid);*/
	//SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);
	
	new messageEnglish[MAX_PLAYER_NAME + 33];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been healed", _serverPlayers[playerid][name], playerid);

	new messageRussian[MAX_PLAYER_NAME + 33];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] был исцелён", _serverPlayers[playerid][name], playerid);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	return 1;
}

dcmd_hp(playerid, params[])
{
	return dcmd_heal(playerid, params);
}

dcmd_armour(playerid, params[])
{
	return dcmd_heal(playerid, params);
	/*SetPlayerArmour(playerid, 100);
	new message[MAX_PLAYER_NAME + 33];
	format(message, sizeof(message), "Player %s [%d] has been re-armoured", serverPlayers[playerid][name], playerid, vehID);*/
}

dcmd_arm(playerid, params[])
{
	return dcmd_armour(playerid, params);
}

dcmd_repair(playerid, params[])
{
    new vehID = GetPlayerVehicleID(playerid);
    if (vehID > 0)
        RepairVehicle(vehID);
    /*new message[MAX_PLAYER_NAME + 38];
	format(message, sizeof(message), "Player %s [%d] repaired his vehicle", serverPlayers[playerid][name], playerid);
	SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
	
	new messageEnglish[MAX_PLAYER_NAME + 38];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] repaired his vehicle", _serverPlayers[playerid][name], playerid);

	new messageRussian[MAX_PLAYER_NAME + 38];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] понинил своё авто", _serverPlayers[playerid][name], playerid);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	return 1;
}

dcmd_rep(playerid, params[])
{
	return dcmd_repair(playerid, params);
}

dcmd_r(playerid, params[])
{
	return dcmd_repair(playerid, params);
}

dcmd_teleport(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	if (!strcmp(params[0], "lv"))
	{
	    x = 1550;
	    y = 1452;
	    z = 11;
	    /*new message[MAX_PLAYER_NAME + 75];
		format(message, sizeof(message), "Player %s [%d] has been teleported to Las Venturas International Airport", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
        new messageEnglish[MAX_PLAYER_NAME + 75];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to Las Venturas International Airport", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 75];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в Международный Аэропорт Лас Вентурас", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "ls"))
	{
	    x = 1783.3;
	    y = -2447;
	    z = 14;
	    /*new message[MAX_PLAYER_NAME + 73];
		format(message, sizeof(message), "Player %s [%d] has been teleported to Los Santos International Airport", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to Los Santos International Airport", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в Международный Аэропорт Лос Сантос", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "sf"))
	{
		x = -1565;
	    y = -258;
	    z = 15;
	    /*new message[MAX_PLAYER_NAME + 73];
		format(message, sizeof(message), "Player %s [%d] has been teleported to San Fierro International Airport", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to San Fierro International Airport", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в Международный Аэропорт Сан Фиерро", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "desert"))
	{
	    switch(random(7))
	    {
	        case 0:
	        {
	            x = -394;
			    y = 2287;
			    z = 339;
	        }
	        case 1:
	        {
	            x = -95;
			    y = 2196;
			    z = 339;
	        }
	        case 2:
	        {
	            x = -274;
			    y = 1866;
			    z = 339;
	        }
	        case 3:
	        {
	            x = 103;
			    y = 1719;
			    z = 339;
	        }
	        case 4:
	        {
	            x = 177;
			    y = 2363;
			    z = 339;
	        }
	        case 5:
	        {
	            x = -746;
			    y = 2540;
			    z = 339;
	        }
	        case 6:
	        {
	            x = 60;
			    y = 1448;
			    z = 339;
	        }
	    }
	    /*new message[MAX_PLAYER_NAME + 61];
		format(message, sizeof(message), "Player %s [%d] has been teleported to the Desert airspace", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 61];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Desert airspace", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 61];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в полётную зону пустыни", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "gate"))
	{
	    switch(random(7))
	    {
	        case 0:
	        {
	            x = -2525;
			    y = 2158;
			    z = 255;
	        }
	        case 1:
	        {
	            x = -2089;
			    y = 1876;
			    z = 255;
	        }
	        case 2:
	        {
	            x = -2434;
			    y = 1839;
			    z = 255;
	        }
	        case 3:
	        {
	            x = -2114;
			    y = 1568;
			    z = 255;
	        }
	        case 4:
	        {
	            x = -2266;
			    y = 1911;
			    z = 255;
	        }
	        case 5:
	        {
	            x = -2821;
			    y = 1986;
			    z = 255;
	        }
	        case 6:
	        {
	            x = -2772;
			    y = 1693;
			    z = 255;
	        }
	    }
	    /*new message[MAX_PLAYER_NAME + 73];
		format(message, sizeof(message), "Player %s [%d] has been teleported to the Golden Gate Bridge airspace", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Golden Gate Bridge airspace", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в полётную зону моста Золотые Ворота", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "beach"))
	{
	    switch(random(7))
	    {
	        case 0:
	        {
	            x = 365;
			    y = -2061;
			    z = 115;
	        }
	        case 1:
	        {
	            x = 126;
			    y = -1942;
			    z = 115;
	        }
	        case 2:
	        {
	            x = 300;
			    y = -1774;
			    z = 115;
	        }
	        case 3:
	        {
	            x = 641;
			    y = -1930;
			    z = 115;
	        }
	        case 4:
	        {
	            x = 644;
			    y = -2282;
			    z = 115;
	        }
	        case 5:
	        {
	            x = 179;
			    y = -2247;
			    z = 115;
	        }
	        case 6:
	        {
	            x = 71;
			    y = -1819;
			    z = 115;
	        }
	    }
	    /*new message[MAX_PLAYER_NAME + 73];
		format(message, sizeof(message), "Player %s [%d] has been teleported to the Beach airspace", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 75];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the LS Beach airspace", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 75];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в полётную зону Пляжа ЛС", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else if (!strcmp(params[0], "chill"))
	{
	    switch(random(7))
	    {
	        case 0:
	        {
	            x = -2379;
			    y = -1567;
			    z = 700;
	        }
	        case 1:
	        {
	            x = -2560;
			    y = -1319;
			    z = 700;
	        }
	        case 2:
	        {
	            x = -2697;
			    y = -1549;
			    z = 700;
	        }
	        case 3:
	        {
	            x = -2194;
			    y = -1502;
			    z = 700;
	        }
	        case 4:
	        {
	            x = -2213;
			    y = -1064;
			    z = 700;
	        }
	        case 5:
	        {
	            x = -2844;
			    y = -1886;
			    z = 700;
	        }
	        case 6:
	        {
	            x = -2891;
			    y = -1075;
			    z = 700;
	        }
	    }
	    /*new message[MAX_PLAYER_NAME + 73];
		format(message, sizeof(message), "Player %s [%d] has been teleported to the Chiliad airspace", serverPlayers[playerid][name], playerid);
		SendClientMessageToAll(COLOR_SYSTEM_DISCORD, message);*/
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Chiliad airspace", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 78];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] телепортировался в полётную зону горы Чилиад", _serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else
	{
		x = 0;
	    y = 0;
		z = 0;
	}
	if (x == 0 && y == 0 && z == 0)
	{
	    if(_serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/teleport]: Unknown place name");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/teleport]: Данное место неизвестно");
		return 1;
	}
    new vehID = GetPlayerVehicleID(playerid);
    if (vehID != 0)
    	SetVehiclePos(vehID, x, y, z);
	else
	    SetPlayerPos(playerid, x, y, z);
	return 1;
}

dcmd_tp(playerid, params[])
{
	return dcmd_teleport(playerid, params);
}

dcmd_language(playerid, params[])
{
    showSelectLanguageDialog(playerid, _serverPlayers);
	return 1;
}

dcmd_lang(playerid, params[])
{
	return dcmd_language(playerid, params);
}

dcmd_setlang(playerid, params[])
{
	return dcmd_language(playerid, params);
}

public setPlayerConnectionStatus(playerid, bool:isConnectedStatus)
{
	_serverPlayers[playerid][isConnected] = isConnectedStatus;
	if (_serverPlayers[playerid][isConnected])
	{
	    new playerName[MAX_PLAYER_NAME + 1];
		new result = GetPlayerName(playerid, playerName, sizeof(playerName));
        #if DEBUG_MODE == true
		if (!result)
		{
		    printf("Cannot get player's name: %s (%d)", playerName, playerid);
		}
		#endif
		_serverPlayers[playerid][name] = playerName;
		
		new messageEnglish[MAX_PLAYER_NAME + 45];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been connected to server!", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 36];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] подключился к серверу", _serverPlayers[playerid][name], playerid);
		
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
	else
	{
	    destroyPlayerVehicle(playerid);
     	//format(serverPlayers[playerid][name[0]], sizeof(serverPlayers[playerid][name[0]]), "");
     	
     	new messageEnglish[MAX_PLAYER_NAME + 51];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been disconnected from server=(", _serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 38];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] отключился от сервера=(", _serverPlayers[playerid][name], playerid);

		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD);
	}
}
public destroyPlayerVehicle(playerid)
{
	if (_serverPlayers[playerid][vehicleID] == 0)
	    return;
    DestroyVehicle(_serverPlayers[playerid][vehicleID]);
    _serverPlayers[playerid][vehicleID] = 0;
}
public sendLocalizedMessage(message_ru[], message_en[], color)
{
	new Message[145];
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
	    if (!IsPlayerConnected(i))
	        continue;
	    if (_serverPlayers[i][language] == PLAYER_LANGUAGE_ENGLISH)
	        SendClientMessage(i, color, message_en);
		else
		    SendClientMessage(i, color, message_ru);
	}
}
