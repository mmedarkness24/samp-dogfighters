#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandKill(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandKill(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new messageEnglish[MAX_PLAYER_NAME + 75];
    format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has commited suicide", serverPlayers[playerid][name], playerid);

    new messageRussian[MAX_PLAYER_NAME + 95];
    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] совершил UNKNOWNERROR_ROSCUMNADZOR_BANNED", serverPlayers[playerid][name], playerid);
    sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);

    SetPlayerHealth(playerid, 0);
}