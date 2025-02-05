#if !defined SERVER_EVENTS_UPDATE_PLAYER_HEALTH
#define SERVER_EVENTS_UPDATE_PLAYER_HEALTH

#include "dogfighters\server\serverInfo\serverMain.pwn"

forward OnUpdatePlayerHealth(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public OnUpdatePlayerHealth(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	// TODO
}

#endif