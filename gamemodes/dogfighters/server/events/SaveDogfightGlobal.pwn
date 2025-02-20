#if !defined SAVE_DOGFIGHT_GLOBAL
#define SAVE_DOGFIGHT_GLOBAL
#define DEBUG_MODE_SV_DOGFIGHT true
#include "requests.inc"
#include "dogfighters\server\events\SaveDogfightsSensitive.pwn"
#include "dogfighters\server\serverMain.pwn"

enum DogfightInfo
{
    usedBy,
    player1ID,
    player2ID,
    player1Score,
    player2Score,
    videoPlayer1[128],
    videoPlayer2[128],
    refereeID
}

forward ResetDogfightInfo(dogfightInfo[DogfightInfo]);
forward SaveDogfightData(dogfightInfo[DogfightInfo], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public ResetDogfightInfo(dogfightInfo[DogfightInfo])
{
    dogfightInfo[usedBy] = NOTSET;
    dogfightInfo[player1ID] = NOTSET;
    dogfightInfo[player2ID] = NOTSET;
    dogfightInfo[refereeID] = NOTSET;
    dogfightInfo[player1Score] = 0;
    dogfightInfo[player2Score] = 0;
}

public SaveDogfightData(dogfightInfo[DogfightInfo], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    #if DEBUG_MODE_SV_DOGFIGHT == true
    printf("SaveDogfightData");
    printf("SaveDogfightData: %s (%d) [%d : %d] %s (%d) <ref: (%d)>", 
                                                                    serverPlayers[dogfightInfo[player1ID]][name],
                                                                    dogfightInfo[player1ID],
                                                                    dogfightInfo[player1Score],
                                                                    dogfightInfo[player2Score],
                                                                    serverPlayers[dogfightInfo[player2ID]][name],
                                                                    dogfightInfo[player2ID],
                                                                    dogfightInfo[refereeID]);
    printf("SaveDogfightData1");
    #endif
    if(dogfightInfo[player1ID] == NOTSET || dogfightInfo[player2ID] == NOTSET)
    {
        #if DEBUG_MODE_SV_DOGFIGHT == true
        printf("Cannot create dogfight! Player1 or Player2 id is not set: %d, %d", dogfightInfo[player1ID], dogfightInfo[player2ID]);
        #endif
        return;
    }
    new refName[MAX_PLAYER_NAME + 1];
    if (!IsPlayerConnected(dogfightInfo[refereeID]))
        format(refName, sizeof(refName), "Dogfighters.Svr");
    else
        format(refName, sizeof(refName), serverPlayers[dogfightInfo[refereeID]][name]);

    #if DEBUG_MODE_SV_DOGFIGHT == true
    printf("SaveDogfightData ref: %s (%d)", refName, dogfightInfo[refereeID]);
    #endif

    new req[2048];
	format(req,
		sizeof(req),
		"%s://%s:%s",
		API_DF_PROTOCOL,
		API_DF_HOST,
        API_DF_PORT
	);

    #if DEBUG_MODE_SV_DOGFIGHT == true
    printf("[73]---->Request: %s", req);
    #endif
    new RequestsClient:https = RequestsClient(req);
    RequestJSON(https,
        API_DF_URL,
        HTTP_METHOD_POST,
        "@OnSaveDogfightResult",
        JsonObject(
            "namePlayer1", JsonString(serverPlayers[dogfightInfo[player1ID]][name]),
            "namePlayer2", JsonString(serverPlayers[dogfightInfo[player2ID]][name]),
            "scorePlayer1", JsonInt(dogfightInfo[player1Score]),
            "scorePlayer2", JsonInt(dogfightInfo[player2Score]),
            "videoPlayer1", JsonString(dogfightInfo[videoPlayer1]),
            "videoPlayer2", JsonString(dogfightInfo[videoPlayer2]),
            "referee", JsonString(refName)
        )
    );
    
    #if DEBUG_MODE_SV_DOGFIGHT == true
    printf("SaveDogfightData end");
    #endif
}

//  When get request result received
/*@OnSaveDogfightResult(Request:id, E_HTTP_STATUS:status, Node:node);
@OnSaveDogfightResult(Request:id, E_HTTP_STATUS:status, Node:node)*/
@OnSaveDogfightResult(Request:id, E_HTTP_STATUS:status, data[], dataLen);
@OnSaveDogfightResult(Request:id, E_HTTP_STATUS:status, data[], dataLen)
{
	if(status == HTTP_STATUS_OK) {
        printf("successfully created added Dogfight!");
    }
}


#endif