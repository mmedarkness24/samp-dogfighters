#if !defined SVR_EVENTS_UPDATE_MISSILES
#define SVR_EVENTS_UPDATE_MISSILES

#define DEBUG_MODE_UPDATE_MISSILES true

#include <float>
#include <math>

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\tools\rustlerFireFix.pwn"

forward OnHydraUpdateMissiles(hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward HydraCheckMissileStatus(missileIndex, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo]);
forward HydraInterpolateCoordinates(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:distance, &Float:resultX, &Float:resultY, &Float:resultZ);
forward Float:HydraGetDistancePercent(Float:startValue, Float:endValue, Float:value);

public OnHydraUpdateMissiles(hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	for (new i = 0; i < MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT; i++)
	{
		if(hydraMissiles[i][timerid] == NOTSET || hydraMissiles[i][timerid] == TIMER_WAITING_INIT)
			continue;
		if (HydraCheckMissileStatus(i, hydraMissiles))
			continue;
		printf("Distance: %.2f", GetDistance3D(hydraMissiles[i][hydraMissileFinalPositionX], 
						hydraMissiles[i][hydraMissileFinalPositionY], 
						hydraMissiles[i][hydraMissileFinalPositionZ],
						hydraMissiles[i][hydraMissileLaunchPositionX],
						hydraMissiles[i][hydraMissileLaunchPositionY],
						hydraMissiles[i][hydraMissileLaunchPositionZ]));
		printf("Updating missile: %d (owner: %d) [%.2f;%.2f;%.2f] [%.2f;%.2f;%.2f]", 
				i, 
				hydraMissiles[i][ownerid], 
				hydraMissiles[i][hydraMissileLaunchPositionX],
				hydraMissiles[i][hydraMissileLaunchPositionY],
				hydraMissiles[i][hydraMissileLaunchPositionZ],
				hydraMissiles[i][hydraMissileFinalPositionX],
				hydraMissiles[i][hydraMissileFinalPositionY],
				hydraMissiles[i][hydraMissileFinalPositionZ]);
		new Float:fullSpeed = Float:(HYDRA_MISSILE_SPEED + (hydraMissiles[i][hydraMissileIteration] * HYDRA_MISSILE_ACCELERATION));
		if (fullSpeed > HYDRA_MAX_MISSILE_SPD)
			fullSpeed = Float:HYDRA_MAX_MISSILE_SPD;
		new Float:newX = 0, Float:newY = 0, Float:newZ = 0;
		HydraInterpolateCoordinates(
									hydraMissiles[i][hydraMissileLaunchPositionX], 
									hydraMissiles[i][hydraMissileLaunchPositionY],
									hydraMissiles[i][hydraMissileLaunchPositionZ],
									hydraMissiles[i][hydraMissileFinalPositionX],
									hydraMissiles[i][hydraMissileFinalPositionY],
									hydraMissiles[i][hydraMissileFinalPositionZ],
									fullSpeed,
									newX,
									newY,
									newZ);
		hydraMissiles[i][hydraMissileIteration]++;
		printf("Missile new coordinates: [%.2f;%.2f;%.2f]", newX, newY, newZ);
		hydraMissiles[i][hydraMissileLaunchPositionX] = newX;
		hydraMissiles[i][hydraMissileLaunchPositionY] = newY;
		hydraMissiles[i][hydraMissileLaunchPositionZ] = newZ;
		new targetid = GetNearestPlayer(
								hydraMissiles[i][hydraMissileLaunchPositionX], 
								hydraMissiles[i][hydraMissileLaunchPositionY], 
								hydraMissiles[i][hydraMissileLaunchPositionZ], 
								HYDRA_SEARCH_MAX_RADIUS, 
								hydraMissiles[i][ownerid]);
		if (targetid == NOTSET)
		    continue;
		new Float:targetX, Float:targetY, Float:targetZ;
		if (!GetPlayerPos(targetid, targetX, targetY, targetZ))
		{
		    #if DEBUG_MODE_UPDATE_MISSILES == true
		    printf("bad target %d", targetid);
		    #endif
		    continue;
		}
		printf("Missile found a target: %d [%.2f;%.2f;%.2f]", targetid, targetX, targetY, targetZ);
		#if BULLET_SYNC_ENABLE == true
		new bulletData[PR_BulletSync];  //To send bulletData
		bulletData[PR_hitId] = targetid;
		bulletData[PR_origin][0] = hydraMissiles[i][hydraMissileLaunchPositionX];
		bulletData[PR_origin][1] = hydraMissiles[i][hydraMissileLaunchPositionY];
		bulletData[PR_origin][2] = hydraMissiles[i][hydraMissileLaunchPositionZ];
		bulletData[PR_hitPos][0] = targetX;
        bulletData[PR_hitPos][1] = targetY;
        bulletData[PR_hitPos][2] = targetZ;
        bulletData[PR_offsets][0] = 0;
        bulletData[PR_offsets][1] = 0;
        bulletData[PR_offsets][2] = 0;
        bulletData[PR_weaponId] = HYDRA_WEAPON_ID;
        #endif

		if (IsPlayerInAnyVehicle(targetid))
		{
			new targetvehicleid = GetPlayerVehicleID(targetid);
			#if DEBUG_MODE_UPDATE_MISSILES == true
		    //printf("%d damaged vehicle: %d(player: %d)", playerid, targetvehicleid, targetid);
		    #endif

			if (!GiveVehicleDamage(targetvehicleid, targetid, hydraMissiles[i][ownerid], HYDRA_DAMAGE_VEHICLES, HYDRA_WEAPON_ID, serverPlayers))
			    continue;
			/*SetPVarInt(targetid, "Hit", hydraMissiles[i][ownerid]);
			SetPVarInt(targetid, "HReason", );*/
		    // SetVehicleHealth(targetvehicleid, vehiclehealth - RUSTLER_DAMAGE_VEHICLES);  //  Can rewrite with you GiveVehicleDamage logic here
		    #if BULLET_SYNC_ENABLE == true
		    bulletData[PR_hitType] = BULLET_HIT_TYPE_VEHICLE;
		    SendBulletSync(hydraMissiles[i][ownerid], targetvehicleid, bulletData);
		    #endif

		    DestroyHydraMissile(i, hydraMissiles);
			continue;
		}
		else
		{
		    #if DEBUG_MODE_UPDATE_MISSILES == true
		    printf("%d damaged player: %d", hydraMissiles[i][ownerid], targetid);
		    #endif
		    new Float:playerhealth = 100;
            if (!GetPlayerHealth(targetid, playerhealth))
		        continue;
            GivePlayerDamage(targetid, hydraMissiles[i][ownerid], HYDRA_DAMAGE_PLAYERS, HYDRA_WEAPON_ID, serverPlayers);
            #if BULLET_SYNC_ENABLE == true
            bulletData[PR_hitType] = BULLET_HIT_TYPE_PLAYER;
            SendBulletSync(hydraMissiles[i][ownerid], targetid, bulletData);
            #endif

            DestroyHydraMissile(i, hydraMissiles);
			continue;
		}
	}
}

