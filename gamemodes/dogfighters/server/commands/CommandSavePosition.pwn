#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandSavePosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandSavePosition(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/s]: This command is not yet ready. Wait for another gamemode update.");
    else
        SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/s]: Ёта команда ещЄ не готова. ѕодождите до следующего обновлени€ игрового мода.");
    return 1;
}