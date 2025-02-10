#if !defined VEHICLE_EVENTS_DESTROY
#define VEHICLE_EVENTS_DESTROY

#include "dogfighters\server\serverInfo\serverMain.pwn"

forward destroyPlayerVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public destroyPlayerVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (!DoesServerPlayerHaveVehicle(playerid, serverPlayers))
	{
		printf("[vehicleDestroy] ERROR: destroyPlayerVehicleCheckID:\nplayer: %s (%d). Can't find his vehicle ID!", serverPlayers[playerid][name], playerid);
	    return;
	}
	FindVehicleOwner(serverPlayers[playerid][vehicleID], serverPlayers);
    DestroyVehicle(serverPlayers[playerid][vehicleID]);
    //serverPlayers[playerid][vehicleID] = NOTSET;
	ServerPlayerResetVehicle(playerid, serverPlayers);
}

#endif