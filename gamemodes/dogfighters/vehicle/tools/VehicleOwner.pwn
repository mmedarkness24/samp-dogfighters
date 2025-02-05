#include "dogfighters\server\serverInfo\serverMain.pwn"

forward FindVehicleOwner(vehicleid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//Returns playerid of vehicle's owner or -1 if there is no vehicle's owner 
public FindVehicleOwner(vehicleid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;
		if (vehicleid == serverPlayers[i][vehicleID])
			return i;
	}
	return -1;
}