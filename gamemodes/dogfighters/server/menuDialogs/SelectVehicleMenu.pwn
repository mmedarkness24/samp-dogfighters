#include "dogfighters\server\serverInfo\ServerPlayers.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"

#define DIALOG_SELECT_VEHICLE 2
#define DIALOG_SELECT_PLANE 3
#define DIALOG_SELECT_HELI 4
#define DIALOG_SELECT_CAR 5
#define DIALOG_SELECT_BIKE 6
#define DIALOG_SELECT_BOAT 7

forward showSelectVehicleDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectPlaneDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectHeliDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectCarDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectBikeDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectBoatDialog(playerid, serverPlayers[][serverPlayer]);


public showSelectVehicleDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Select a vehicle type", "Plane\nHelicopter\nCar\nBike\nBoat", "Select", "Cancel");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Выберите тип транспорта", "Самолёт\nВертолёт\nАвто\nБайк\nЛодка", "Выбрать", "Отмена");
}
public showSelectPlaneDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Select", "Cancel");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Select", "Cancel");
}
public showSelectHeliDialog(playerid, serverPlayers[][serverPlayer])
{}

public showSelectCarDialog(playerid, serverPlayers[][serverPlayer])
{}

public showSelectBikeDialog(playerid, serverPlayers[][serverPlayer])
{}

public showSelectBoatDialog(playerid, serverPlayers[][serverPlayer])
{}
