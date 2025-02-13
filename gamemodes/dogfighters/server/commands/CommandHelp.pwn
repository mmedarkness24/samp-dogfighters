#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandHelp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandHelp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    showHelpMessageDialog(playerid, serverPlayers);
    return 1;
}