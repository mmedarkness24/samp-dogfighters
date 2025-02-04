#include "dogfighters\server\serverInfo\ServerPlayers.pwn"
#include "dogfighters\server\menuDialogs\DialogStyles.pwn"
#include "dogfighters\server\serverInfo\ModeInfo.pwn"

#define DIALOG_SELECT_VEHICLE 2
#define DIALOG_SELECT_PLANE 3
#define DIALOG_SELECT_HELI 4
#define DIALOG_SELECT_CAR 5
#define DIALOG_SELECT_BIKE 6
#define DIALOG_SELECT_BOAT 7
#define DIALOG_SELECT_MILITARY 8

forward showSelectVehicleDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectMilitaryDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectPlaneDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectHeliDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectCarDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectBikeDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);
forward showSelectBoatDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer]);

forward processSelectMilitaryDialog(playerid, selectedCase);
forward processSelectPlaneDialog(playerid, selectedCase);
forward processSelectHeliDialog(playerid, selectedCase);
forward processSelectCarDialog(playerid, selectedCase);
forward processSelectBikeDialog(playerid, selectedCase);
forward processSelectBoatDialog(playerid, selectedCase);

public showSelectVehicleDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Select a vehicle type", "Millitary\nPlane\nHelicopter\nCar\nBike\nBoat", "Select", "Cancel");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_VEHICLE, DIALOG_STYLE_LIST, "Выберите тип транспорта", "Военная техника\nСамолёт\nВертолёт\nАвто\nБайк\nЛодка", "Выбрать", "Отмена");
}
public showSelectMilitaryDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
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
	Rhino\tТанк\tТанковый снаряд\n\
	Seasparrow\tВертолёт\tПулемёт (M4)\n\
	Patriot\tАвтомобиль\tUnarmed\n\
	Predator\tКатер\tUnarmed\n\
	Coastguard\tКатер\tUnarmed", 
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
public showSelectPlaneDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
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
public showSelectHeliDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
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
public showSelectCarDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
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
			return 480;//	Comet
		case 18:
			return 489;//	Rancher
		case 19:
			return 490;//	FBI Rancher
		case 20:
			return 494;//	Hotring Racer
		case 21:
			return 495;//	Sandking
		case 22:
			return 496;//	Blista Compact
		case 23:
			return 506;//	Super GT
		case 24:
			return 528;//	FBI Truck
		case 25:
			return 533;//	Feltzer
		case 26:
			return 534;//	Remington
		case 27:
			return 541;//	Bullet
		case 28:
			return 559;//	Jester
		case 29:
			return 560;//	Sultan
		case 30:
			return 561;//	Stratum
		case 31:
			return 562;//	Elegy
		case 32:
			return 565;//	Flash
		case 33:
			return 567;//	Savanna
		case 34:
			return 575;//	Broadway
		case 35:
			return 579;//	Huntley
		case 36:
			return 580;//	Stafford
		case 37:
			return 601;//	S.W.A.T.
		case 38:
			return 602;//	Alpha
		case 39:
			return 603;//	Phoenix
		case 40:
			return 596;//	Police Car (LSPD)
		case 41:
			return 597;//	Police Car (SFPD)
		case 42:
			return 598;//	Police Car (LVPD)
		case 43:
			return 599;//	Police Ranger
	}
	return 0;
}
public showSelectBikeDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_BIKE, DIALOG_STYLE_LIST, "Select a bike", "Pizzaboy\nPCJ-600\nFaggio\nFreeway\nSanchez\nQuad\nBMX\nBike\nMountain Bike\nFCR-900\nNRG-500\nHPV1000\nBF-400\nWayfarer", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_BIKE, DIALOG_STYLE_LIST, "Выберите байк", "Pizzaboy\nPCJ-600\nFaggio\nFreeway\nSanchez\nQuad\nBMX\nBike\nMountain Bike\nFCR-900\nNRG-500\nHPV1000\nBF-400\nWayfarer", "Выбор", "Назад");
}
//	Returns vehicle model ID to spawn or 0 when error
public processSelectBikeDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 448;
		case 1:
			return 461;
		case 2:
			return 462;
		case 3:
			return 463;
		case 4:
			return 468;
		case 5:
			return 471;
		case 6:
			return 481;
		case 7:
			return 509;
		case 8:
			return 510;
		case 9:
			return 521;
		case 10:
			return 522;
		case 11:
			return 523;
		case 12:
			return 581;
		case 13:
			return 586;
	}
	return 0;
}
public showSelectBoatDialog(playerid, serverPlayers[MODE_MAX_PLAYERS][serverPlayer])
{
	if (serverPlayers[playerid][language] == PLAYER_LANGUAGE_ENGLISH)
    	ShowPlayerDialog(playerid, DIALOG_SELECT_BOAT, DIALOG_STYLE_LIST, "Select a plane", "Predator\nSquallo\nSpeeder\nReefer\nTropic\nCoastguard\nDinghy\nMarquis\nJetmax\nLaunch", "Select", "Back");
	else
	    ShowPlayerDialog(playerid, DIALOG_SELECT_BOAT, DIALOG_STYLE_LIST, "Select a plane", "Predator\nSquallo\nSpeeder\nReefer\nTropic\nCoastguard\nDinghy\nMarquis\nJetmax\nLaunch", "Выбор", "Назад");
}
public processSelectBoatDialog(playerid, selectedCase)
{
	switch(selectedCase)
	{
		case 0:
			return 430;
		case 1:
			return 446;
		case 2:
			return 452;
		case 3:
			return 453;
		case 4:
			return 454;
		case 5:
			return 472;
		case 6:
			return 473;
		case 7:
			return 484;
		case 8:
			return 493;
		case 9:
			return 595;
	}
	return 0;
}