public Float:HydraGetDistancePercent(Float:startValue, Float:endValue, Float:value)
{
	printf("HydraGetDistancePercent: min=%.2f max=%.2f value=%.2f", startValue, endValue, value);
	return (value / (endValue - startValue));
	//return floatdiv(value, floatsub(maximalValue, minimalValue));
	/*
	function CalcProp(min, max, val)
	return (val - min)/(max - min)
	end
	*/
}

public HydraInterpolateCoordinates(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:distance, &Float:resultX, &Float:resultY, &Float:resultZ)
{
	/*new Float:percentX, Float:percentY, Float:percentZ;
	new Float:sizeX, Float:sizeY, Float:sizeZ;*/
	printf("HydraInterpolateCoordinates [%.2f;%.2f;%.2f] [%.2f;%.2f;%.2f] [%.2f] [%.2f;%.2f;%.2f]", x1, y1, z1, x2, y2, z2, distance, resultX, resultY, resultZ);
	
	
	new Float:mainDistance = Float:GetDistance3D(x1, y1, z1, x2, y2, z2);
	new Float:percent = Float:(distance / mainDistance);
	
	resultX = Float:(x1 + (percent * (x2 - x1)));
	resultY = Float:(y1 + (percent * (y2 - y1)));
	resultZ = Float:(z1 + (percent * (z2 - z1)));
	
	
	// percentX = HydraGetDistancePercent(x1, x2, distance);
	// percentY = HydraGetDistancePercent(y1, y2, distance);
	// percentZ = HydraGetDistancePercent(z1, z2, distance);
	// printf("XYZ: [%.2f;%.2f;%.2f]", percentX, percentY, percentZ);
	
	// sizeX = floatsub(x2, x1);
	// sizeY = floatsub(y2, y1);
	// sizeZ = floatsub(z2, z1);
	// printf("sizeXYZ: [%.2f;%.2f;%.2f]", sizeX, sizeY, sizeZ);
	
	// if (percentX <= 100)
		// resultX = floatadd(x1, floatmul(sizeX, percentX));
	// if (percentY <= 100)
		// resultY = floatadd(y1, floatmul(sizeY, percentY));
	// if (percentZ <= 100)
		// resultZ = floatadd(z1, floatmul(sizeZ, percentZ));
	printf("resultXYZ: [%.2f;%.2f;%.2f]", resultX, resultY, resultZ);
	printf("HydraInterpolateEnd");
	//return {resultX, resultY, resultZ};
}

public HydraCheckMissileStatus(missileIndex, hydraMissiles[MODE_MAX_PLAYERS * MISSILES_SHELLS_MAX_COUNT][hydraMissileInfo])
{
	
	if (Float:GetDistance3D(
		hydraMissiles[missileIndex][hydraMissileFinalPositionX], 
		hydraMissiles[missileIndex][hydraMissileFinalPositionY], 
		hydraMissiles[missileIndex][hydraMissileFinalPositionZ],
		hydraMissiles[missileIndex][hydraMissileLaunchPositionX],
		hydraMissiles[missileIndex][hydraMissileLaunchPositionY],
		hydraMissiles[missileIndex][hydraMissileLaunchPositionZ]) 
		< (HYDRA_SEARCH_MAX_RADIUS + 1) || hydraMissiles[missileIndex][hydraMissileIteration] > HYDRA_MAXIMUM_ITERATIONS)
		{
			DestroyHydraMissile(missileIndex, hydraMissiles);
			/*CreateExplosion(
							hydraMissiles[missileIndex][hydraMissileFinalPositionX], 
							hydraMissiles[missileIndex][hydraMissileFinalPositionY], 
							hydraMissiles[missileIndex][hydraMissileFinalPositionZ], 
							HYDRA_EXPLOSION_TYPE);*/
		}
}

#endif