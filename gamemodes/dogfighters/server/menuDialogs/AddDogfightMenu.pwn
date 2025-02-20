#if !defined ADD_DOGFIGHT_DIALOG
#define ADD_DOGFIGHT_DIALOG
#define DF_MENU_ERROR_ID -2

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\server\menuDialogs\DialogID.pwn"
#include "dogfighters\server\events\SaveDogfightGlobal.pwn"



forward showAddDFDialog_Player1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_Player2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_Score1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_Score2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_YouTube1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_YouTube2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_Referee(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward showAddDFDialog_Summary(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);

forward processPlayer1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processPlayer2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processScore1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processScore2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processYouTube1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processYouTube2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processRefereeDialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);
forward processSummaryDialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);

public showAddDFDialog_Player1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (dfInfo[usedBy] != NOTSET && dfInfo[usedBy] != playerid)
    {
        if (IsPlayerConnected(dfInfo[usedBy]) && serverPlayers[dfInfo[usedBy]][isLoggedIn])
        {
            printf("Player %s (%d) was trying to use /savedf when it was used by %s (%d)", 
                                                                                        serverPlayers[playerid][name], 
                                                                                        playerid,
                                                                                        serverPlayers[dfInfo[usedBy]][name],
                                                                                        serverPlayers[usedBy]);
            if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
                SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Dogfight adding panel is beasy at this moment. Try again later.");
            else
                SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Панель добавления догфайтов сейчас занята другим игроком. Повторите позже.");
            return;
        }
    }
    dfInfo[usedBy] = playerid;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_PL1, DIALOG_STYLE_INPUT, "Dogfight - Player1 ID", "Enter player 1 ID below:", "Set", "Reset");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_PL1, DIALOG_STYLE_INPUT, "Dogfight - Игрок 1", "Введите ID игрока 1 в поле ниже", "Ок", "Сброс");
}
public showAddDFDialog_Player2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_PL2, DIALOG_STYLE_INPUT, "Dogfight - Player2 ID", "Enter player 2 ID below:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_PL2, DIALOG_STYLE_INPUT, "Dogfight - Игрок 2", "Введите ID игрока 2 в поле ниже", "Ок", "Назад");
}
public showAddDFDialog_Score1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_SC1, DIALOG_STYLE_INPUT, "Dogfight - Player 1 score", "Enter player 1 score below:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_SC1, DIALOG_STYLE_INPUT, "Dogfight - Очки игрок 1", "Введите очки игрока 1 в поле ниже", "Ок", "Назад");
}
public showAddDFDialog_Score2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_SC2, DIALOG_STYLE_INPUT, "Dogfight - Player 2 score", "Enter player 2 score below:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_SC2, DIALOG_STYLE_INPUT, "Dogfight - Очки игрок 2", "Введите очки игрока 2 в поле ниже", "Ок", "Назад");
}
public showAddDFDialog_YouTube1(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT1, DIALOG_STYLE_INPUT, "Dogfight - Video player 1", "Enter player 1 YouTube video URL below:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT1, DIALOG_STYLE_INPUT, "Dogfight - Видео игрок 1", "Введите ссылку на видео от игрока 1 в поле ниже", "Ок", "Назад");
}
public showAddDFDialog_YouTube2(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT2, DIALOG_STYLE_INPUT, "Dogfight - Video player 2", "Enter player 2 YouTube video URL below:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT2, DIALOG_STYLE_INPUT, "Dogfight - Видео игрок 2", "Введите ссылку на видео от игрока 2 в поле ниже", "Ок", "Назад");
}
public showAddDFDialog_Referee(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT2, DIALOG_STYLE_INPUT, "Dogfight - Referee", "Enter referee player ID or -1 if it was\n\"no-referee\" match:", "Set", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_YT2, DIALOG_STYLE_INPUT, "Dogfight - Судейство", "Введите ID рефери, либо -1 (если играли без рефери)\nв поле ниже:", "Ок", "Назад");
}

