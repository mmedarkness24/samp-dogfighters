#if !defined PLAYER_CONNECT_PWN
#define PLAYER_CONNECT_PWN
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"


forward PlayerConnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public PlayerConnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new playerName[MAX_PLAYER_NAME + 1];
    new result = GetPlayerName(playerid, playerName, sizeof(playerName));
    #if DEBUG_MODE == true
    if (!result)
    {
        printf("Cannot get player's name: %s (%d)", playerName, playerid);
    }
    #endif
    //serverPlayers[playerid][name] = playerName;
    ServerPlayerSetName(playerid, playerName, serverPlayers);

    new messageEnglish[MAX_PLAYER_NAME + 45];
    format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been connected to server!", serverPlayers[playerid][name], playerid);

    new messageRussian[MAX_PLAYER_NAME + 36];
    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] подключился к серверу!", serverPlayers[playerid][name], playerid);

    sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
}
#endif