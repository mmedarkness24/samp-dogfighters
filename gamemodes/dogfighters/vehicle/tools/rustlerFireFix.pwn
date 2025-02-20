#if !defined RUSTLER_FIRE_FIX
#define RUSTLER_FIRE_FIX
//#include <pointers>
//#include <a_samp>
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	You can use mobile.inc to distinguish mobile
	players from PC and not to use this script
	with PC players. This include by default
	is avaliable only for servers that bought
	"Hosted" tab, but maybe there is free ones
	on the github.

#include "mobile.inc" //  Needs Pawn.RakNet plugin
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Have 13 warnings from rotation include.
	If it is a big problem, then you can
	use your own functions for calculating
	plane's offset coordinates instead.
*/
#include <rotation>
#include <rotation_misc>
#include <rotation_extra>
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include "dogfighters/player/events/PlayerDeath.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"

//#define FILTERSCRIPT    //  For Pawn.RakNet :D

#define DEBUG_MODE_FIREFIX false //  To have extra prints in log
#define COLLISION_SEARCH_MIN_RADIUS 1   //  Radius near plane
#define COLLISION_SEARCH_RADIUS_STEP 1  //  Step increasing radius
#define COLLISION_SEARCH_MAX_RADIUS 5  //  Radius far away from plane
#define COLLISION_MINIMAL_DISTANCE 10   //  Distance from plane to start search
#define COLLISION_MAXIMAL_DISTANCE 200  //  Maximal search distance
#define COLLISION_DISTANCE_STEP 10  //  Search for every 10 metres

#define RUSTLER_DAMAGE_PLAYERS 10   //  Plane's damage to players
#define RUSTLER_DAMAGE_VEHICLES 10  //  Damage to vehicles
#define RUSTLER_DAMAGE_BODYPART 3   //  Bodypart to damage to (not used)
#define RUSTLER_MODEL_ID 476    //  ModelID of Rustler plane
#define RUSTLER_WEAPON_ID 31    //  WeaponID for killing messages / damage sync

#define HYDRA_SEARCH_MIN_RADIUS 5   //  Radius near plane (collision, hydra)
#define HYDRA_SEARCH_RADIUS_STEP 1  //  Step increasing radius (collision, hydra)
#define HYDRA_SEARCH_MAX_RADIUS 5  //  Radius far away from plane (collision, hydra)
#define HYDRA_MINIMAL_DISTANCE 3   //  Distance from plane to start search (collision, hydra)
#define HYDRA_MAXIMAL_DISTANCE 400  //  Maximal search distance (collision, hydra)
#define HYDRA_DISTANCE_STEP 1  //  Search for every 10 metres (collision, hydra)
#define HYDRA_MAXIMUM_ITERATIONS 300 //	Maximal number of iterations per missile

#define HYDRA_EXPLOSION_TYPE 3		//	Hydra's explosion after maximal distance is reached
#define HYDRA_MISSILE_SPEED 2.5		//	Meetres/100 ms
#define HYDRA_MISSILE_ACCELERATION 0.5	//	Speed increase per tick (0.3)
#define HYDRA_MAX_MISSILE_SPD 15.0	//	Maximum speed that hydra's missiles can reach
#define HYDRA_DAMAGE_PLAYERS 70   //  Plane's damage to players
#define HYDRA_DAMAGE_VEHICLES 800  //  Damage to vehicles
#define HYDRA_DAMAGE_BODYPART 3   //  Bodypart to damage to (not used)
#define HYDRA_MODEL_ID 520		//	ModelID of Hydra plane
#define HYDRA_WEAPON_ID 51		//	WeaponID for killing messages / damage sync (Hydra)
#define HYDRA_MISSILE_TIMER_ID 777

#define MISSILES_SHELLS_MAX_COUNT 3

#define BULLET_SYNC_ENABLE true // Set true if you want to send BulletSync packet when damaging player
#define BULLET_SYNC_STREAM_ENABLE true  //  Set true if you want to send BulletSync to all players in victim's stream area
#if BULLET_SYNC_ENABLE == true
#define BULLET_SYNC 206
#define BULLET_HIT_TYPE_NONE 0
#define BULLET_HIT_TYPE_PLAYER 1
#define BULLET_HIT_TYPE_VEHICLE 2
#define BULLET_HIT_TYPE_OBJECT 3
#define BULLET_HIT_TYPE_PLAYER_OBJECT 4
#endif

