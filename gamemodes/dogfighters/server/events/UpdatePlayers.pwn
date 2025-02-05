#if !defined SERVER_EVENTS_UPDATE_PLAYERS
#define SERVER_EVENTS_UPDATE_PLAYERS

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\events\UpdatePlayerMoney.pwn"
#include "dogfighters\server\events\UpdatePlayerHealth.pwn"
#include "dogfighters\server\events\UpdatePlayerScore.pwn"
#include "dogfighters\server\events\UpdatePlayerAC.pwn"

forward OnUpdateAllPlayers(serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public OnUpdateAllPlayers(serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;
		OnUpdatePlayerMoney(i, serverPlayers);
		OnUpdatePlayerScore(i, serverPlayers);
	}
}

#endif