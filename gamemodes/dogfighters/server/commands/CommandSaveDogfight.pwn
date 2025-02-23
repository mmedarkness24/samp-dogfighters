#if !defined COMMAND_SAVE_DF
#define COMMAND_SAVE_DF

#include "dogfighters\server\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"
#include "dogfighters\database\databaseMain.pwn"

#define DEBUG_MODE_SAVE_DF false

forward CommandSaveDogfight(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo]);

public CommandSaveDogfight(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer], dfInfo[DogfightInfo])
{
    /*new dfInfo[DogfightInfo];
    dfInfo[player1ID] = 0;
    dfInfo[player2ID] = 1;
    dfInfo[player1Score] = 5;
    dfInfo[player2Score] = 4;
    format(dfInfo[videoPlayer1], 127, "https://youtu.be/4Mdyby5IzYw?si=fMfmYomgPOGyqTZZ");
    format(dfInfo[videoPlayer2], 127, "https://youtu.be/CDbW3-FWOWo?si=2dk7MFea83ExRh92");
    dfInfo[refereeID] = NOTSET;

    #if DEBUG_MODE_SAVE_DF == true
    printf("dfInfo: %d vs %d [%d:%d] (%s), (%s) %d", 
                                                    dfInfo[player1ID], 
                                                    dfInfo[player2ID], 
                                                    dfInfo[player1Score],
                                                    dfInfo[player2Score],
                                                    dfInfo[videoPlayer1],
                                                    dfInfo[videoPlayer2],
                                                    dfInfo[refereeID]);
    #endif*/

    if (LoginSystem_GetAccessLevel(playerid, serverPlayers) < 4)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/savedf] You don't have access to this command");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/savedf] У вас нет доступа к этой команде");
	    return 1;
    }
    showAddDFDialog_Player1(playerid, serverPlayers, dfInfo);
    //SaveDogfightData(dfInfo, serverPlayers);
    return 1;
}

#endif