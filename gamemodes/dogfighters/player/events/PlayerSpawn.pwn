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
	return 1;
}