forward OnCheckFireUpdate();
//forward OnRustlerFiring(playerid, vehicleid);
forward GetNearestPlayer(Float:x, Float:y, Float:z, Float:radius, playerid);
//new _svrPlayers[MODE_MAX_PLAYERS][serverPlayer];
//new playerDeath[MAX_PLAYERS];


/*public OnFilterScriptInit()
{
	print("----------------------------\n|-[rustlerFireFix script by d7.KrEoL loaded]");
	print("|		15.12.24");
	print("|->Discord:https://discord.gg/QSKkNhZrTh");
	print("|->VK:https://vk.com/d7kreol\n----------------------------");

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    firingTimer[i] = NOTSET;
	    //playerDeathi] = NOTSET;
	}
	if (!CA_Init())
	    printf("[rustlerFireFix]: cannot create raycast world. Script may not work well.");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--dlink Test Unloaded.\n------------------");
	return 1;
}*/

/*public RegisterServerPlayers(serverPlayers[MODE_MAX_PLAYERS][serverPlayer])	//	BUG DANGEROUS FUNCTION
{
	//_svrPlayers = GetVariableAddress(serverPlayers);
	_svrPlayers = serverPlayers;//[MODE_MAX_PLAYERS][serverPlayer];
}*/

enum hydraMissileInfo
{
	Float:hydraMissileLaunchPositionX,
	Float:hydraMissileLaunchPositionY,
	Float:hydraMissileLaunchPositionZ,
	Float:hydraMissileFinalPositionX,
	Float:hydraMissileFinalPositionY,
	Float:hydraMissileFinalPositionZ,
	hydraMissileIteration,
	timerid,
	ownerid
}

forward AddHydraMissile(playerid, Float:x, Float:y, Float:z, Float:maximumX, Float:maximumY, Float:maximumZ, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo]);
forward FindMissileFreeSlot(playerid, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo]);
forward AddHydraMyssileTimer(playerid, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo], missileTimerid);
forward DestroyHydraMissile(missileIndex, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo]);
forward ResetHydraMissiles(hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo]);
forward InitRustlerFireFix();

public InitRustlerFireFix()
{
	/*for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    firingTimer[i] = NOTSET;
	    playerDeath[i] = NOTSET;
	}*/
}

public AddHydraMissile(playerid, Float:x, Float:y, Float:z, Float:maximumX, Float:maximumY, Float:maximumZ, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo])
{
	#if DEBUG_MODE_FIREFIX == true
	printf("AddHydraMissile(%d [%.2f;%.2f;%.2f] [%.2f;%.2f;%.2f]", playerid, x, y, z, maximumX, maximumY, maximumZ);
	#endif
	new slotIndex = FindMissileFreeSlot(playerid, hydraMissiles);
	#if DEBUG_MODE_FIREFIX == true
	printf("slotIndex: %d", slotIndex);
	#endif
	hydraMissiles[slotIndex][hydraMissileLaunchPositionX] = x;
	hydraMissiles[slotIndex][hydraMissileLaunchPositionY] = y;
	hydraMissiles[slotIndex][hydraMissileLaunchPositionZ] = z;
	hydraMissiles[slotIndex][hydraMissileFinalPositionX] = maximumX;
	hydraMissiles[slotIndex][hydraMissileFinalPositionY] = maximumY;
	hydraMissiles[slotIndex][hydraMissileFinalPositionZ] = maximumZ;
	hydraMissiles[slotIndex][hydraMissileIteration] = 0;
	hydraMissiles[slotIndex][ownerid] = playerid;
	#if DEBUG_MODE_FIREFIX == true
	printf("Missile created at slot: %d owner: %d", slotIndex, hydraMissiles[slotIndex][ownerid]);
	#endif
	return slotIndex;
}

