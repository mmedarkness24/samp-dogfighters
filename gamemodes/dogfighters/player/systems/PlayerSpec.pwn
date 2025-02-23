#if !defined PLAYER_SYSTEMS_SPEC
#define PLAYER_SYSTEMS_SPEC

#include "dogfighters\server\serverMain.pwn"

forward PlayerSpectate(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerSpectateSwitch(playerid, newTargetId, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerUnspectate(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerSpectationUpdate(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

//ServerPlayerSetSpecId(playerid, spectatingID, serverPlayers

public PlayerSpectate(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!IsPlayerConnected(targetid) || 
        !IsPlayerConnected(playerid) || 
        !PlayerSpectateIsStateOk(targetid))
        return false;

    TogglePlayerSpectating(playerid, 1);
    if (IsPlayerInAnyVehicle(targetid))
    {
        new vehID = GetPlayerVehicleID(targetid);
        PlayerSpectateVehicle(playerid, vehID, SPECTATE_MODE_NORMAL);
    }
    else
    {
        PlayerSpectatePlayer(playerid, targetid, SPECTATE_MODE_NORMAL);
    }
    ServerPlayerSetSpecId(playerid, targetid, serverPlayers);
    new message[18];
    format(message, sizeof(message), "%s (%d)", serverPlayers[serverPlayers[playerid][specid]][name], serverPlayers[playerid][specid]);
    ServerPlayerSetSpecTextdraw(playerid, message, serverPlayers);
    return true;
}
public PlayerSpectateSwitch(playerid, newTargetId, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!IsPlayerConnected(newTargetId))
        return false;
    ServerPlayerSetSpecId(playerid, newTargetId, serverPlayers);
    PlayerSpectationUpdate(playerid, serverPlayers);
    if (IsPlayerInAnyVehicle(newTargetId))
    {
        new vehID = GetPlayerVehicleID(newTargetId);
        PlayerSpectateVehicle(playerid, vehID, SPECTATE_MODE_NORMAL);
    }
    else
    {
        PlayerSpectatePlayer(playerid, newTargetId, SPECTATE_MODE_NORMAL);
    }
    return true;
}
public  PlayerUnspectate(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    TogglePlayerSpectating(playerid, 0);
    ServerPlayerResetSpecTextdraw(playerid, serverPlayers);
    //ServerPlayersResetSpecTimerId(playerid, serverPlayers);
    ServerPlayerSetSpecId(playerid, NOTSET, serverPlayers);
}

public PlayerSpectationUpdate(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new message[18];
    format(message, sizeof(message), "%s (%d)", serverPlayers[serverPlayers[playerid][specid]][name], serverPlayers[playerid][specid]);
    PlayerTextDrawSetString(playerid, serverPlayers[playerid][spectextdraw], message);
}

stock PlayerSpectateIsStateOk(playerid)
{
    new playerState = GetPlayerState(playerid);
    if (playerState < PLAYER_STATE_ONFOOT || playerState > PLAYER_STATE_PASSENGER)
        return false;
    return true;
}

#endif