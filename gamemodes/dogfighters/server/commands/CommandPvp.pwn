#include "dogfighters\server\menuDialogs\DialogDuelInfo.pwn"
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\playerMain.pwn"

forward CommandPvp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandPvp(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new targetid;
    if (sscanf(params, "d", targetid))
	{
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] Syntax: /pvp [playerid]");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] Синтаксис: /pvp [ID игрока]");
        return 1;
	}
    if (targetid == playerid)
    {
         if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] You can't duel with yourself");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] У вас не получится провести дуэль с самим собой");
        return 1;
    }
    if (targetid < 0 || targetid > MODE_MAX_PLAYERS || !IsPlayerConnected(targetid))
    {
        if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] Wrong player id");
        else
            SendClientMessage(playerid, COLOR_SYSTEM_DISCORD, "[/pvp] Нет такого игрока");
        return 1;
    }
    ServerPlayerSetPvpID(playerid, targetid, serverPlayers);
    PlayerRequestDuel(targetid, playerid, serverPlayers);
    showDuelHelpDialog(playerid, serverPlayers);
    return 1;
}