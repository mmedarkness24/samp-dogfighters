#if !defined SVR_COMMAND_SPEC
#define SVR_COMMAND_SPEC

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandSpec(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandSpec(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (isnull(params))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Syntax: /spec [ID]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Синтаксис: /spec [ID]");
	    return 1;
    }
	new targetid = strval(params);
    if (PlayerSpectate(playerid, targetid, serverPlayers))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Spectate mode activated");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Вы перешли в режим слежения");
    }
    else
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Cannot spectate this player ID");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/spec] Не получится следить за этим ID");
    }
    return 1;
}

#endif