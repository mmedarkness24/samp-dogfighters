#if !defined SERVER_PLAYERS
	#define SERVER_PLAYERS

	#include "dogfighters\server\serverInfo\Gamemode\ModeInfo.pwn"
	#include "dogfighters\server\serverInfo\Gamemode\ModeDefaultValues.pwn"

	#define SERVER_PLAYERS_MAX_NAME MAX_PLAYER_NAME + 1

	enum serverPlayer
	{
		bool:isLoggedIn,
		flood,
		language,
		name[SERVER_PLAYERS_MAX_NAME],
		money,
		vehicleID,
		bool:fireFix,
		kills,
		deaths,
		pvpid,
		pvpscore,
		PlayerText:pvptextdraw,
		Float:positionX,
		Float:positionY,
		Float:positionZ,
		anticheat,
		//personalTimer
	}
	forward ServerPlayerReset(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayersReset(serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetFlood(playerid, floodValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetName(playerid, playerName[SERVER_PLAYERS_MAX_NAME], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddMoney(playerid, moneyValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward DoesServerPlayerHaveVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetVehicle(playerid, vehicleid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerResetVehicle(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSwitchFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerResetFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerIsFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetKills(playerid, killsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetDeath(playerid, deathsValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetPvpID(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerIsInPvp(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetPvpScore(playerid, scoreValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddPvpScore(playerid, scoreValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetPvpTextdraw(playerid, PlayerText:textdraw, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetPos(playerid, Float:x, Float:y, Float:z, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerAddAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetAnticheat(playerid, anticheatValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	forward ServerPlayerSetLoggedIn(playerid, bool:stateIsLogged, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	//forward ServerPlayerSetPersonalTimer(playerid, timerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	//forward ServerPlayerResetPersonalTimer(playerid, serverPlayers[MODE_MAX_PLAYERID][serverPlayer]);

	//Resets all player's variables to default (DO NOT RESET PLAYER'S VEHICLE ID)
	public ServerPlayerReset(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		ServerPlayerResetVehicle(playerid, serverPlayers);
		ServerPlayerResetFireFix(playerid, serverPlayers);
		ServerPlayerSetName(playerid, "\%ERR\%NOTSET", serverPlayers);
		ServerPlayerSetFlood(playerid, 0, serverPlayers);
		ServerPlayerAddMoney(playerid, -serverPlayers[playerid][money], serverPlayers);
		ServerPlayerSetKills(playerid, 0, serverPlayers);
		ServerPlayerSetDeath(playerid, 0, serverPlayers);
		ServerPlayerSetAnticheat(playerid, 0, serverPlayers);
		ServerPlayerSetPos(playerid, NOTSET, NOTSET, NOTSET, serverPlayers);

		ServerPlayerSetPvpID(playerid, NOTSET, serverPlayers);
		ServerPlayerSetPvpScore(playerid, NOTSET, serverPlayers);
		ServerPlayerSetPvpTextdraw(playerid, PlayerText:NOTSET, serverPlayers);
		ServerPlayerSetLoggedIn(playerid, false, serverPlayers);

		//ServerPlayerResetPersonalTimer(playerid, serverPlayers);

		#if DEBUG_MODE == true
		printf("Player %s (%d) reset", serverPlayers[playerid][name], playerid);
		#endif
	}
	public ServerPlayersReset(serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		print("Server Players Reset:");
		for (new i = 0; i < MODE_MAX_PLAYERS; i++)
		{
			ServerPlayerReset(i, serverPlayers);
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
	public ServerPlayerSwitchFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][fireFix] = !serverPlayers[playerid][fireFix];
		return serverPlayers[playerid][fireFix];
	}
	public ServerPlayerResetFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][fireFix] = false;
	}
	public ServerPlayerIsFireFix(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		return serverPlayers[playerid][fireFix];
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
	public ServerPlayerSetPvpID(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][pvpid] = targetid;
	}
	public ServerPlayerIsInPvp(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		if (serverPlayers[playerid][pvpid] < 0 || serverPlayers[playerid][pvpid] >= MODE_MAX_PLAYERS)
			return 0;
		else
			return 1;
	}
	public ServerPlayerSetPvpScore(playerid, scoreValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][pvpscore] = scoreValue;
	}
	public ServerPlayerAddPvpScore(playerid, scoreValue, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][pvpscore] += scoreValue;
	}
	public ServerPlayerSetPvpTextdraw(playerid, PlayerText:textdraw, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][pvptextdraw] = textdraw;
	}
	public ServerPlayerSetPos(playerid, Float:x, Float:y, Float:z, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
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
	public ServerPlayerSetLoggedIn(playerid, bool:stateIsLogged, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		serverPlayers[playerid][isLoggedIn] = stateIsLogged;
	}
	/*public ServerPlayerSetPersonalTimer(playerid, timerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		if (timerid < 0)
		{
			printf("Cannot set personal timer for %s (%d) - timerid is %d", serverPlayers[playerid][name], playerid, timerid);
		}
		if (serverPlayers[playerid][personalTimer] != NOTSET)
			ServerPlayerResetPersonalTimer(playerid, serverPlayers);
		serverPlayers[playerid][personalTimer] = timerid;
	}
	public ServerPlayerResetPersonalTimer(playerid, serverPlayers[MODE_MAX_PLAYERID][serverPlayer])
	{
		if (serverPlayers[playerid][personalTimer] < 0)
			return;
		KillTimer(serverPlayers[playerid][personalTimer]);
		serverPlayers[playerid][personalTimer] = NOTSET;
	}*/
	
#endif