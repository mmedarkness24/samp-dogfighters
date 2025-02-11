#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandLanguage(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandLanguage(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    showSelectLanguageDialog(playerid, serverPlayers);
    return 1;
}