/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Vector2
{
public:
	float X;
	float Y;

	Shrek2Vector2() {}
	Shrek2Vector2(float x, float y)
	{
		X = x;
		Y = y;
	}

	Shrek2Vector2(float size)
	{
		X = size;
		Y = size;
	}
};

