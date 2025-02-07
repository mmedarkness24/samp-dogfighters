#if !defined VEHICLE_TOOLS_DRIVERPASSENGERS
#define VEHICLE_TOOLS_DRIVERPASSENGERS

#include "dogfighters\server\serverInfo\serverMain.pwn"

forward GetVehicleDriverAndPassengers(vehicleid, &driverid, &passenger1id, &passenger2id, &passenger3id);

public GetVehicleDriverAndPassengers(vehicleid, &driverid, &passenger1id, &passenger2id, &passenger3id)
{
	driverid = NOTSET;
	passenger1id = NOTSET;
	passenger2id = NOTSET;
	passenger3id = NOTSET;
	for (new i = 0; i < MODE_MAX_PLAYERS; i++)
	{
		if (IsPlayerInVehicle(i, vehicleid))
		{
			switch (GetPlayerVehicleSeat(i))
			{
				case 0:
					driverid = i;
				case 1:
					passenger1id = i;
				case 2:
					passenger2id = i;
				case 3:
					passenger3id = i;
			}
		}
	}
}

#endif