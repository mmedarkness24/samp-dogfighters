#if !defined EVENTS_PLAYER_KILL
#define EVENTS_PLAYER_KILL
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"
#include "dogfighters\database\databaseMain.pwn"

forward ProcessPlayerKill(playerid, victimid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward AddPlayerKills(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessPlayerKill(playerid, victimid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	AddPlayerKills(playerid, 1, serverPlayers);
	if (playerid != victimid)
		LoginSystem_OnPlayerDeath(NOTSET, playerid, NOTSET, serverPlayers);
	
	new message[MAX_PLAYER_NAME + 128];
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
		format(message, sizeof(message), "Nice kill! It was %s (%d)", serverPlayers[victimid][name], victimid);
	else
		format(message, sizeof(message), "Игрок %s (%d) убит вами", serverPlayers[victimid][name], victimid);
	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
	
	printf("ProcessPlayerKill %d -> %d [%d] - $%d", playerid, victimid, reason, serverPlayers[victimid][money], serverPlayers[playerid][money]);
	if (serverPlayers[victimid][money] < 100)//	< 500
		return;
	
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
		format(message, sizeof(message), "You will earn $%d for killing player %s (%d)", serverPlayers[victimid][money], serverPlayers[victimid][name], victimid);
	else
		format(message, sizeof(message), "Вы получили $%d от игрока %s (%d), после его смерти", serverPlayers[victimid][money], serverPlayers[victimid][name], victimid);
	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
	
	if (serverPlayers[victimid][language] == PLAYER_LANGUAGE_ENGLISH)
		format(message, sizeof(message), "You were killed by %s (%d). He now earns all your money.", serverPlayers[playerid][name], victimid);
	else
		format(message, sizeof(message), "Вас убил %s (%d). Теперь он заберёт все ваши наличные.", serverPlayers[playerid][name], victimid);
	SendClientMessage(victimid, COLOR_SYSTEM_MAIN, message);
	GiveAllMoney(victimid, playerid, serverPlayers);
}

public AddPlayerKills(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (!IsPlayerConnected(playerid))
		return;
	serverPlayers[playerid][kills] += amount;
}

#endif