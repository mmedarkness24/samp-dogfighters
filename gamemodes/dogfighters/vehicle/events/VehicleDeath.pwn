#if !defined EVENTS_VEHICLE_DEATH
#define EVENTS_VEHICLE_DEATH
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"

forward ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	//new driverAndPassengers[4];
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;
		if (GetPlayerDistanceFromPoint(i, x, y, z) < 3)
			ForcePlayerDeath(i, killerid, 14, serverPlayers);
	}
	//GetVehicleDriverAndPassengers(vehicleid, driverAndPassengers[0], driverAndPassengers[1], driverAndPassengers[2], driverAndPassengers[3]);
	//printf("ProcessVehicleDeath %d %d", vehicleid, killerid);
	new vehicleOwnerID = FindVehicleOwner(vehicleid, serverPlayers);
	//printf("ProcessVehicleDeath(pre): vehicleid:%d ownerid:%d", vehicleid, vehicleOwnerID);
	if (vehicleOwnerID == NOTSET)
		return 1;
	if (!IsPlayerConnected(vehicleOwnerID))
		printf("Vehicle owner not found on server! Vehicleid: %d, Ownerid: %d", vehicleid, vehicleOwnerID);
	/*new Float:ownerHealth;
	GetPlayerHealth(vehicleOwnerID, ownerHealth);
	if(ownerHealth < 1 && GetPVarInt(vehicleOwnerID, "Death") == 0)
		ForcePlayerDeath(vehicleOwnerID, killerid, 14, serverPlayers);*/
	printf("ProcessVehicleDeath:\nvehicleid: %d, owner: %s (%d), killed by: %s (%d)", vehicleid, serverPlayers[vehicleOwnerID][name], vehicleOwnerID, serverPlayers[killerid][name], killerid);
	/*printf("Driver ID: %d\nPassenger1: %d\nPassenger2: %d\nPassenger3: %d", driverAndPassengers[0], driverAndPassengers[1], driverAndPassengers[2], driverAndPassengers[3]);
	new driverHitID = GetPVarInt(driverAndPassengers[0], "Hit");
	if (driverHitID != NOTSET && !GetPVarInt(driverHitID, "Death"))
		ForcePlayerDeath(driverAndPassengers[0], driverHitID, GetPVarInt(driverAndPassengers[0], "HReason"), serverPlayers);
	for (new i = 1; i < 4; i++)
	{
		if (driverAndPassengers[i] == NOTSET || !IsPlayerConnected(driverAndPassengers[i]))
			continue;
		printf("Player %s (%d) was in vehicle and will be killed by %s (%d) now", serverPlayers[i][name], i, serverPlayers[killerid][name], killerid);
		ForcePlayerDeath(driverAndPassengers[i], killerid, 14, serverPlayers);
	}*/
	destroyPlayerVehicle(vehicleOwnerID, serverPlayers);
	//ServerPlayerResetVehicle(vehicleOwnerID, serverPlayers);
	CreateExplosion(x, y, z, 3, 10);
	//DestroyVehicle(vehicleid);
	return 1;
}
#endif