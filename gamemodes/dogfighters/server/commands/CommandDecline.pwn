#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandDecline(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandDecline(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    PlayerDeclineDuel(playerid, serverPlayers);
    return 1;
}