#if !defined PLAYER_SYSTEMS_PLAYER_MONEY
#define PLAYER_SYSTEMS_PLAYER_MONEY

#include "dogfighters\server\anticheat\mainAC.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward AddPlayerMoney(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward CheckPlayerMoney(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward GiveMoney(playeridFrom, playeridTo, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward GiveAllMoney(playeridFrom, playeridTo, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//Adds money to player with ID, returns 1 if OK, 0 if ERROR
public AddPlayerMoney(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (!IsPlayerConnected(playerid))
	{
		printf("Cannot add cash to player %d. Player is not connected!", playerid);
		return 0;
	}
	new cashValue = serverPlayers[playerid][money] + amount;
	if (cashValue < 0 || cashValue > 99999999)
	{
		printf("Cannot add $%d cash to player %s (%d) (player have $%d and will have %d)", amount, serverPlayers[playerid][name], playerid, serverPlayers[playerid][money], cashValue);
		return 0;
	}
	serverPlayers[playerid][money] = cashValue;
	CheckPlayerMoney(playerid, serverPlayers);
	
	// printf("Added $%d money to %s (%d)", amount, serverPlayers[playerid][name], playerid);
	return 1;
}

public CheckPlayerMoney(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new cash = GetPlayerMoney(playerid);
	if (cash == serverPlayers[playerid][money])
		return 1;
	GivePlayerMoney(playerid, serverPlayers[playerid][money] - cash);
	return 0;
}

public GiveMoney(playeridFrom, playeridTo, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (amount < 1)
	{
		if (serverPlayers[playeridFrom][language] == PLAYER_LANGUAGE_ENGLISH)
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "Too low money amount to give");
		else
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "Ќевозможно передать так мало денег.");
		return 0;
	}
	if (serverPlayers[playeridFrom][money] < amount)
	{
		if (serverPlayers[playeridFrom][language] == PLAYER_LANGUAGE_ENGLISH)
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "You can't give more cash than you have");
		else
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "¬ы пытаетесь передать больше денег чем у вас есть");
		return 0;
	}
	new cash = serverPlayers[playeridTo][money] + amount;
	if (cash > 99999999)
	{
		if (serverPlayers[playeridFrom][language] == PLAYER_LANGUAGE_ENGLISH)
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "Can't give more money to this player");
		else
			SendClientMessage(playeridFrom, COLOR_SYSTEM_MAIN, "Ётому игроку нельз€ передать ещЄ больше денег");
		return 0;
	}
	if (cash < 0)
	{
		printf("Some mistake in player/systems/PlayerMoney/GiveMoney(f, t, a, sP): cash < 0\nCash operation try failed: %s (%d) $%d -> %s (%d) $%d [Sum: $%d]", 
			serverPlayers[playeridFrom][name],
			playeridFrom,
			serverPlayers[playeridFrom][money],
			serverPlayers[playeridTo][name],
			playeridTo,
			serverPlayers[playeridTo][money],
			cash);
		return 0;
	}
	AddPlayerMoney(playeridFrom, -amount, serverPlayers);
	AddPlayerMoney(playeridTo, amount, serverPlayers);
	return 1;
}

public GiveAllMoney(playeridFrom, playeridTo, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	GiveMoney(playeridFrom, playeridTo, serverPlayers[playeridFrom][money], serverPlayers);
}

#endif