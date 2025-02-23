#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

#define VEHICLES_MINIMAL_MODEL_ID 400
#define VEHICLES_MAXIMAL_MODEL_ID 605
#define VEHICLES_FORBIDDEN_MODELS_CHECK vehID == 435 || vehID == 441 || vehID == 450 || vehID == 464 || vehID == 465 || vehID == 501 || vehID == 537 || vehID == 538 || vehID == 564 || vehID == 569 || vehID == 570 || vehID == 590 || vehID == 594

forward CommandGivePlayerVehicle(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandGivePlayerVehicle(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (isnull(params))
    {
        showSelectVehicleDialog(playerid, serverPlayers);
    }
	new vehID = -1, color1 = -1, color2 = -1;
	if (sscanf(params, "ddd", vehID, color1, color2))
	{
        if (vehID < 0)
        {
            showSelectVehicleDialog(playerid, serverPlayers);
            return 1;
		}
	}
	if (!AddPlayerMoney(playerid, -20, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/vehicle] Not enough money. $20 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/vehicle] Недостаточно средств. Необходимо $20");
	    return 1;
	}
	if (color1 < 0 || color2 < 0)
	{
	    color1 = random(255);
	    color2 = random(255);
        new message[128];
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	format(message, sizeof(message), "[/vehicle] Colors not entered, so it will be auto-set to %d and %d", color1, color2);
		else
		    format(message, sizeof(message), "[/vehicle] Вы не указали цвета, поэтому они автоматически установлены на %d и %d", color1, color2);
        SendClientMessage(playerid, COLOR_SYSTEM_MAIN, message);
	}
	#if DEBUG_MODE == true
	    printf("cmd: vehicle(%d, params=%s, vehID=%d, color1=%d, color2=%d)", playerid, params, vehID, color1, color2);
	#endif
	if (vehID < 400 || vehID > 605 || VEHICLES_FORBIDDEN_MODELS_CHECK)
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Wrong vehicle ID!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/vehicle]: Неверный ID транспорта!");
		return 1;
	}
		    
	new messageEnglish[MAX_PLAYER_NAME + 46];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] has taken a new vehicle: %d", serverPlayers[playerid][name], playerid, vehID);
	
	new messageRussian[MAX_PLAYER_NAME + 46];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] взял новый транспорт: %d", serverPlayers[playerid][name], playerid, vehID);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	
	new Float:x, Float:y, Float:z, Float:facingAngle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, facingAngle);
	return GivePlayerVehicle(playerid, vehID, x, y, z, facingAngle, color1, color2, -1, 0, serverPlayers);
}