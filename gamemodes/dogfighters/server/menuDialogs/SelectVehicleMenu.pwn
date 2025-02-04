#include "dogfighters\server\serverInfo\ServerPlayers.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"

#define DIALOG_SELECT_VEHICLE 2
#define DIALOG_SELECT_PLANE 3
#define DIALOG_SELECT_HELI 4
#define DIALOG_SELECT_CAR 5
#define DIALOG_SELECT_BIKE 6
#define DIALOG_SELECT_BOAT 7
#define DIALOG_SELECT_MILITARY 8

forward showSelectVehicleDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectMilitaryDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectPlaneDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectHeliDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectCarDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectBikeDialog(playerid, serverPlayers[][serverPlayer]);
forward showSelectBoatDialog(playerid, serverPlayers[][serverPlayer]);

forward processSelectMilitaryDialog(playerid, selectedCase);
forward processSelectPlaneDialog(playerid, selectedCase);
forward processSelectHeliDialog(playerid, selectedCase);
forward processSelectCarDialog(playerid, selectedCase);
forward processSelectBikeDialog(playerid, selectedCase);
forward processSelectBoatDialog(playerid, selectedCase);

public showSelectVehicleDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Select a vehicle type", "Millitary\nPlane\nHelicopter\nCar\nBike\nBoat", "Select", "Cancel");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Выберите тип транспорта", "Военная техника\nСамолёт\nВертолёт\nАвто\nБайк\nЛодка", "Выбрать", "Отмена");
}
public showSelectMilitaryDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_MILITARY, DIALOG_STYLE_TABLIST_HEADERS, "Select a millitary vehicle", "Name\t\tType\t\tWeapon\n\
	Hydra\tJet\tMissiles\n\
	Rustler\tProp\tMachinegun (M4)\n\
	Hunter\tHelicopter\tMinigun\n\
	Rhino\tTank\tExplosive shells\n\
	Seasparrow\tHelicopter\tMachinegun (M4)\n\
	Patriot\tCar\tUnarmed\n\
	Predator\tBoat\tUnarmed\n\
	Coastguard\tBoat\tUnarmed", 
	"Select", "Cancel");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_MILITARY, DIALOG_STYLE_TABLIST_HEADERS, "Выберите военную технику", "Название\t\tТип\t\tВооружение\n\
	Hydra\tРеактивный самолёт\tРакеты\n\
	Rustler\tПоршневой самолёт\tПулемёт (М4)\n\
	Hunter\tВертолёт\tМиниган\n\
	Rhino\tTank\tТанковый снаряд\n\
	Seasparrow\tHelicopter\tПулемёт (M4)\n\
	Patriot\tCar\tUnarmed\n\
	Predator\tBoat\tUnarmed\n\
	Coastguard\tBoat\tUnarmed", 
	"Выбор", "Отмена");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectMilitaryDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 520;//	Hydra
		case 1:
			return 476;//	Rustler
		case 2:
			return 425;//	Hunter
		case 3:
			return 432;//	Rhino
		case 4:
			return 447;//	Seasparrow
		case 5:
			return 470;//	Patriot
		case 6:
			return 430;//	Predator
		case 7:
			return 472;//	Coastguard
	}
	return 0;
}
public showSelectPlaneDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_PLANE, DIALOG_STYLE_LIST, "Select a plane", "Skimmer\nRustler\nBeagle\nCropduster\nStuntplane\nShamal\nHydra\nNevada\nAT400\nAndromada\nDodo", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_PLANE, DIALOG_STYLE_LIST, "Select a plane", "Skimmer\nRustler\nBeagle\nCropduster\nStuntplane\nShamal\nHydra\nNevada\nAT400\nAndromada\nDodo", "Выбор", "Назад");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectPlaneDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 460;
		case 1:
			return 476;
		case 2:
			return 511;
		case 3:
			return 512;
		case 4:
			return 513;
		case 5:
			return 519;
		case 6:
			return 520;
		case 7:
			return 553;
		case 8:
			return 577;
		case 9:
			return 592;
		case 10:
			return 593;
	}
	return 0;
}
public showSelectHeliDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_HELI, DIALOG_STYLE_LIST, "Select a heli", "Leviathan\nHunter\nSeasparrow\nSparrow\nMaverick\nSAN News Maverick\nPolice Maverick\nCargobob\nRaindance", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_HELI, DIALOG_STYLE_LIST, "Select a heli", "Leviathan\nHunter\nSeasparrow\nSparrow\nMaverick\nSAN News Maverick\nPolice Maverick\nCargobob\nRaindance", "Выбор", "Назад");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectHeliDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 417;
		case 1:
			return 425;
		case 2:
			return 447;
		case 3:
			return 469;
		case 4:
			return 487;
		case 5:
			return 488;
		case 6:
			return 497;
		case 7:
			return 548;
		case 8:
			return 563;
	}
	return 0;
}
public showSelectCarDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_CAR, DIALOG_STYLE_LIST, "Select a car", "Buffalo\nInfernus\nCheetah\nTaxi\nBF Injection\nPremier\nEnforcer\n\
	Banshee\nBus\nBarracks\nCoach\nCabbie\nPacker\nTurismo\n\
	Patriot\nSabre\nZR-350\nComet\nRancher\nFBI Rancher\nHotring Racer\n\
	Sandking\nBlista Compact\nSuper GT\nFBI Truck\nFeltzer\nRemington\nBullet\n\
	Jester\nSultan\nStratum\nElegy\nFlash\nSavanna\nBroadway\n\
	Huntley\nStafford\nS.W.A.T.\nAlpha\nPhoenix\nPolice Car (LSPD)\nPolice Car (SFPD)\nPolice Car (LVPD)\nPolice Ranger", 
	"Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_CAR, DIALOG_STYLE_LIST, "Select a car", "Buffalo\nInfernus\nCheetah\nTaxi\nBF Injection\nPremier\nEnforcer\n\
	Banshee\nBus\nBarracks\nCoach\nCabbie\nPacker\nTurismo\n\
	Patriot\nSabre\nZR-350\nComet\nRancher\nFBI Rancher\nHotring Racer\n\
	Sandking\nBlista Compact\nSuper GT\nFBI Truck\nFeltzer\nRemington\nBullet\n\
	Jester\nSultan\nStratum\nElegy\nFlash\nSavanna\nBroadway\n\
	Huntley\nStafford\nS.W.A.T.\nAlpha\nPhoenix\nPolice Car (LSPD)\nPolice Car (SFPD)\nPolice Car (LVPD)\nPolice Ranger", "Выбор", "Назад");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectCarDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 402;//	Bufallo
		case 1:
			return 411;//	Infernus
		case 2:
			return 415;//	Cheetah
		case 3:
			return 420;//	Taxi
		case 4:
			return 424;//	BF Injection
		case 5:
			return 426;//	Premier
		case 6:
			return 427;//	Enforcer
		case 7:
			return 429;//	Banshee
		case 8:
			return 431;//	Bus
		case 9:
			return 433;//	Barracks
		case 10:
			return 437;//	Coach
		case 11:
			return 438;//	Cabbie
		case 12:
			return 443;//	Packer
		case 13:
			return 451;//	Turismo
		case 14:
			return 470;//	Patriot
		case 15:
			return 475;//	Sabre
		case 16:
			return 477;//	ZR-350
		case 17:
			return 563;
		case 18:
			return 563;
		case 19:
			return 563;
		case 20:
			return 563;
		case 21:
			return 563;
		case 22:
			return 563;
		case 23:
			return 563;
		case 24:
			return 563;
		case 25:
			return 563;
		case 26:
			return 563;
		case 27:
			return 563;
		case 28:
			return 563;
		case 29:
			return 563;
		case 30:
			return 563;
		case 31:
			return 563;
		case 32:
			return 563;
	}
	return 0;
}
public showSelectBikeDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_BIKE, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_BIKE, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Выбор", "Назад");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectBikeDialog(playerid, selectedCase)
{
	return 0;
}
public showSelectBoatDialog(playerid, serverPlayers[][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_BOAT, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_BOAT, DIALOG_STYLE_LIST, "Select a plane", "Hydra\nRustler\nStuntplane\nBeagle\nDodo", "Выбор", "Назад");
}
public processSelectBoatDialog(playerid, selectedCase)
{
}
