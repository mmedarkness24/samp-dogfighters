#if !defined VEHICLE_EVENTS_GIVE_PLAYER
#define VEHICLE_EVENTS_GIVE_PLAYER

#include "dogfighters\vehicle\events\VehicleCreate.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"


forward GivePlayerVehicle(playerid, modelID, Float:x, Float:y, Float:z, Float:facingAngle, color1, color2, spawnDelay, addSiren, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public GivePlayerVehicle(playerid, modelID, Float:x, Float:y, Float:z, Float:facingAngle, color1, color2, spawnDelay, addSiren, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (DoesServerPlayerHaveVehicle(playerid, serverPlayers))
	{
		/*new ownerid = FindVehicleOwner(serverPlayers[playerid][vehicleID], serverPlayers);
		if (ownerid == playerid)*/	//	Try to fix bug with same vehid
		destroyPlayerVehicle(playerid, serverPlayers);
	}
	new result = CreateVehicle(modelID, x, y, z + 2, facingAngle, color1, color2, -1, 0);
	printf("Spawning a vehicle %d for player %s (%d)", result, serverPlayers[playerid][name], playerid);
	if (!result || result == INVALID_VEHICLE_ID)
	{
		if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID транспорта!");
		printf("GivePlayerVehicle error #26 for player %d", playerid);
		return 1;
	}
	new virtualWorld = GetPlayerVirtualWorld(playerid);
	SetVehicleVirtualWorld(result, virtualWorld);
	//serverPlayers[playerid][vehicleID] = result;
	ServerPlayerSetVehicle(playerid, result, serverPlayers);
	printf("Putting player %s (%d) into his vehicle: %d", serverPlayers[playerid][name], playerid, serverPlayers[playerid][vehicleID]);
	result = PutPlayerInVehicle(playerid, serverPlayers[playerid][vehicleID], 0);
	if (!result)
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Unknown error when creating vehicle!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неизвестная ошибка создания транспорта!");
		destroyPlayerVehicle(playerid, serverPlayers);
		return 1;
	}
	/*if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Vehicle created!");
	else
		SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Транспорт создан!");*/
	printf("Player %s (%d) was given a vehicle ID: %d", serverPlayers[playerid][name], playerid, serverPlayers[playerid][vehicleID]);
	return 1;
}

#endif
