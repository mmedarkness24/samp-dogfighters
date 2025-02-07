#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"

forward ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new ownerid = FindVehicleOwner(vehicleid, serverPlayers);
	if (ownerid == NOTSET)
		return;
	serverPlayers[ownerid][vehicleID] = NOTSET;
	new driverAndPassengers[4];
	GetVehicleDriverAndPassengers(vehicleid, driverAndPassengers[0], driverAndPassengers[1], driverAndPassengers[2], driverAndPassengers[3]);
	
	for (new i = 0; i < 4; i++)
	{
		if (driverAndPassengers[i] == NOTSET || !IsPlayerConnected(driverAndPassengers[i]) || driverAndPassengers[i] == killerid)
			continue;
		ForcePlayerDeath(driverAndPassengers[i], killerid, 14, serverPlayers);
	}
	DestroyVehicle(vehicleid);
}