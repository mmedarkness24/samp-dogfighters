#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\vehicle\vehicleMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandRepair(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandRepair(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (!IsPlayerInAnyVehicle(playerid))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/repair] You're not in vehicle!");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/repair] Вы не находитесь в транспорте!");
	    return 1;
	}
    if (!AddPlayerMoney(playerid, -1000, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/repair] Not enough money. $1000 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/repair] Недостаточно средств. Необходимо $1000");
	    return 1;
	}
    new vehID = GetPlayerVehicleID(playerid);
    if (vehID > 0)
        RepairVehicle(vehID);
	
	new messageEnglish[MAX_PLAYER_NAME + 38];
	format(messageEnglish, sizeof(messageEnglish), "Player %s [%d] repaired his vehicle", serverPlayers[playerid][name], playerid);

	new messageRussian[MAX_PLAYER_NAME + 38];
	format(messageRussian, sizeof(messageRussian), "Игрок %s [%d] починил свой транспорт", serverPlayers[playerid][name], playerid);
	sendLocalizedMessage(messageRussian, messageEnglish, COLOR_SYSTEM_DISCORD, serverPlayers);
	return 1;
}