forward PlayerSpawnEvent(playerid);

public ProcessPlayerSpawn(playerid)
{
	SetPVarInt(playerid, "Death", 0);
	SetPVarInt(playerid, "Hit", -1);
}