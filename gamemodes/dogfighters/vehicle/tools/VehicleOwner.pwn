#include "dogfighters\server\serverInfo\serverMain.pwn"

forward FindVehicleOwner(severVehicleID, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//Returns playerid of vehicle's owner or -1 if there is no vehicle's owner 
public FindVehicleOwner(severVehicleID, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	new result = NOTSET;
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		/*if (!IsPlayerConnected(i))
			continue;*/
		if (severVehicleID == serverPlayers[i][vehicleID])
		{
			if (result != NOTSET)
			{
				printf("[VehicleOwner] !WARNING!: Multiple players have same vehicle as owned!\nVehicleid: %d, Players: %s (%d) and %s (%d)",
						severVehicleID, 
						serverPlayers[result][name], 
						result, 
						serverPlayers[i][name], 
						i);
				serverPlayers[i][vehicleID] = NOTSET;
			}
			result = i;
		}
	}
	return result;
}