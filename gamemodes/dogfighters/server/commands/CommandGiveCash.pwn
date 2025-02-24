#if !defined COMMAND_GIVE_CASH
#define COMMAND_GIVE_CASH

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandGiveCash(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandGiveCash(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new targetid, cashAmmount;
	if (sscanf(params, "dd", targetid, cashAmmount))//85
	{
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash] Syntax: /givecash [id] [ammount]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash]: Синтаксис: /givecash [ид] [количество]");
		return 1;
	}
	if (!IsPlayerConnected(targetid) || targetid == playerid)
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash]: Wrong player ID or it's yourself");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash]: Неверный id игрока, либо это ваш собственный id");
		return 1;
	}
    if (!serverPlayers[targetid][isLoggedIn])
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash]: Player is not logged in");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, "[/givecash]: Игрок ещё не залогинился");
		return 1;
    }
	new messageToSend[MAX_PLAYER_NAME + 60];
    if (!GiveMoney(playerid, targetid, cashAmmount, serverPlayers))
    {
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            format(messageToSend, sizeof(messageToSend), "[/givecash] cannot send $%d to %s (%d)", cashAmmount, serverPlayers[targetid][name], targetid);
        else
            format(messageToSend, sizeof(messageToSend), "[/givecash] не удалось отправить $%d для %s (%d)", cashAmmount, serverPlayers[targetid][name], targetid);
    }
    else
    {
        if(serverPlayers[targetid][language] == PLAYER_LANGUAGE_ENGLISH)
            format(messageToSend, sizeof(messageToSend), "[/givecash] [from %s (%d)]: $%d", serverPlayers[playerid][name], playerid, cashAmmount);
        else
            format(messageToSend, sizeof(messageToSend), "[/givecash] [от %s (%d)]:  $%d", serverPlayers[playerid][name], playerid, cashAmmount);
        SendClientMessage(targetid, COLOR_SYSTEM_MAIN, messageToSend);

        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
            format(messageToSend, sizeof(messageToSend), "[/givecash] [for %s (%d)]:$%d", serverPlayers[targetid][name], targetid, cashAmmount);
        else
            format(messageToSend, sizeof(messageToSend), "[/givecash] [для %s (%d)]: $%d", serverPlayers[targetid][name], targetid, cashAmmount);
    }
    SendClientMessage(playerid, COLOR_SYSTEM_MAIN, messageToSend);
	return 1;
}

#endif