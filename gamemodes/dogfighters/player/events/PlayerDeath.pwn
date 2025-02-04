forward ForcePlayerDeath(playerid, killerid, reason);
forward ProcessPlayerDeath(playerid, killerid, reason);

public ForcePlayerDeath(playerid, killerid, reason)
{
	SetPlayerHealth(playerid, 0);
	new lastHit = GetPVarInt(playerid, "Hit");
	if (killerid == playerid && lastHit != killerid && lastHit != -1)
		killerid = lastHit;
	SendDeathMessage(killerid, playerid, reason);
	SetPVarInt(playerid, "Death", 1);
	//ProccessPlayerDeath(playerid, killerid, reason);
}

public ProcessPlayerDeath(playerid,	killerid, reason)
{
	if (GetPVarInt(playerid, "Death") == 1)
		return 0;
	SetPVarInt(playerid, "Death", 1);
	new lastHit = GetPVarInt(playerid, "Hit");
	printf("ProcessPlayerDeath pid:%d kid:%d reason:%d\nHit:%d", playerid, killerid, reason, lastHit);
	if (killerid == 65535 && lastHit != -1)
		killerid = lastHit;
	switch(reason)
	{
		case 31://	M4
		{
	        return 0;
		}
	    case 35://  RPG
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 38://  Minigun
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 49://  Vehicle
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 50://  Helicopter Blades
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 51://  Explosion
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 53://  Drowned
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 54://  Splat(Dropped)
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	    case 255://    Suiside
	    {
	        SendDeathMessage(killerid, playerid, reason);
	        return 0;
	    }
	}
	return 1;
}
