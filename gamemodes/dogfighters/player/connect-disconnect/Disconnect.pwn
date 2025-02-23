#if !defined PLAYER_DISCONNECT_PWN
#define PLAYER_DISCONNECT_PWN
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"


forward PlayerDisconnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public PlayerDisconnect(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    destroyPlayerVehicle(playerid, serverPlayers);
    //format(serverPlayers[playerid][name[0]], sizeof(serverPlayers[playerid][name[0]]), "");
    
    new messageEnglish[MAX_PLAYER_NAME + 51];
    format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has been disconnected from server=(", serverPlayers[playerid][name], playerid);

    new messageRussian[MAX_PLAYER_NAME + 38];
    format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] отключился от сервера=(", serverPlayers[playerid][name], playerid);

    sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);

    if (ServerPlayerIsInPvp(playerid, serverPlayers))
    {
        #if DEBUG_MODE == true
        printf("Player %s (%d) was in pvp", serverPlayers[playerid][name], playerid);
        #endif
        PlayerIncreaseDuelScore(serverPlayers[playerid][pvpid], 5 - serverPlayers[serverPlayers[playerid][pvpid]][pvpscore], serverPlayers);
    }
    new whowantsPvp = ServerPlayerWhoWantsPvp(playerid, serverPlayers);
    if (whowantsPvp != NOTSET)
    {
        #if DEBUG_MODE == true
        printf("Player ID %d wanted to duel with %s (%d)", whowantsPvp, serverPlayers[playerid][name], playerid);
        #endif
        if (serverPlayers[whowantsPvp][language] == PLAYER_LANGUAGE_ENGLISH) 
            SendClientMessage(whowantsPvp, COLOR_SYSTEM_MAIN, "Player disconnected. Choose someone else to duel with.");
        else
            SendClientMessage(whowantsPvp, COLOR_SYSTEM_MAIN, "Игрок вышел. Придётся найти кого-то другого для дуэли.");
        //PlayerStopDuel(whowantsPvp, serverPlayers);
        PlayerCancelDuel(whowantsPvp, serverPlayers);
    }
    ServerPlayerReset(playerid, serverPlayers);
}
#endif