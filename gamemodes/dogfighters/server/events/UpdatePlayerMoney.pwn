#if !defined SERVER_EVENTS_UPDATE_PLAYER_MONEY
#define SERVER_EVENTS_UPDATE_PLAYER_MONEY
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\anticheat\mainAC.pwn"
#include "dogfighters\player\systems\PlayerMoney.pwn"

forward OnUpdatePlayerMoney(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public OnUpdatePlayerMoney(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	AddPlayerMoney(playerid, 10, serverPlayers);
}
#endif