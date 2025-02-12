#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandSavePosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandSavePosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
     if (!AddPlayerMoney(playerid, -400, serverPlayers))
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/s] Not enough money. $400 is needed");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/s] Недостаточно средств! Необходимо $400");
	    return 1;
	}
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    ServerPlayerSetPos(playerid, x, y, z, serverPlayers);
    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/s] Self teleport position saved (for this game session)");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/s] Личная позиция для телепорта сохранена (на эту игровую сессию)");
    return 1;
    /*if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/s]: This command is not yet ready. Wait for another gamemode update.");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/s]: Эта команда ещё не готова. Подождите до следующего обновления игрового мода.");*/
    return 1;
}