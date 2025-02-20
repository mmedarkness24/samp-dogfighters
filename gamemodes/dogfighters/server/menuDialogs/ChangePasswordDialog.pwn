#if !defined CHANGE_PASSWORD_DIALOG
#define CHANGE_PASSWORD_DIALOG
#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\server\menuDialogs\DialogID.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward showEnterNewPasswordDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public showEnterNewPasswordDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{  
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_ID_CHANGEPWD, DIALOG_STYLE_INPUT, "Change password", "Enter new password below:", "Set", "Cancel");
    else
        ShowPlayerDialog(playerid, DIALOG_ID_CHANGEPWD, DIALOG_STYLE_INPUT, "Смена пароля", "Введите новый пароль в поле ниже:", "Установить", "Отмена");
}
#endif