#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

#define AC_ATTENTION_LIMIT 10

forward AddActivitySuspect(playerid, weight, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward CheckPlayerActivity(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward ResetPlayerActivity(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

forward CheckAllPlayersActivity(serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//Increases suspect activity value depend of suspect weight. Returns 0 if calcelled.
public AddActivitySuspect(playerid, weight, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (!IsPlayerConnected(playerid))
		return 0;
	serverPlayers[playerid][anticheat] += weight;
	new messageEN[256];
	format(messageEN, sizeof(messageEN), "[AC]: Player {COLOR_MAIN}%s (%d) {COLOR_ANTICHEAT} was suspected by AC system");
	
	new messageRU[256];
	format(messageRU, sizeof(messageRU), "[AC]: Игрок {COLOR_MAIN}%s (%d) {COLOR_ANTICHEAT}был пойман за руку как дешёвка");
	
	sendLocalizedMessage(messageRU, messageEN, COLOR_SYSTEM_ANTICHEAT, serverPlayers);
	return 1;
}

//Returns 0 if player is OK and 1 if hight activity
public CheckPlayerActivity(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (serverPlayers[playerid][anticheat] > AC_ATTENTION_LIMIT)
		return 1;
	return 0;
}

public ResetPlayerActivity(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	serverPlayers[playerid][anticheat] = 0;
}

public CheckAllPlayersActivity(serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (!CheckPlayerActivity(i, serverPlayers))
		{
			ResetPlayerActivity(i, serverPlayers);
			continue;
		}
		if (serverPlayers[i][language] == PLAYER_LANGUAGE_ENGLISH)
			SendClientMessage(i, COLOR_SYSTEM_MAIN, "Your server activity was too suspicious. You was banned by server anticheat.");
		else
			SendClientMessage(i, COLOR_SYSTEM_MAIN, "Вы были забанены античитом за подозрительную активность на сервре.");
		Ban(i);
	}
}