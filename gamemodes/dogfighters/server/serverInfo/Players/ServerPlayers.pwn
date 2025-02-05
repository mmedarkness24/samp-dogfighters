#if !defined SERVER_PLAYERS
	#define SERVER_PLAYERS
	enum serverPlayer
	{
		//bool:isConnected = false,
		//bool:isServerSideDamageSync = false,
		flood,
		language,
		name[MAX_PLAYER_NAME + 1],
		money,
		vehicleID,
		kills,
		deaths,
		Float:positionX,
		Float:positionY,
		Float:positionZ,
		anticheat
	}
#endif