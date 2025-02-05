forward PlayerSelectClass(playerid, classid);
forward SetupPlayerForClassSelection(playerid, classid);

public PlayerSelectClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid, classid);
}

public SetupPlayerForClassSelection(playerid, classid)
{
 	//SetPlayerInterior(playerid,14);
	//new Float:x = 527.82, Float:y = 1226.13, Float:z = 200;
	// GetPlayerPos(playerid, x, y, z);
	switch (classid)
	{
		case 0:
		{
			GameTextForPlayer(playerid, "~r~Punk", 1500, 6);
			SetPlayerPos(playerid,238.01, 2417.06, 16);
			SetPlayerFacingAngle(playerid, 180.0);
			InterpolateCameraPos(playerid, 527.82, 1226.13, 200, 238.33, 2413.38, 17, 500, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 236.39, 2427.47, 200, 236.39, 2427.47, 17, 1000, CAMERA_MOVE);
		}
		case 1:
		{
			GameTextForPlayer(playerid, "~g~Army ~y~(Area 69)", 1500, 6);
			SetPlayerPos(playerid,211.02,1909.53,18);
			SetPlayerFacingAngle(playerid, 180.0);
			InterpolateCameraPos(playerid, 527.82, 1226.13, 200, 211.18, 1903.67, 19, 500, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 211.56, 1918.14, -300, 211.56, 1918.14, 17, 1000, CAMERA_MOVE);
		}
		case 2:
		{
			GameTextForPlayer(playerid, "~g~Army ~b~(SF Carrier)", 1500, 6);
			SetPlayerPos(playerid,-1233.16,474.51, 7);
			SetPlayerFacingAngle(playerid, 270.0);
			InterpolateCameraPos(playerid, -303, 538.43, 100, -1214, 470, 6, 500, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, -1214, 470, -50, -1250.16,481.93, 11, 700, CAMERA_MOVE);
		}
		case 3:
		{
			GameTextForPlayer(playerid, "~w~Dispatch", 1500, 6);
			SetPlayerPos(playerid,1692.8,1447.46,11);
			SetPlayerFacingAngle(playerid, 270.0);
			InterpolateCameraPos(playerid, 1563.44, 1453, 50, 1700.46, 1449.46, 13, 500, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1692.8, 1447.46, 0, 1686.33, 1448.63, 10, 600, CAMERA_MOVE);
		}
		case 4:
		{
			GameTextForPlayer(playerid, "~p~Civil Pilot", 1500, 6);
			SetPlayerPos(playerid,1462.28, -2316.27, 14);
			SetPlayerFacingAngle(playerid, 190.0);
			InterpolateCameraPos(playerid, 116.35, -2032.15, 80, 1459.63, -2322.15, 17, 500, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1462.28, -2316.27, -100, 1462.28, -2316.27, 14, 500, CAMERA_MOVE);
		}
	}
}