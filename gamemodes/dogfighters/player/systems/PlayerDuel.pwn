#if !defined PLAYER_SYSTEMS_DUEL
#define PLAYER_SYSTEMS_DUEL
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward PlayerRequestDuel(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerAcceptDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerDeclineDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerStartDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerSpawnDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerStopDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerCancelDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

forward PlayerIncreaseDuelScore(playerid, value, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerWinDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward PlayerDuelUpdateTextdraw(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);


public PlayerRequestDuel(playerid, targetid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!IsPlayerConnected(playerid) || !serverPlayers[playerid][isLoggedIn])
    {
        if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] This player ID is not logged in. Request cancelled.");
        else
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] Нет залогиненного игрока с таким ID. Запрос отменён.");
        ServerPlayerSetPvpID(targetid, NOTSET, serverPlayers);
        return;
    }
    new playerCurrentPvp = ServerPlayerWhoWantsPvp(targetid, serverPlayers);
    if (playerCurrentPvp != NOTSET)
    {
        if (serverPlayers[playerCurrentPvp][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerCurrentPvp, COLOR_SYSTEM_DISCORD, "[/pvp] Player was declined your duel request");
        else
            SendClientMessage(playerCurrentPvp, COLOR_SYSTEM_DISCORD, "[/pvp] Игрок отклонил ваш запрос на дуэль");
        ServerPlayerSetPvpID(playerCurrentPvp, NOTSET, serverPlayers);
    }
    if (serverPlayers[playerid][pvpid] > NOTSET)
    {
        if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] This player is already have duel request from someone");
        else
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] У этого игрока уже есть запрос на дуэль с кем-то");
        //PlayerStopDuel(targetid, serverPlayers);
        ServerPlayerSetPvpID(targetid, NOTSET, serverPlayers);
        return;
    }
    new currentPvp = ServerPlayerWhoWantsPvp(playerid, serverPlayers);
    if (currentPvp > NOTSET && currentPvp != targetid)
    {
        if (serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] This player already have many pvp requests");
        else
            SendClientMessage(targetid, COLOR_SYSTEM_DISCORD, "[/pvp] У этого игрока уже много других запросов на дуэль");
        ServerPlayerSetPvpID(targetid, NOTSET, serverPlayers);
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
    if (serverPlayers[targetid][pvpid] != playerid)
    {
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/pvp] Waiting for duel time is expired.");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/pvp] Истёк срок ожидания по этому запросу."); 
        #if DEBUG_MODE == true
        printf("PlayerAcceptDuel: player request time is expired (%d) for %d", targetid, playerid);
        #endif
        return;
    }
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
    ServerPlayerSetPvpID(playerid, targetid, serverPlayers);
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
    sendLocalizedMessage(messageRU, messageEN, COLOR_SYSTEM_DISCORD, serverPlayers);
    #if DEBUG_MODE == true
    printf("Starting duel between %s (%d) and %s (%d)", serverPlayers[targetid][name], targetid, serverPlayers[playerid][name], playerid);
    #endif
    showDuelHelpDialog(playerid, serverPlayers);
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

public PlayerIncreaseDuelScore(playerid, value, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    ServerPlayerAddPvpScore(playerid, value, serverPlayers);
    #if DEBUG_MODE == true
    printf("Player %s (%d) received 1 score point (total score: %d)", serverPlayers[playerid][name], playerid, serverPlayers[playerid][pvpscore]);
    #endif

    if (AddPlayerMoney(playerid, 5000, serverPlayers))
    {
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Round win bonus: $5000");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Бонус за победу в раунде: $5000");
    }
    #if DEBUG_MODE == true
    printf("player duel [133]------");
    #endif

    if (serverPlayers[playerid][pvpscore] >= 5)
        PlayerWinDuel(playerid, serverPlayers);

    #if DEBUG_MODE == true
    printf("player duel [140]------");
    #endif
    
    if (serverPlayers[playerid][pvptextdraw] == PlayerText:NOTSET)
        return;
    PlayerDuelUpdateTextdraw(playerid, serverPlayers);

    #if DEBUG_MODE == true
    printf("player duel [148]------");
    #endif
}

