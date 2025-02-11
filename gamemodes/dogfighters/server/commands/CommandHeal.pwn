#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandHeal(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandHeal(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!AddPlayerMoney(playerid, -1000, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/heal] Not enough money. $1000 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/heal] Недостаточно средств. Необходимо $1000");
	    return 1;
	}
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	
	new messageEnglish[MAX_PLAYER_NAME + 33];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been healed", serverPlayers[playerid][name], playerid);

	new messageRussian[MAX_PLAYER_NAME + 33];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] Исцелён", serverPlayers[playerid][name], playerid);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	return 1;
}