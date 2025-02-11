#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandTeleport(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandTeleport(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!AddPlayerMoney(playerid, -100, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/teleport] Not enough money. $100 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/teleport] Недостаточно средств! Необходимо $100");
	    return 1;
	}
	new Float:x, Float:y, Float:z;
	if (!strcmp(params[0], "lv", true))
	{
	    x = 1550;
	    y = 1452;
	    z = 11;
		
        new messageEnglish[MAX_PLAYER_NAME + 75];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to Las Venturas International Airport", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 75];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в Международный Аэропорт Лас Вентурас", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "ls", true))
	{
	    x = 1783.3;
	    y = -2447;
	    z = 14;
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to Los Santos International Airport", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в Международный Аэропорт Лос Сантос", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "sf", true))
	{
		x = -1565;
	    y = -258;
	    z = 15;
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to San Fierro International Airport", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в Международный Аэропорт Сан Фиерро", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "desert", true))
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
		
		new messageEnglish[MAX_PLAYER_NAME + 61];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Desert airspace", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 61];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в лётную зону \"пустыня\"", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "gate", true))
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
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Golden Gate Bridge airspace", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 73];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в лётную зону \"Мост Золотые Ворота\"", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "beach", true))
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
		
		new messageEnglish[MAX_PLAYER_NAME + 75];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the LS Beach airspace", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 75];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в лётную зону \"Пляж ЛС\"", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else if (!strcmp(params[0], "chill", true))
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
		
		new messageEnglish[MAX_PLAYER_NAME + 73];
		format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been teleported to the Chiliad airspace", serverPlayers[playerid][name], playerid);

		new messageRussian[MAX_PLAYER_NAME + 78];
		format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] переместился в лётную зону \"Гора Чилиад\"", serverPlayers[playerid][name], playerid);
		sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	}
	else
	{
		x = 0;
	    y = 0;
		z = 0;
	}
	if (x == 0 && y == 0 && z == 0)
	{
        if (!AddPlayerMoney(playerid, 100, serverPlayers))
            printf("Cannot return money to player: %s (%d) (try to teleport to unknown place)", serverPlayers[playerid][name], playerid);
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/teleport]: Unknown place name");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/teleport]: Неизвестное место");
		return 1;
	}
    new vehID = GetPlayerVehicleID(playerid);
    if (vehID != 0)
    	SetVehiclePos(vehID, x, y, z);
	else
	    SetPlayerPos(playerid, x, y, z);
	return 1;
}