public FindMissileFreeSlot(playerid, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo])
{
	if (hydraMissiles[playerid][timerid] == NOTSET)
	{
		hydraMissiles[playerid][timerid] = TIMER_WAITING_INIT;
		return playerid;
	}
	for (new i = 1; i < MISSILES_SHELLS_MAX_COUNT; i++)
	{
		if (playerid > MODE_MAX_PLAYERS)
			continue;
		//new pid = playerid < MODE_MAX_PLAYERS && playerid || MODE_MAX_PLAYERS;
		if (hydraMissiles[playerid * i][timerid] != NOTSET)
			continue;
		hydraMissiles[playerid * i][timerid] = TIMER_WAITING_INIT;
		return i;
	}
	new slotIndex = playerid * (MISSILES_SHELLS_MAX_COUNT - 1);
	KillTimer(hydraMissiles[slotIndex][timerid]);
	return slotIndex;
}

public AddHydraMyssileTimer(playerid, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo], missileTimerid)
{
	hydraMissiles[playerid][timerid] = missileTimerid;
}

public DestroyHydraMissile(missileIndex, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo])
{
	KillTimer(hydraMissiles[missileIndex][timerid]);
	hydraMissiles[missileIndex][timerid] = NOTSET;
}

public ResetHydraMissiles(hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo])
{
	for (new i = 0; i < MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT; i++)
	{
		hydraMissiles[i][timerid] = NOTSET;
	}
}

public GetNearestPlayer(Float:x, Float:y, Float:z, Float:radius, playerid)
{
	new result = NOTSET;
	new Float:distance = radius;
	new Float:playerDistance = radius * 2;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i) || !IsPlayerSpawned(i) || i == playerid)
			continue;
		playerDistance = GetPlayerDistanceFromPoint(i, x, y, z);
		if (playerDistance < distance)
		{
		    result = i;
			distance = playerDistance;
  		}
	}
	return int:result;
}

/*public OnRustlerFiring(playerid, vehicleid)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerSpawned(playerid) || !IsPlayerInAnyVehicle(playerid))
	{
	    KillFiringTimer(playerid);
	    return;
	}
	#if DEBUG_MODE_FIREFIX == true
    printf("\n------------\n\n\nRustler fire from id: %d", playerid);
    #endif
    if (!IsPlayerInAnyVehicle(playerid))
		KillFiringTimer(playerid);
	new Float:spositionX, Float:spositionY, Float:spositionZ;
	GetVehiclePos(vehicleid, spositionX, spositionY, spositionZ);
	new Float:offsetX, Float:offsetY, Float:offsetZ;
	new Float:castX, Float:castY, Float:castZ;
	new targetid = NOTSET;
	new searchRadius = COLLISION_SEARCH_MIN_RADIUS;

	for (new i = COLLISION_MINIMAL_DISTANCE; i < COLLISION_MAXIMAL_DISTANCE; i += COLLISION_DISTANCE_STEP)
	{
    	GetVehicleRelativePos(vehicleid, 0, i, 0, offsetX, offsetY, offsetZ);
		targetid = GetNearestPlayer(offsetX, offsetY, offsetZ, searchRadius, playerid);

		if (searchRadius < COLLISION_SEARCH_MAX_RADIUS)
    	    searchRadius += COLLISION_SEARCH_RADIUS_STEP;
		if (targetid == NOTSET)
		    continue;

		new Float:targetX, Float:targetY, Float:targetZ;
		if (!GetPlayerPos(targetid, targetX, targetY, targetZ))
		{
		    #if DEBUG_MODE_FIREFIX == true
		    printf("bad target %d", targetid);
		    #endif

		    break;
		}

		if (CA_RayCastLine(spositionX, spositionY, spositionZ, targetX, targetY, targetZ, castX, castY, castZ) != 0)
        {
            #if DEBUG_MODE_FIREFIX == true
			printf("!!![COLLISION FOUND: %.2f %.2f %.2f] (Player %d is behind the object)", castX, castY, castZ, targetid);
			#endif

			break;
		}
		#if BULLET_SYNC_ENABLE == true
		new bulletData[PR_BulletSync];  //To send bulletData
		bulletData[PR_hitId] = targetid;
		bulletData[PR_origin][0] = spositionX;
		bulletData[PR_origin][1] = spositionY;
		bulletData[PR_origin][2] = spositionZ;
		bulletData[PR_hitPos][0] = targetX;
        bulletData[PR_hitPos][1] = targetY;
        bulletData[PR_hitPos][2] = targetZ;
        bulletData[PR_offsets][0] = 0;
        bulletData[PR_offsets][1] = 0;
        bulletData[PR_offsets][2] = 0;
        bulletData[PR_weaponId] = RUSTLER_WEAPON_ID;
        #endif

		if (IsPlayerInAnyVehicle(targetid))
		{
			new targetvehicleid = GetPlayerVehicleID(targetid);
			#if DEBUG_MODE_FIREFIX == true
		    printf("%d damaged vehicle: %d(player: %d)", playerid, targetvehicleid, targetid);
		    #endif
		    
			if (!GiveVehicleDamage(targetvehicleid, targetid, playerid, RUSTLER_DAMAGE_VEHICLES, serverPlayers))
			    continue;
		    // SetVehicleHealth(targetvehicleid, vehiclehealth - RUSTLER_DAMAGE_VEHICLES);  //  Can rewrite with you GiveVehicleDamage logic here
		    #if BULLET_SYNC_ENABLE == true
		    bulletData[PR_hitType] = BULLET_HIT_TYPE_VEHICLE;
		    SendBulletSync(playerid, targetvehicleid, bulletData);
		    #endif

		    break;
		}
		else
		{
		    #if DEBUG_MODE_FIREFIX == true
		    printf("%d damaged player: %d", playerid, targetid);
		    #endif
		    new Float:playerhealth = 100;
            if (!GetPlayerHealth(targetid, playerhealth))
		        continue;
            GivePlayerDamage(targetid, playerid, RUSTLER_DAMAGE_PLAYERS, serverPlayers);
            #if BULLET_SYNC_ENABLE == true
            bulletData[PR_hitType] = BULLET_HIT_TYPE_PLAYER;
            SendBulletSync(playerid, targetid, bulletData);
            #endif

            break;
		}
	}
	#if DEBUG_MODE_FIREFIX == true
    printf("---------");
    #endif
}*/

