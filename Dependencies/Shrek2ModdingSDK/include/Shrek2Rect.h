/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Rect
{
public:
	int X;
	int Y;
	int X2;
	int Y2;
	int Width;
	int Height;
	Shrek2Rect() {}

	Shrek2Rect(int _X, int _Y, int _Width, int _Height) {
		X = _X;
		Y = _Y;
		Width = _Width;
		Height = _Height;
		X2 = X + Width;
		Y2 = Y + Height;
	}
};

