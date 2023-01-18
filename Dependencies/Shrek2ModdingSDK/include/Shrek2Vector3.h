/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Vector3
{
public:
	float X;
	float Y;
	float Z;

	Shrek2Vector3();
	Shrek2Vector3(float x, float y, float z);
	Shrek2Vector3(float size);

	Shrek2Vector3 operator - (Shrek2Vector3 obj);

	float length();
};

class Shrek2Vector3Int
{
public:
	int X;
	int Y;
	int Z;

	Shrek2Vector3Int();
	Shrek2Vector3Int(int x, int y, int z);
	Shrek2Vector3Int(int size);

	Shrek2Vector3Int operator - (Shrek2Vector3Int obj);

	int length();
};
