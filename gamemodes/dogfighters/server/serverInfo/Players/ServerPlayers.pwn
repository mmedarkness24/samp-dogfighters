#if !defined SERVER_PLAYERS
	#define SERVER_PLAYERS

	#include "dogfighters\server\serverInfo\Gamemode\ModeInfo.pwn"
	#include "dogfighters\server\serverInfo\Gamemode\ModeDefaultValues.pwn"

	#define SERVER_PLAYERS_MAX_NAME MAX_PLAYER_NAME + 1

	enum serverPlayer
	{
		//bool:isConnected = false,
		//bool:isServerSideDamageSync = false,
		flood,
		language,
		name[SERVER_PLAYERS_MAX_NAME],
		money,
		vehicleID,
		kills,
		deaths,
		Float:positionX,
		Float:positionY,
		Float:positionZ,
		anticheat
	}
	forward ServerPlayersReset(serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetName(playerid, playerName[SERVER_PLAYERS_MAX_NAME], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddMoney(playerid, moneyValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward DoesServerPlayerHaveVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetVehicle(playerid, vehicleid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerResetVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetPos(playerid, x, y, z, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	
	public ServerPlayersReset(serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		print("Server Players Reset:");
		for (new i = 0; i < MODE_MAX_PLAYERS; i++)
		{
			ServerPlayerResetVehicle(i, serverPlayers);
			ServerPlayerSetName(i, "\%ERR\%NOTSET", serverPlayers);
			printf("Player %s (%d) - vehicle: %d", serverPlayers[i][name], i, serverPlayers[i][vehicleID]);
		}
	}
	public ServerPlayerAddFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][flood] += floodValue;
	}
	public ServerPlayerSetFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][flood] = floodValue;
	}
	public ServerPlayerSetName(playerid, playerName[SERVER_PLAYERS_MAX_NAME], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		format(serverPlayers[playerid][name], SERVER_PLAYERS_MAX_NAME, "%s", playerName);
		//serverPlayers[playerid][name] = playerName;
	}
	public ServerPlayerAddMoney(playerid, moneyValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][money] += moneyValue;
	}
	public ServerPlayerSetVehicle(playerid, vehicleid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][vehicleID] = vehicleid;
	}
	public ServerPlayerResetVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][vehicleID] = NOTSET;
	}
	public DoesServerPlayerHaveVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		if (serverPlayers[playerid][vehicleID] == NOTSET)
			return false;
		return true;
	}
	public ServerPlayerAddKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][kills] += killsValue;
	}
	public ServerPlayerSetKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][kills] = killsValue;
	}
	public ServerPlayerAddDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][deaths] += deathsValue;
	}
	public ServerPlayerSetDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][deaths] = deathsValue;
	}
	public ServerPlayerSetPos(playerid, x, y, z, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][positionX] = x;
		serverPlayers[playerid][positionY] = y;
		serverPlayers[playerid][positionZ] = z;
	}
	public ServerPlayerAddAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][anticheat] = anticheatValue;
	}
	public ServerPlayerSetAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][anticheat] = anticheatValue;
	}
	
#endif