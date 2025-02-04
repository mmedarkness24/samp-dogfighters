#include "dogfighters\server\serverInfo\ServerPlayers.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

#define DIALOG_SELECT_LANGUAGE 1

forward showSelectLanguageDialog(playerid, serverPlayers[][serverPlayer]);

public showSelectLanguageDialog(playerid, serverPlayers[][serverPlayer])
{
    ShowPlayerDialog(playerid, DIALOG_SELECT_LANGUAGE, DIALOG_STYLE_MSGBOX, "Language selection", "Select your language\nÂûáåðèòå ÿçûê", "English", "Ðóññêèé");
}