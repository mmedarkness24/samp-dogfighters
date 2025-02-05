#include "dogfighters\server\serverInfo\serverMain.pwn"

forward ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ProcessVehicleDeath(vehicleid, killerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new ownerid = FindVehicleOwner(vehicleid, serverPlayers);
	if (ownerid == -1)
		return;
	serverPlayers[ownerid][vehicleID] = 0;
	DestroyVehicle(vehicleid);
}