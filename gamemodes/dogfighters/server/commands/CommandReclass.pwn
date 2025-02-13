#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandReclass(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandReclass(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new messageEnglish[MAX_PLAYER_NAME + 75];
    format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] is changing his class", serverPlayers[playerid][name], playerid);

    new messageRussian[MAX_PLAYER_NAME + 75];
    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] меняет класс", serverPlayers[playerid][name], playerid);
    sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);

    ForceClassSelection(playerid);
	TogglePlayerSpectating(playerid, true);
    TogglePlayerSpectating(playerid, false);
	return 1;
}