/*public OnPlayerDeath(playerid, killerid, reason)
{
	if (//playerDeathplayerid] > NOTSET)
	{
        ProcessPlayerDeath(//playerDeathplayerid], playerid, RUSTLER_WEAPON_ID);
        //playerDeathplayerid] = NOTSET;
        return 0;
	}
	return 1;
}*/

#if BULLET_SYNC_ENABLE == true
stock SendBulletSync(playerid, victimid, data[PR_BulletSync])
{
	new BitStream:bs = BS_New();
	BS_WriteValue(bs,
	    PR_UINT8, BULLET_SYNC,
	    PR_UINT16, playerid
	);
	BS_WriteBulletSync(bs, data);
	#if BULLET_SYNC_STREAM_ENABLE == true
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerStreamedIn(i, victimid))
	    	PR_SendPacket(bs, i);
	}
	#else
	PR_SendPacket(bs, victimid);
	#endif
	BS_Delete(bs);
}
#endif

/*stock AddPlayerFiringTimer(playerid, vehicleid)
{
	if (firingTimer[playerid] != NOTSET)
	    KillFiringTimer(playerid);
	//RegisterServerPlayers(serverPlayers);
    new FuncName[16] = "OnRustlerFiring";
	firingTimer[playerid] = SetTimerEx(FuncName, 100, true, "ii", playerid, vehicleid);
}*/
#include "dogfighters/vehicle/vehicleMain.pwn"
stock GiveVehicleDamage(vehicleid, targetid, damagerid, Float:damage, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	#if DEBUG_MODE_FIREFIX == true
	printf("GiveVehicleDamage: [%d] %s (%d) from %s (%d) - dmg:%.2f rsn:%d", vehicleid, serverPlayers[targetid][name], targetid, serverPlayers[damagerid][name], damagerid, damage, reason);
    #endif
	new Float:vehiclehealth = 1000;
    if (!GetVehicleHealth(vehicleid, vehiclehealth))
        return 0;
    if (vehiclehealth - RUSTLER_DAMAGE_VEHICLES < 100 && vehiclehealth > 0)
    {
		#if DEBUG_MODE_FIREFIX == true
		printf("VehicleHealth < 100");
		#endif
        new Float:targetX, Float:targetY, Float:targetZ;
        GetVehiclePos(vehicleid, targetX, targetY, targetZ);

		new driverAndPassengers[4];
		/*SetPVarInt(targetid, "Hit", damagerid);
		SetPVarInt(targetid, "HReason", reason);*/
        GetVehicleDriverAndPassengers(vehicleid, driverAndPassengers[0], driverAndPassengers[1], driverAndPassengers[2], driverAndPassengers[3]);
		if (ServerPlayerIsFireFix(driverAndPassengers[0], serverPlayers))
			driverAndPassengers[0] = driverAndPassengers[0] != NOTSET && driverAndPassengers[0] || targetid;
		/*new driverHitID = GetPVarInt(targetid, "Hit");
		driverHitID = driverHitID > 0 && driverHitID || 14;*/
		ForcePlayerDeath(driverAndPassengers[0], damagerid, GetPVarInt(driverAndPassengers[0], "HReason"), serverPlayers);
		for (new i = 1; i < 4; i++)
		{
			if (driverAndPassengers[i] == NOTSET || 
				!IsPlayerConnected(driverAndPassengers[i] || 
				!ServerPlayerIsFireFix(driverAndPassengers[i], serverPlayers)) /*|| driverAndPassengers[i] == killerid*/)
				continue;
			#if DEBUG_MODE_FIREFIX == true
			printf("Player %s (%d) was in vehicle and will be killed by %s (%d) now", serverPlayers[i][name], i, serverPlayers[damagerid][name], damagerid);
			#endif
			ForcePlayerDeath(driverAndPassengers[i], damagerid, 14, serverPlayers);
		}

        CreateExplosion(targetX, targetY, targetZ, 2, 3);
        //SetVehicleHealth(vehicleid, 0);
		//destroyPlayerVehicle(targetid, serverPlayers);
        //ForcePlayerDeath(targetid, damagerid, reason, serverPlayers);
        //SetPlayerHealth(targetid, 0);
		destroyPlayerVehicle(targetid, serverPlayers);
	}
	else
	{
		#if DEBUG_MODE_FIREFIX == true
		printf("VehicleHealth > 150");
		#endif
	    SetVehicleHealth(vehicleid, vehiclehealth - damage);
		GivePlayerDamage(targetid, damagerid, damage * 0.1, reason, serverPlayers);
	    /*SetPVarInt(targetid, "Hit", damagerid);
	    SetPVarInt(targetid, "HReason", reason);*/
 	}
	

    return 1;
}

