#if !defined COMMAND_ADM_SETLEVEL
#define COMMAND_ADM_SETLEVEL

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"
#include "dogfighters\database\databaseMain.pwn"

forward CommandSetLevelAdm(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandSetLevelAdm(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (isnull(params))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] Syntax: /setlevel [ID] [Level]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] Синтаксис: /setlevel [ID] [Уровень]");
	    return 1;
    }
	new targetid = NOTSET, level = NOTSET;
	if (sscanf(params, "dd", targetid, level))
	{
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] Syntax: /setlevel [ID] [Level]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] Синтаксис: /setlevel [ID] [Уровень]");
	    return 1;
	}
    if (LoginSystem_GetAccessLevel(playerid, serverPlayers) < 10)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] You don't have access to this command");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/setlevel] У вас нет доступа к этой команде");
	    return 1;
    }
    new message[84];
    if (LoginSystem_SetAccessLevel(targetid, level, serverPlayers))
    {
        
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	format(message, sizeof(message), "[/setlevel] %s (%d) now have access level %d", serverPlayers[targetid][name], targetid, level);
		else
            format(message, sizeof(message), "[/setlevel] Уровень админ-прав %s (%d) изменён на %d", serverPlayers[targetid][name], targetid, level);
    }
    else
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	format(message, sizeof(message), "[/setlevel] Cannot set access rights %d for player ID: %d", level, targetid);
		else
            format(message, sizeof(message), "[/setlevel] Не удалось установить права доступа %d игроку с ID: %d", level, targetid);
    }
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
    return 1;
}

#endif