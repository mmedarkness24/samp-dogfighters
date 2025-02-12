#if !defined PLAYER_SYSTEMS_DUEL
#define PLAYER_SYSTEMS_DUEL
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward PlayerRequestDuel(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerAcceptDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerDeclineDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerStartDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerStopDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);


public PlayerRequestDuel(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (serverPlayers[playerid][pvpid] > 0)
    {
        if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] This player is already have duel request from someone");
        else
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] У этого игрока уже есть запрос на дуэль с кем-то");
        return;
    }
    new message[128];
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        format(message, sizeof(message), "[/pvp] Player %s (%d) want to start duel with you! Type /y to accept, /n to decline", 
            serverPlayers[targetid][name], 
            targetid);
    else
        format(message, sizeof(message), "[/pvp] Игрок %s (%d) хочет начать с вами дуэль! Напишите /y чтобы согласиться, /n чтобы отказаться", 
            serverPlayers[targetid][name], 
            targetid);   
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
    ServerPlayerSetPvpID(playerid, targetid + MODE_MAX_PLAYERS, serverPlayers);
}

public PlayerAcceptDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    #if DEBUG_MODE == true
    printf("PlayerAcceptDuel (%d) [vs %d] (MODE_MAX_PLAYERS: %d)", playerid, serverPlayers[playerid][pvpid], MODE_MAX_PLAYERS);
    #endif
    if (serverPlayers[playerid][pvpid] < MODE_MAX_PLAYERS)
    {
        #if DEBUG_MODE == true
        printf("PlayerAcceptDuel Something went wrong and pvpid is less then MODE_MAX_PLAYERS");
        #endif
        return;
    }
    new targetid = serverPlayers[playerid][pvpid] - MODE_MAX_PLAYERS;
     #if DEBUG_MODE == true
    printf("PlayerAcceptDuel target: %s (%d)", serverPlayers[targetid][name], targetid);
    #endif
    if (!IsPlayerConnected(targetid))
    {
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/pvp] Player was disconnected from server. Cannot start duel.");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/pvp] Игрок успел выйти с сервера. Невозможно начать дуэль."); 
        #if DEBUG_MODE == true
        printf("PlayerAcceptDuel: player is not connected (%d)", targetid);
        #endif
        return;
    }
    new messageEN[128];
    new messageRU[128];
    format(messageEN, sizeof(messageEN), "[/pvp] Players %s (%d) and %s (%d) started dogfight duel!",
        serverPlayers[targetid][name],
        targetid,
        serverPlayers[playerid][name],
        playerid);
    format(messageRU, sizeof(messageRU), "[/pvp] Игроки %s (%d) и %s (%d) начали дуэль!",
        serverPlayers[targetid][name],
        targetid,
        serverPlayers[playerid][name],
        playerid);
    sendLocalizedMessage(messageRU, messageEN, COLOR_SYSTEM_MAIN, serverPlayers);
    #if DEBUG_MODE == true
    printf("Starting duel between %s (%d) and %s (%d)", serverPlayers[targetid][name], targetid, serverPlayers[playerid][name], playerid);
    #endif
    PlayerStartDuel(playerid, serverPlayers);
    PlayerStartDuel(targetid, serverPlayers);
}

public PlayerDeclineDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (serverPlayers[playerid][pvpid] < 0 || serverPlayers[playerid][pvpid] < MODE_MAX_PLAYERS)
        return 0;
    new targetid = serverPlayers[playerid][pvpid] - MODE_MAX_PLAYERS;
    if (!IsPlayerConnected(targetid))
    {
        #if DEBUG_MODE == true
        printf("PlayerDeclineDuel: something went wrong and player %s is not on server", targetid);
        #endif
    }
    new message[128];
    if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH) 
        format(message, sizeof(message), "Player %s (%d) has declined your duel request", serverPlayers[playerid][name], playerid);
    else
        format(message, sizeof(message), "Игрок %s (%d) отказался от дуэли с вами", serverPlayers[playerid][name], playerid);
    SendClientMessage(targetid, COLOR_SYSTEM_MAIN, message);
    if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH) 
        format(message, sizeof(message), "You declined duel request from %s (%d)", serverPlayers[targetid][name], targetid);
    else
        format(message, sizeof(message), "Вы отказались от дуэли с %s (%d)", serverPlayers[targetid][name], targetid);
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
    ServerPlayerSetPvpID(targetid, NOTSET, serverPlayers);
    ServerPlayerSetPvpID(playerid, NOTSET, serverPlayers);
    return 1;
}

public PlayerStartDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "DUEL STARTED");
}
#endif