public showAddDFDialog_Summary(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (isDFPanelBeasy(playerid, serverPlayers, dfInfo))
        return;
    new message[256];
    format(message, sizeof(message), "Dogfight:\n%s (%d) [%d vs %d] %s (%d)\nReferee: id%d",
                                                                                        serverPlayers[dfInfo[player1ID]][name],
                                                                                        dfInfo[player1ID],
                                                                                        dfInfo[player1Score],
                                                                                        dfInfo[player2Score],
                                                                                        serverPlayers[dfInfo[player2ID]][name],
                                                                                        dfInfo[player2ID],
                                                                                        refereeID);
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)                                                                               
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_APPROVE, DIALOG_STYLE_MSGBOX, "Dogfight - Summary", message, "Approve", "Back");
    else
        ShowPlayerDialog(playerid, DIALOG_ADD_DF_APPROVE, DIALOG_STYLE_MSGBOX, "Dogfight - Итого", message, "Сохранить", "Назад");
}


public processPlayer1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        dfInfo[usedBy] = NOTSET;
        return 1;
    }
    new value = validateNumberInput(playerid, inputtext);
    if (value == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Player1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    dfInfo[player1ID] = value;
    showAddDFDialog_Player2(playerid, serverPlayers, dfInfo);
    return 1;
}
public processPlayer2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_Player1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    new value = validateNumberInput(playerid, inputtext);
    if (value == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Player2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    dfInfo[player2ID] = value;
    showAddDFDialog_Score1(playerid, serverPlayers, dfInfo);
    return 1;
}
public processScore1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_Player2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    new value = validateNumberInput(playerid, inputtext);
    if (value == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Score1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    dfInfo[player1Score] = value;
    showAddDFDialog_Score2(playerid, serverPlayers, dfInfo);
    return 1;
}
public processScore2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_Score1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    new value = validateNumberInput(playerid, inputtext);
    if (value == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Score2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    dfInfo[player2Score] = value;
    showAddDFDialog_YouTube1(playerid, serverPlayers, dfInfo);
    return 1;
}
public processYouTube1Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_Score2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    if (validateNumberInput(playerid, inputtext) == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_YouTube1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    return 1;
}
public processYouTube2Dialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_YouTube1(playerid, serverPlayers, dfInfo);
        return 1;
    }
    if (validateNumberInput(playerid, inputtext) == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_YouTube2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    return 1;
}
public processRefereeDialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_YouTube2(playerid, serverPlayers, dfInfo);
        return 1;
    }
    if (validateNumberInput(playerid, inputtext) == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Referee(playerid, serverPlayers, dfInfo);
        return 1;
    }
    return 1;
}

public processSummaryDialog(playerid, response, inputtext[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    if (!response)
    {
        showAddDFDialog_Referee(playerid, serverPlayers, dfInfo);
        return 1;
    }
    if (validateNumberInput(playerid, inputtext) == DF_MENU_ERROR_ID)
    {
        showAddDFDialog_Summary(playerid, serverPlayers, dfInfo);
        return 1;
    }
    return 1;
}

/*
#define DIALOG_ADD_DF_PL1 41
#define DIALOG_ADD_DF_PL2 42
#define DIALOG_ADD_DF_SC1 43
#define DIALOG_ADD_DF_SC2 44
#define DIALOG_ADD_DF_YT1 45
#define DIALOG_ADD_DF_YT2 46
#define DIALOG_ADD_DF_REF 47
#define DIALOG_ADD_DF_APPROVE 48
*/

stock validateNumberInput(playerid, inputtext[])
{
    new value = strval(inputtext);
    if (value == NOTSET)    //  !another check needed!
    {
        //if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Wrong input!");
        /*else
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Неверный ввод");*/
        return DF_MENU_ERROR_ID;
    }
    return value;
}

stock isDFPanelBeasy(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
     if (dfInfo[usedBy] != playerid)
    {
        printf("Player %s (%d) was trying to use /savedf [stage 1+] (he has no rights, current user: %s (%d))", 
                                                                                        serverPlayers[playerid][name], 
                                                                                        playerid,
                                                                                        serverPlayers[dfInfo[usedBy]][name],
                                                                                        serverPlayers[usedBy]);
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Dogfight adding panel is beasy at this moment. Try again later.");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "Панель добавления догфайтов сейчас занята другим игроком. Повторите позже.");
        return true;
    }
    return false;
}

#endif