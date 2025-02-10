#if !defined HELP_MESSAGE_DIALOG
#define HELP_MESSAGE_DIALOG

#define DIALOG_MESSAGE_HELP

#include "dogfighters\server\serverInfo\serverMain.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\server\menuDialogs\DialogID.pwn"
#include "dogfighters\player\localization\PlayerLanguage.pwn"

forward showHelpMessageDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

public showHelpMessageDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{  
    if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
        ShowPlayerDialog(playerid, DIALOG_HELP_MESSAGE, DIALOG_STYLE_MSGBOX, 
                        "Server information and commands", 
                        "/vehicle /veh /car [ID] [Color1] [Color2] - Take a new personal vehicle\n\
                        /repair /r - Fix a personal vehicle\n\
                        /heal /hp - Heal a player\n\
                        /reclass - Re-select player class\n\
                        /kill - Spawn a player\n\
                        /tp [LocationName] - Teleport to location\n\
                        Locations:\n\
                        /tp ls - teleport to Los Santos International Airport\n\
                        /tp lv - teleport to Las Venturas International Airport\n\
                        /tp sf - teleport to San Fierro International Airport\n\
                        /tp desert - teleport to Desert airspace\n\
                        /tp gate - teleport to Golden Gate Bridge airspace\n\
                        /tp beach - teleport to Los Santos Beach airspace\n\
                        /tp chill - teleport to chiliad mountain",
                        "Ok");
    else
        ShowPlayerDialog(playerid, DIALOG_HELP_MESSAGE, DIALOG_STYLE_MSGBOX, 
                        "Команды и информация о сервере", 
                        "/vehicle /veh /car [ID модели] [Цвет1] [Цвет2] - Получить личный транспорт\n\
                        /repair /r - Починить личный транспорт\n\
                        /heal /hp - Вылечить игрока\n\
                        /reclass - Перевыбрать свой класс\n\
                        /kill - Заспавниться\n\
                        /tp [Название локации] - Телепортироваться на локацию\n\
                        Список локаций:\n\
                        /tp ls - телепорт в Международный Аэропорт Лос Сантос\n\
                        /tp lv - телепорт в Международный Аэропорт Лас Вентурас\n\
                        /tp sf - телепорт в Международный Аэропорт Сан Фиерро\n\
                        /tp desert - телепорт в полётную зону \"Пустыня\"\n\
                        /tp gate - телепорт в полётную зону \"Мост Золотые Ворота\"\n\
                        /tp beach - телепорт в полётную зону \"Пляж ЛС\"\n\
                        /tp chill - телепорт в полётную зону \"Гора Чилиад\"",
                        "Ok");
    return 1;
}
#endif