public PlayerDuelUpdateTextdraw(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new textdrawtext[256];
    /*new score1 = serverPlayers[playerid][pvpscore] > -1 ? serverPlayers[playerid][pvpscore] : 0;
    new score2 = serverPlayers[serverPlayers[playerid][pvpid]][pvpscore] > -1 ? serverPlayers[serverPlayers[playerid][pvpid]][pvpscore] : 0;*/
    format(textdrawtext, sizeof(textdrawtext), "~W~%s ~Y~[~G~%d : %d~Y~] ~W~%s", 
        serverPlayers[playerid][name], 
        serverPlayers[playerid][pvpscore] > -1 ? serverPlayers[playerid][pvpscore] : 0,
        serverPlayers[serverPlayers[playerid][pvpid]][pvpscore] > -1 ? serverPlayers[serverPlayers[playerid][pvpid]][pvpscore] : 0,
        serverPlayers[serverPlayers[playerid][pvpid]][name]);
    PlayerTextDrawSetString(playerid, serverPlayers[playerid][pvptextdraw], textdrawtext);
}

public PlayerWinDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    #if DEBUG_MODE == true
    printf("win duel [168]<<-----");
    #endif
    SaveDogfightPvpData(playerid, serverPlayers[playerid][pvpid], serverPlayers);
    #if DEBUG_MODE == true
    printf("win duel [171]<<-----");
    #endif
    new messageRU[128];
    new messageEN[128];
    format(messageRU, sizeof(messageRU), "Игрок %s (%d) победил в дуэли против %s (%d)", 
        serverPlayers[playerid][name],
        playerid,
        serverPlayers[serverPlayers[playerid][pvpid]][name],
        serverPlayers[playerid][pvpid]);
    format(messageEN, sizeof(messageEN), "Player %s (%d) has won pvp against %s (%d)", 
        serverPlayers[playerid][name],
        playerid,
        serverPlayers[serverPlayers[playerid][pvpid]][name],
        serverPlayers[playerid][pvpid]);
        #if DEBUG_MODE == true
    printf("win duel [187]<<-----");
    #endif
    sendLocalizedMessage(messageRU, messageEN, COLOR_SYSTEM_DISCORD, serverPlayers);
    #if DEBUG_MODE == true
    printf("win duel [191]<<-----");
    #endif
    //  ***    Send duel results logic here    ***
    //  /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    //  ------------------------------------------
    PlayerStopDuel(serverPlayers[playerid][pvpid], serverPlayers);
    #if DEBUG_MODE == true
    printf("win duel [197]<<-----");
    #endif
    PlayerStopDuel(playerid, serverPlayers);
    #if DEBUG_MODE == true
    printf("win duel [199]<<-----");
    #endif
}

public PlayerStartDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    ServerPlayerSetPvpScore(playerid, 0, serverPlayers);
    new textdrawtext[256];
    format(textdrawtext, sizeof(textdrawtext), "~W~%s ~Y~[~G~0 : 0~Y~] ~W~%s", 
        serverPlayers[playerid][name],
        serverPlayers[serverPlayers[playerid][pvpid]][name]);
    ServerPlayerSetPvpTextdraw(playerid, CreatePlayerTextDraw(playerid, 25, 315, textdrawtext), serverPlayers);
    PlayerTextDrawFont(playerid, serverPlayers[playerid][pvptextdraw], 3);
    PlayerTextDrawLetterSize(playerid, serverPlayers[playerid][pvptextdraw], 0.2, 1);
    PlayerTextDrawTextSize(playerid, serverPlayers[playerid][pvptextdraw], 150, 10);
    PlayerTextDrawShow(playerid, serverPlayers[playerid][pvptextdraw]);
    PlayerTextDrawSetOutline(playerid, serverPlayers[playerid][pvptextdraw], 1);
    PlayerTextDrawSetShadow(playerid, serverPlayers[playerid][pvptextdraw], 0);
    PlayerTextDrawBackgroundColor(playerid, serverPlayers[playerid][pvptextdraw], 0x000000AA);
    //TextDrawUseBox(serverPlayers[playerid][pvptextdraw], 1);
    PlayerSpawnDuel(playerid, serverPlayers);
}

public PlayerSpawnDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new virtualWorld = serverPlayers[playerid][pvpid] > playerid ? serverPlayers[playerid][pvpid] : playerid;
    new Float:x, Float:y, Float:z;
    switch(random(10))
    {
        case 0:
        {
            //-278,5;1533,76;75
            x = -278.5;
            y = 1533.76;
            z = 76;
        }
        case 1:
        {
            //315,7;1941,82;17
            x = 315.7;
            y = 1941.82;
            z = 17;
        }
        case 2:
        {
            //199,39;2500,97;16
            x = 199.39;
            y = 2500.97;
            z = 17;
        }
        case 3:
        {
            //-515,77;2594,36;53
            x = -515.77;
            y = 2594.36;
            z = 54;
        }
        case 4:
        {
            //20,79;2039,18;17
            x = 20.79;
            y = 2039.18;
            z = 18;
        }
        case 5:
        {
            //956,72;2669,43;10
            x = 956.72;
            y = 2669.43;
            z = 11;
        }
        case 6:
        {
            //978,89;1373,42;10
            x = 978.89;
            y = 1373.43;
            z = 11;
        }
        case 7: 
        {
            //670,78;2113,69;17
            x = 670.78;
            y = 2113.69;
            z = 18;
        }
        case 8:
        {
            //146,78;1692,78;17
            x = 146.78;
            y = 1692.78;
            z = 18;
        }
        case 9:
        {
            //15,87;1859,86;17
            x = 15.87;
            y = 1859.86;
            z = 18;
        }
        case 10:
        {
            //-264,71;2353,07;109
            x = -264.71;
            y = 2353.07;
            z = 110;
        }
    }
    SetPlayerPos(playerid, x, y, z);
    SetPlayerVirtualWorld(playerid, virtualWorld);
    SetPlayerHealth(playerid, 100);
    SetPlayerArmour(playerid, 100);
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH) 
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "You're in duel now. Take a vehicle (/car) and fight!");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Вы находитесь в дуэли. Возьмите технику (/car) и сражайтесь!");
    GivePlayerWeapon(playerid, 35, 31);
    PlayerDuelUpdateTextdraw(playerid, serverPlayers);
}

public PlayerStopDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new bool:givecash = true;
    if (serverPlayers[serverPlayers[playerid][pvpid]][pvpid] != playerid && 
        serverPlayers[serverPlayers[playerid][pvpid]][pvpid] != NOTSET)
        givecash = false;
    if (serverPlayers[playerid][pvptextdraw] != PlayerText:NOTSET)
        PlayerTextDrawDestroy(playerid, serverPlayers[playerid][pvptextdraw]);
    SetPlayerVirtualWorld(playerid, 0);
    ServerPlayerSetPvpID(playerid, NOTSET, serverPlayers);
    ServerPlayerSetPvpScore(playerid, NOTSET, serverPlayers);
    ServerPlayerSetPvpTextdraw(playerid, PlayerText:NOTSET, serverPlayers);

    if (IsPlayerInAnyVehicle(playerid))
        RemovePlayerFromVehicle(playerid);
    SetPlayerPos(playerid, 0, 0, 5);
    SpawnPlayer(playerid);
    
    if (!givecash)
        return;
    if (!AddPlayerMoney(playerid, 2000, serverPlayers))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Duel participation bonus: $2000");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Бонус за участие в дуэли: $2000");
}

PlayerCancelDuel(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new bool:isActuallyInPvp = false;
    if (serverPlayers[playerid][pvpid] == NOTSET)
        return;
    if (serverPlayers[playerid][pvpscore] > NOTSET)
        isActuallyInPvp = true;
    if (serverPlayers[playerid][pvptextdraw] != PlayerText:NOTSET)
        PlayerTextDrawDestroy(playerid, serverPlayers[playerid][pvptextdraw]);
    SetPlayerVirtualWorld(playerid, 0);
    ServerPlayerSetPvpID(playerid, NOTSET, serverPlayers);
    ServerPlayerSetPvpScore(playerid, NOTSET, serverPlayers);
    ServerPlayerSetPvpTextdraw(playerid, PlayerText:NOTSET, serverPlayers);
    if (!isActuallyInPvp)
        return;
    if (IsPlayerInAnyVehicle(playerid))
        RemovePlayerFromVehicle(playerid);
    SetPlayerPos(playerid, 0, 0, 5);
    SpawnPlayer(playerid);
}
#endif