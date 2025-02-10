#if !defined DF_MATH_GET_DISTANCE_3D

#define DF_MATH_GET_DISTANCE_3D

#include <math>

forward GetDistanceBetweenCoordinates3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);

public GetDistanceBetweenCoordinates3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
	sqrt((pow(x2 - x1, 2), pow(y2 - y1, 2) + (z2 - z1, 2)));
}

#endif