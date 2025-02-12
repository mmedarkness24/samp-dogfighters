#if !defined PLAYER_MAIN
	#define PLAYER_MAIN
	//	Functions for specific player on server
	#include "dogfighters/player/localization/PlayerLanguage.pwn"
	#include "dogfighters/player/connect-disconnect/Connect.pwn"
	#include "dogfighters/player/connect-disconnect/Disconnect.pwn"
	#include "dogfighters/player/events/PlayerDeath.pwn"
	#include "dogfighters/player/events/PlayerSpawn.pwn"
	#include "dogfighters/player/events/PlayerSelectClass.pwn"
	#include "dogfighters/player/events/PlayerKill.pwn"
	#include "dogfighters/player/systems/PlayerMoney.pwn"
	#include "dogfighters/player/systems/PlayerDuel.pwn"
#endif