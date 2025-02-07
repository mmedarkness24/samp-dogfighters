#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"

forward ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new ownerid = FindVehicleOwner(vehicleid, serverPlayers);
	if (ownerid == NOTSET)
		return;
	if (!IsPlayerConnected(ownerid))
		printf("Vehicle owner not found on server! Vehicleid: %d, Ownerid: %d", vehicleid, ownerid);
	printf("ProcessVehicleDeath:\nvehicleid: %d, owner: %s (%d), killed by: %s (%d)", vehicleid, serverPlayers[ownerid][name], ownerid, serverPlayers[killerid][name], killerid);
	serverPlayers[ownerid][vehicleID] = NOTSET;
	new driverAndPassengers[4];
	GetVehicleDriverAndPassengers(vehicleid, driverAndPassengers[0], driverAndPassengers[1], driverAndPassengers[2], driverAndPassengers[3]);
	
	for (new i = 0; i < 4; i++)
	{
		if (driverAndPassengers[i] == NOTSET || !IsPlayerConnected(driverAndPassengers[i]) || driverAndPassengers[i] == killerid)
			continue;
		printf("Player %s (%d) was in vehicle and will be killed by %s (%d) now", serverPlayers[i][name], i, serverPlayers[killerid][name], killerid);
		ForcePlayerDeath(driverAndPassengers[i], killerid, 14, serverPlayers);
	}
	DestroyVehicle(vehicleid);
}