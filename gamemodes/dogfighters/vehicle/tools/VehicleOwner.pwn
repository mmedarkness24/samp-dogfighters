#include "dogfighters\server\serverInfo\serverMain.pwn"

forward FindVehicleOwner(severVehicleID, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//Returns playerid of vehicle's owner or -1 if there is no vehicle's owner 
public FindVehicleOwner(severVehicleID, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (severVehicleID < 0)
		return -1;
	new vehicleOwner = NOTSET;
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (severVehicleID == serverPlayers[i][vehicleID])
		{
			//printf("found vehicle owner: %s (%d); previous: %s (%d)", serverPlayers[i][name], i, serverPlayers[vehicleOwner][name], vehicleOwner);
			if (vehicleOwner != NOTSET)
			{
				printf("[VehicleOwner] !WARNING!: Multiple players have same vehicle as owned!\nVehicleid: %d, Players: %s (%d) and %s (%d)",
						severVehicleID, 
						serverPlayers[vehicleOwner][name], 
						vehicleOwner, 
						serverPlayers[i][name], 
						i);
				//serverPlayers[i][vehicleID] = NOTSET;
				ServerPlayerResetVehicle(i, serverPlayers);
			}
			else
				vehicleOwner = i;
		}
	}
	return vehicleOwner;
}