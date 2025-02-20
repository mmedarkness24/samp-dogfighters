#include "dogfighters\server\serverInfo\serverMain.pwn"

forward ProcessPlayerSpawn(playerid, score, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessPlayerSpawn(playerid, score, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	printf("Spawning a player %s (%d) and destroying his vehicle: %d", serverPlayers[playerid][name], playerid, serverPlayers[playerid][vehicleID]);
	if (DoesServerPlayerHaveVehicle(playerid, serverPlayers))
		destroyPlayerVehicle(playerid, serverPlayers);
		//DestroyVehicle(playerid);
	SetPVarInt(playerid, "Death", 0);
	SetPVarInt(playerid, "Hit", -1);
	SetPVarInt(playerid, "HReason", -1);
	
	SetPlayerScore(playerid, score);

	if (!serverPlayers[playerid][isLoggedIn])
	{
		printf("[!]> Player %s (%d) was trying to spawn without login", serverPlayers[playerid][name], playerid);
		if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
			SendClientMessage(playerid, COLOR_SYSTEM_RED, "You were trying to spawn without login and will be kicked by anticheat system");
		else
			SendClientMessage(playerid, COLOR_SYSTEM_RED, "Вы попытались заспавниться не залогинившись и были кикнуты античитом.");
		Kick(playerid);
	}
	return 1;
}