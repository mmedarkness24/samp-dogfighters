#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandFireFix(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandFireFix(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new messageEnglish[MAX_PLAYER_NAME + 33];
    new messageRussian[MAX_PLAYER_NAME + 33];
	if (ServerPlayerSwitchFireFix(playerid, serverPlayers))
    {
        format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has enabled /firefix for himself", serverPlayers[playerid][name], playerid);
	    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] включил для себя /firefix", serverPlayers[playerid][name], playerid);
    }
    else
    {
        format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has disabled /firefix for himself", serverPlayers[playerid][name], playerid);
	    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] отключил для себя /firefix", serverPlayers[playerid][name], playerid);
    }
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	return 1;
}