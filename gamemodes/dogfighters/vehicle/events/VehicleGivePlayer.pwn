#if !defined VEHICLE_EVENTS_GIVE_PLAYER
#define VEHICLE_EVENTS_GIVE_PLAYER

#include "dogfighters\vehicle\events\VehicleCreate.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"


forward GivePlayerVehicle(playerid, modelID, Float:x, Float:y, Float:z, Float:facingAngle, color1, color2, spawnDelay, addSiren, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public GivePlayerVehicle(playerid, modelID, Float:x, Float:y, Float:z, Float:facingAngle, color1, color2, spawnDelay, addSiren, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (serverPlayers[playerid][vehicleID] != NOTSET)
	{
		new ownerid = FindVehicleOwner(serverPlayers[playerid][vehicleID], serverPlayers);
		if (ownerid != playerid)	//	Try to fix bug with same vehid
			destroyPlayerVehicle(playerid, serverPlayers);
	}
	new result = CreateVehicle(modelID, x, y, z + 2, facingAngle, color1, color2, -1, 0);
	if (!result || result == INVALID_VEHICLE_ID)
	{
		if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID модели!");
		return 0;
	}
	serverPlayers[playerid][vehicleID] = result;
	result = PutPlayerInVehicle(playerid, serverPlayers[playerid][vehicleID], 0);
	if (!result)
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Unknown error when creating vehicle!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неизвестная ошибка при создании транспорта");
		destroyPlayerVehicle(playerid);
		return 0;
	}
	if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Vehicle created!");
	else
		SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Транспорт создан!");
	return 1;
}

#endif