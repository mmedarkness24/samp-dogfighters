#if !defined SERVER_EVENTS_UPDATE_PLAYER_SCORE
#define SERVER_EVENTS_UPDATE_PLAYER_SCORE
#include "dogfighters\server\serverInfo\serverMain.pwn"

forward OnUpdatePlayerScore(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public OnUpdatePlayerScore(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	SetPlayerScore(playerid, serverPlayers[playerid][money]);
}


#endif