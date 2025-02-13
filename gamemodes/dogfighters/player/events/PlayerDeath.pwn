#if !defined EVENTS_PLAYER_DEATH
#define EVENTS_PLAYER_DEATH
//#include "dogfighters\player\events\PlayerKill.pwn"
#include "dogfighters\player\playerMain.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"
//#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward ForcePlayerDeath(playerid, killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward ProcessPlayerDeath(playerid, killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward AddPlayerDeaths(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ForcePlayerDeath(playerid, killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	printf("ForcePlayerDeath: killed: %s (%d), by %s %d", serverPlayers[playerid][name], playerid, serverPlayers[killerid][name], killerid);
	/*if (ServerPlayerIsInPvp(playerid, serverPlayers))
	{
		#if DEBUG_MODE == true
		printf("Player %d is in pvp, %d receive 1 score point", playerid, serverPlayers[playerid][pvpid]);
		#endif
		PlayerIncreaseDuelScore(serverPlayers[playerid][pvpid], 1, serverPlayers);
	}*/
	SetPlayerHealth(playerid, 0);
	new lastHit = GetPVarInt(playerid, "Hit");
	if (killerid == playerid && lastHit != NOTSET)
		killerid = lastHit;
	SendDeathMessage(killerid, playerid, reason);
	SetPVarInt(playerid, "Death", 1);
	AddPlayerDeaths(playerid, 1, serverPlayers);
	ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	//ProccessPlayerDeath(playerid, killerid, reason);
}

public ProcessPlayerDeath(playerid,	killerid, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	printf("ProcessPlayerDeath[pre]: pid %d kil %d reason: %d", playerid, killerid, reason);
	if (ServerPlayerIsInPvp(playerid, serverPlayers))
	{
		#if DEBUG_MODE == true
		printf("Player %d is in pvp, %d receive 1 score point", playerid, serverPlayers[playerid][pvpid]);
		#endif
		PlayerIncreaseDuelScore(serverPlayers[playerid][pvpid], 1, serverPlayers);
	}
	if (!ServerPlayerIsFireFix(playerid, serverPlayers))
	{
	    //SendDeathMessage(killerid, playerid, reason);
		SetPVarInt(playerid, "Death", 1);
	    return 1;
	}
	if (GetPVarInt(playerid, "Death") == 1)
		return 1;
	SetPVarInt(playerid, "Death", 1);
	new lastHit = GetPVarInt(playerid, "Hit");
	printf("ProcessPlayerDeath pid:%d kid:%d reason:%d\nHit:%d\nName: %s, Cash:%d\nName: %s, Cash: %d", 
		playerid,
		killerid, 
		reason, 
		lastHit,
		serverPlayers[playerid][name],
		serverPlayers[playerid][money],
		serverPlayers[killerid][name],
		serverPlayers[killerid][money]);
	if (killerid == 65535 && lastHit != NOTSET)
	{
		killerid = lastHit;
		reason = GetPVarInt(playerid, "HReason");
	}
	switch(reason)
	{
		case 14://	Flowers
		{
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
			return 1;
		}
		case 31://	M4
		{
			AddPlayerDeaths(playerid, 1, serverPlayers);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
		}
	    case 35://  RPG
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 38://  Minigun
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 49://  Vehicle
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 50://  Helicopter Blades
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 51://  Explosion
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 53://  Drowned
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 54://  Splat(Dropped)
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, reason);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	    case 255://    Suiside
	    {
			AddPlayerDeaths(playerid, 1, serverPlayers);
	        SendDeathMessage(killerid, playerid, 14);
			ProcessPlayerKill(killerid, playerid, reason, serverPlayers);
	        return 1;
	    }
	}
	return 1;
}

public AddPlayerDeaths(playerid, amount, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (!IsPlayerConnected(playerid))
		return;
	serverPlayers[playerid][deaths] += amount;
}
#endif