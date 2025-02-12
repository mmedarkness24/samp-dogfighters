#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandTeleportPosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandTeleportPosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if (serverPlayers[playerid][positionX] == NOTSET && 
        serverPlayers[playerid][positionY] == NOTSET && 
        serverPlayers[playerid][positionZ] == NOTSET)
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/t] Teleport position not set! Use /s to save it.");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/t] Позиция телепорта не задана! Используйте /s чтобы сохранить позицию.");
	    return 1;
    }
     if (!AddPlayerMoney(playerid, -20, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/t] Not enough money. $20 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/t] Недостаточно средств! Необходимо $20");
	    return 1;
	}
    new message[128];
    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	format(message, sizeof(message), "Player %s (%d) has teleported to his saved position!", serverPlayers[playerid][name], playerid);
		else
		    format(message, sizeof(message), "Игрок %s (%d) телепортировался на сохранённые координаты!", serverPlayers[playerid][name], playerid);
    SendClientMessageToAll(COLOR_SYSTEM_MAIN, message);
    if (IsPlayerInAnyVehicle(playerid))
    {
        new playerVehicleID = GetPlayerVehicleID(playerid);
        SetVehiclePos(playerVehicleID, serverPlayers[playerid][positionX],serverPlayers[playerid][positionY],serverPlayers[playerid][positionZ]);
    }
    else
        SetPlayerPos(playerid, serverPlayers[playerid][positionX],serverPlayers[playerid][positionY],serverPlayers[playerid][positionZ]);
    /*if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/t]: This command is not yet ready. Wait for another gamemode update.");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/t]: Эта команда ещё не готова. Подождите до следующего обновления игрового мода.");*/
    return 1;
}