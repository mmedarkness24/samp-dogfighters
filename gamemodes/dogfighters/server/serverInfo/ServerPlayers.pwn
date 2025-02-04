#if !defined SERVER_PLAYERS
	#define SERVER_PLAYERS
	enum serverPlayer
	{
		bool:isConnected = false,
		bool:isServerSideDamageSync = false,
		name[MAX_PLAYER_NAME + 1],
		language,
		money,
		vehicleID,
		kills,
		deaths,
		Float:positionX,
		Float:positionY,
		Float:positionZ
	}
#endif