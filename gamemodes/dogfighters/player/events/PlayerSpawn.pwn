forward ProcessPlayerSpawn(playerid, score);

public ProcessPlayerSpawn(playerid, score)
{
	SetPVarInt(playerid, "Death", 0);
	SetPVarInt(playerid, "Hit", -1);
	SetPVarInt(playerid, "HReason", -1);
	
	SetPlayerScore(playerid, score);
}