stock GivePlayerDamage(playerid, damagerid, Float:damage, reason, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])  // Can rewrite with your GivePlayerDamage (OnFoot) logic here
{
	#if DEBUG_MODE_FIREFIX == true
	printf("\nGivePlayerDamage: %s (%d) - Damage: %d from %s %d\n", serverPlayers[playerid][name], playerid, damage, serverPlayers[damagerid][name], damagerid);
	#endif
	new Float:health, Float:armour;
	if (!GetPlayerHealth(playerid, health))
	    return;
	if (!GetPlayerArmour(playerid, armour))
	    return;
	if (armour > 0)
	{
	    SetPlayerArmour(playerid, armour - damage);
	    damage = damage - armour;
	    if (damage <= 0)
	        return;
	}
	if (health - damage <= 0)   //  Do "player kill" logic
	{
	    //SendDeathMessage(damagerid, playerid, RUSTLER_WEAPON_ID);
	    ////playerDeathplayerid] = damagerid;
	    ForcePlayerDeath(playerid, damagerid, reason, serverPlayers);
	}
	SetPlayerHealth(playerid, health - damage);
	SetPVarInt(playerid, "Hit", damagerid);
	SetPVarInt(playerid, "HReason", reason);
	#if DEBUG_MODE_FIREFIX == true
	printf("Damage has given to %d", playerid);
	#endif
}

stock IsPlayerSpawned(playerid)
{
	new pState = GetPlayerState(playerid);
	return 0 <= playerid <= MAX_PLAYERS && pState != PLAYER_STATE_NONE && pState != PLAYER_STATE_WASTED && pState != PLAYER_STATE_SPECTATING;
}
#endif