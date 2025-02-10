#include <a_samp>
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
#include <colandreas>   //  For collisions
#include <Pawn.RakNet>  //  For bulletSync packets
//#include "../gamemodes/dogfighters/player/events/PlayerDeath.pwn"

#define FILTERSCRIPT    //  For Pawn.RakNet :D

#define DEBUG_MODE false //  To have extra prints in log
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
#define NOTSET -1

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
forward OnRustlerFiring(playerid, vehicleid);
forward GetNearestPlayer(Float:x, Float:y, Float:z, Float:radius, playerid);

new firingTimer[MAX_PLAYERS];
//new playerDeath[MAX_PLAYERS];


public OnFilterScriptInit()
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
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION) && IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (GetVehicleModel(vehicleid) != RUSTLER_MODEL_ID)
            return 0;
		AddPlayerFiringTimer(playerid, vehicleid);
	}
	if ((oldkeys & KEY_ACTION) && !(newkeys & KEY_ACTION))
	{
	    if (firingTimer[playerid] != NOTSET)
	        KillFiringTimer(playerid);
	}
    return 0;
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

public OnRustlerFiring(playerid, vehicleid)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerSpawned(playerid) || !IsPlayerInAnyVehicle(playerid))
	{
	    KillFiringTimer(playerid);
	    return;
	}
	#if DEBUG_MODE == true
    printf("\n------------\n\n\nRustler fire from id: %d", playerid);
    #endif
    if (!IsPlayerInAnyVehicle(playerid))
		KillFiringTimer(playerid);
	new Float:positionX, Float:positionY, Float:positionZ;
	GetVehiclePos(vehicleid, positionX, positionY, positionZ);
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
		    #if DEBUG_MODE == true
		    printf("bad target %d", targetid);
		    #endif

		    break;
		}

		if (CA_RayCastLine(positionX, positionY, positionZ, targetX, targetY, targetZ, castX, castY, castZ) != 0)
        {
            #if DEBUG_MODE == true
			printf("!!![COLLISION FOUND: %.2f %.2f %.2f] (Player %d is behind the object)", castX, castY, castZ, targetid);
			#endif

			break;
		}
		// Uncomment if you're using mobile.inc to recognize mobile clients
		/*if (!IsPlayerMobile(targetid))    //#include "mobile.inc" above
		{
		    printf("player %d is not mobile player", targetid);
		    break;
		}*/
		#if BULLET_SYNC_ENABLE == true
		new bulletData[PR_BulletSync];  //To send bulletData
		bulletData[PR_hitId] = targetid;
		bulletData[PR_origin][0] = positionX;
		bulletData[PR_origin][1] = positionY;
		bulletData[PR_origin][2] = positionZ;
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
			#if DEBUG_MODE == true
		    printf("%d damaged vehicle: %d(player: %d)", playerid, targetvehicleid, targetid);
		    #endif
		    
			if (!GiveVehicleDamage(targetvehicleid, targetid, playerid, RUSTLER_DAMAGE_VEHICLES))
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
		    #if DEBUG_MODE == true
		    printf("%d damaged player: %d", playerid, targetid);
		    #endif
		    new Float:playerhealth = 100;
            if (!GetPlayerHealth(targetid, playerhealth))
		        continue;
            GivePlayerDamage(targetid, playerid, RUSTLER_DAMAGE_PLAYERS);
            #if BULLET_SYNC_ENABLE == true
            bulletData[PR_hitType] = BULLET_HIT_TYPE_PLAYER;
            SendBulletSync(playerid, targetid, bulletData);
            #endif

            break;
		}
	}
	#if DEBUG_MODE == true
    printf("---------");
    #endif
}

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

stock AddPlayerFiringTimer(playerid, vehicleid)
{
	if (firingTimer[playerid] != NOTSET)
	    KillFiringTimer(playerid);
    new FuncName[16] = "OnRustlerFiring";
	firingTimer[playerid] = SetTimerEx(FuncName, 100, true, "ii", playerid, vehicleid);
}

stock GiveVehicleDamage(vehicleid, targetid, damagerid, Float:damage)
{
    new Float:vehiclehealth = 1000;
    if (!GetVehicleHealth(vehicleid, vehiclehealth))
        return 0;
    if (vehiclehealth - RUSTLER_DAMAGE_VEHICLES < 150 && vehiclehealth > 0)
    {
        new Float:targetX, Float:targetY, Float:targetZ;
        GetVehiclePos(vehicleid, targetX, targetY, targetZ);
        //SendDeathMessage(damagerid, targetid, RUSTLER_WEAPON_ID);
        //playerDeathtargetid] = damagerid;
        CreateExplosion(targetX, targetY, targetZ, 2, 3);
        SetVehicleHealth(vehicleid, 0);
        //ForcePlayerDeath(targetid, damagerid, RUSTLER_WEAPON_ID);
        SetPlayerHealth(targetid, 0);
	}
	else
	{
	    SetVehicleHealth(vehicleid, vehiclehealth - RUSTLER_DAMAGE_VEHICLES);
	    SetPVarInt(targetid, "Hit", damagerid);
	    SetPVarInt(targetid, "HReason", RUSTLER_WEAPON_ID);
 	}

    return 1;
}

stock GivePlayerDamage(playerid, damagerid, Float:damage)  // Can rewrite with your GivePlayerDamage (OnFoot) logic here
{
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
	    //ForcePlayerDeath(playerid, damagerid, RUSTLER_WEAPON_ID);
	}
	SetPlayerHealth(playerid, health - damage);
	SetPVarInt(playerid, "Hit", damagerid);
	SetPVarInt(playerid, "HReason", RUSTLER_WEAPON_ID);
	#if DEBUG_MODE == true
	printf("Damage has given to %d", playerid);
	#endif
}

stock KillFiringTimer(playerid)
{
    KillTimer(firingTimer[playerid]);
	firingTimer[playerid] = NOTSET;
}

stock IsPlayerSpawned(playerid)
{
	new pState = GetPlayerState(playerid);
	return 0 <= playerid <= MAX_PLAYERS && pState != PLAYER_STATE_NONE && pState != PLAYER_STATE_WASTED && pState != PLAYER_STATE_SPECTATING;
}
