#if !defined COMMAND_ADM_BAN
#define COMMAND_ADM_BAN

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"
#include "dogfighters\database\databaseMain.pwn"

forward CommandBanAdm(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandBanAdm(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new playerLevel = LoginSystem_GetAccessLevel(playerid, serverPlayers);
    if (playerLevel < 3)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Not enough access rights for this command");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Недостаточно прав для использования этой команды");
        return 1;
    }
    if (isnull(params))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Syntax: /ban [ID]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Синтаксис: /ban [ID]");
	    return 1;
    }
    new targetid, reason[32];
    if (sscanf(params, "ds[32]", targetid, reason))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Syntax: /ban [ID] [Reason]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Синтаксис: /ban [ID] [Причина]");
	    return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Player is not connected");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Игрок с таким ID не подключен к серверу");
	    return 1;
    }
    if (targetid == playerid)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] You cannot ban yourself");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Оригинально, но нельзя кикнуть самого себя");
	    return 1;
    }
    new targetLevel = LoginSystem_GetAccessLevel(targetid, serverPlayers);
    if (targetLevel >= playerLevel)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Not enough access rights to ban this player");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/ban] Недостаточно прав чтобы кикнуть этого игрока");
	    return 1;
    }
    new messageRU[128];
    new messageEN[128];
    format(messageRU, sizeof(messageRU), "Администратор %s (%d) забанил игрока %s (%d) [причина: %s]",
                                                                                                    serverPlayers[playerid][name],
                                                                                                    playerid,
                                                                                                    serverPlayers[targetid][name],
                                                                                                    targetid,
                                                                                                    reason);
    format(messageEN, sizeof(messageEN), "Administrator %s (%d) has banned player %s (%d) [reason: %s]",
                                                                                                    serverPlayers[playerid][name],
                                                                                                    playerid,
                                                                                                    serverPlayers[targetid][name],
                                                                                                    targetid,
                                                                                                    reason);
    sendLocalizedMessage(messageRU, messageEN, COLOR_SYSTEM_DISCORD, serverPlayers);
    Ban(targetid);
    return 1;
}

#endif