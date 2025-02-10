#if !defined PLAYER_LANGUAGE_MAIN
#include "dogfighters\server\serverInfo\serverMain.pwn"

#define PLAYER_LANGUAGE_MAIN
	#define PLAYER_LANGUAGE_ENGLISH 0
	#define PLAYER_LANGUAGE_RUSSIAN 1
	forward sendLocalizedMessage(message_ru[], message_en[], color, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
	
	public sendLocalizedMessage(message_ru[], message_en[], color, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
	{
		// new Message[145];
		for (new i = 0; i < MODE_MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
				continue;
			if (serverPlayers[i][language] == PLAYER_LANGUAGE_ENGLISH)
				SendClientMessage(i, color, message_en);
			else
				SendClientMessage(i, color, message_ru);
		}
	}
#endif