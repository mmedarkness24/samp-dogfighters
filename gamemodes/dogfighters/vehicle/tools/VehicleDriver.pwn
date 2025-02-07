#include "dogfighters\server\serverInfo\serverMain.pwn"

forward GetVehicleDriver(vehicleid);

public GetVehicleDriver(vehicleid)
{
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == 0)
			return i;
	}
	return NOTSET;
}