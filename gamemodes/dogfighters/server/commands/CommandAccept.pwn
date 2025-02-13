#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandAccept(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandAccept(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    PlayerAcceptDuel(playerid, serverPlayers);
    return 1;
}