#if !defined CMD_CANCEL_PVP
#define CMD_CAMCEL_PVP

#define DEBUG_MODE_CANCELPVP true

#include "dogfighters\server\menuDialogs\DialogDuelInfo.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandCancelPvp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandCancelPvp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    #if DEBUG_MODE_CANCELPVP == true
    printf("CommandCancelPvp %d %s", playerid, params);
    #endif
    new message[128];
    if (serverPlayers[playerid][pvpid] == NOTSET)
    {
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            format(message, sizeof(message), "[/pvp] You don't have active duel requests");
        else
            format(message, sizeof(message), "[/pvp] У вас нет активных запросов на дуэль");   
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
        return 1;
    }
    if(serverPlayers[playerid][pvpscore] > 3 || serverPlayers[serverPlayers[playerid][pvpid]][pvpscore] > 3)
    {
        if (serverPlayers[serverPlayers[playerid][pvpid]][language] == PLAYER_LANGUAGE_ENGLISH)
        format(message, sizeof(message), "[/pvp] Player %s (%d) has stopped your duel", 
            serverPlayers[playerid][name], 
            playerid);
        else
            format(message, sizeof(message), "[/pvp] Игрок %s (%d) остановил вашу с ним дуэль", 
                serverPlayers[playerid][name], 
                playerid);   
        SendClientMessage(serverPlayers[playerid][pvpid], COLOR_SYSTEM_MAIN, message);

        if (serverPlayers[serverPlayers[playerid][pvpid]][language] == PLAYER_LANGUAGE_ENGLISH)
            format(message, sizeof(message), "[/pvp] You had stopped pvp with ID %d", 
                serverPlayers[playerid][pvpid]);
        else
            format(message, sizeof(message), "[/pvp] Вы остановили вашу дуэль с ID %d", 
                serverPlayers[playerid][pvpid]);   
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
        PlayerIncreaseDuelScore(serverPlayers[playerid][pvpid], 
                                5 - serverPlayers[serverPlayers[playerid][pvpid]][pvpscore], 
                                serverPlayers);
        return 1;
    }
    #if DEBUG_MODE_CANCELPVP == true
    printf("[50] CommandCancelPvp %d %s", playerid, params);
    #endif
    if (serverPlayers[serverPlayers[playerid][pvpid]][language] == PLAYER_LANGUAGE_ENGLISH)
        format(message, sizeof(message), "[/pvp] Player %s (%d) has cancelled request and stopped duel", 
            serverPlayers[playerid][name], 
            playerid);
    else
        format(message, sizeof(message), "[/pvp] Игрок %s (%d) отменил свой запрос и остановил дуэль", 
            serverPlayers[playerid][name], 
            playerid);   
    SendClientMessage(serverPlayers[playerid][pvpid], COLOR_SYSTEM_MAIN, message);

    if (serverPlayers[serverPlayers[playerid][pvpid]][language] == PLAYER_LANGUAGE_ENGLISH)
        format(message, sizeof(message), "[/pvp] You had cancelled pvp request to ID %d and stopped duel", 
            serverPlayers[playerid][pvpid]);
    else
        format(message, sizeof(message), "[/pvp] Вы отменили свой запрос для ID %d и остановили дуэль", 
            serverPlayers[playerid][pvpid]);   
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
    #if DEBUG_MODE_CANCELPVP == true
    printf("[71] CommandCancelPvp %d %s", playerid, params);
    #endif
    PlayerCancelDuel(serverPlayers[playerid][pvpid], serverPlayers);
    #if DEBUG_MODE_CANCELPVP == true
    printf("[80] CommandCancelPvp %d %s", playerid, params);
    #endif
    PlayerCancelDuel(playerid, serverPlayers);
    #if DEBUG_MODE_CANCELPVP == true
    printf("[76] CommandCancelPvp %d %s", playerid, params);
    #endif
    return 1;
}

#endif