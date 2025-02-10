#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\server\menuDialogs\DialogID.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward showSelectLanguageDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public showSelectLanguageDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
    ShowPlayerDialog(playerid, DIALOG_SELECT_LANGUAGE, DIALOG_STYLE_MSGBOX, "Language selection", "Welcome to Dogfighters SA~MP Server! Choose your Language\nÄîáðî ïîæàëîâàòü íà ñåðâåð Dogfighters! Âûáåðèòå âàø ÿçûê!", "English", "Ðóññêèé");
}