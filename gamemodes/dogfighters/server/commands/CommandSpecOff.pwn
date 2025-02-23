#if !defined SVR_COMMAND_SPECOFF
#define SVR_COMMAND_SPECOFF

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandSpecOff(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandSpecOff(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    PlayerUnspectate(playerid, serverPlayers);
    return 1;
}

#endif