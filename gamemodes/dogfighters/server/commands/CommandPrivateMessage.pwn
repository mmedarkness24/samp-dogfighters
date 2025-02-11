#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward CommandPrivateMessage(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public CommandPrivateMessage(playerid, const params[], serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    new messageTo;
	new messageText[256];//86
	if (sscanf(params, "ds[254]", messageTo, messageText))//85
	{
        if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/pm] Syntax: /pm [id] [message]");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/pm]: Синтаксис: /pm [ид] [сообщение]");
		return 1;
	}
	printf("695 messageText len = %d", strlen(messageText));
	if (!IsPlayerConnected(messageTo) || messageTo == playerid)
	{
	    if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    	SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/pm]: Wrong player ID or it's yourself");
		else
		    SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, "[/pm]: Неверный id игрока, либо это ваш собственный id");
		return 1;
	}
	new messageToSend[MAX_PLAYER_NAME + 60];
	if(serverPlayers[messageTo][language] == PLAYER_LANGUAGE_ENGLISH)
	    format(messageToSend, sizeof(messageToSend), "[PM] [from %s (%d)]: %.30s", serverPlayers[playerid][name], playerid, messageText);
	else
	    format(messageToSend, sizeof(messageToSend), "[ЛС] [от %s (%d)]:  %.30s", serverPlayers[playerid][name], playerid, messageText);
 	SendClientMessage(messageTo, COLOR_SYSTEM_PM_FROM, messageToSend);

 	if(serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
	    format(messageToSend, sizeof(messageToSend), "[PM] [for %s (%d)]: %.30s", serverPlayers[messageTo][name], messageTo, messageText);
	else
	    format(messageToSend, sizeof(messageToSend), "[ЛС] [для %s (%d)]:  %.30s", serverPlayers[messageTo][name], messageTo, messageText);
 	SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, messageToSend);
 	printf("816 messageText len = %d", strlen(messageText));
	strdel(messageText, 0, 30);

	while (strlen(messageText) > 0)
	{
	    printf("821 messageText len = %d", strlen(messageText));
	    format(messageToSend, sizeof(messageToSend), "%.54s", messageText);
	    SendClientMessage(messageTo, COLOR_SYSTEM_PM_FROM, messageToSend);
	    SendClientMessage(playerid, COLOR_SYSTEM_PM_TO, messageToSend);
	    strdel(messageText, 0, 54);
	}
	return 1;
}