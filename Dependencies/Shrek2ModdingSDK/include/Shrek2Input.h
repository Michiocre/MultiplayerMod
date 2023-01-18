/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Input
{
public:
	enum Keys {
		A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z,
		NUMBER_0, NUMBER_1, NUMBER_2, NUMBER_3, NUMBER_4, NUMBER_5, NUMBER_6, NUMBER_7, NUMBER_8, NUMBER_9,
		TAB, ENTER, ESCAPE, LEFT_MOUSE_BUTTON, END, RIGHT_MOUSE_BUTTON
	};

	bool OnKeyPress(Keys key);
	bool OnKeyPress(std::string keyBindName);
	bool SimulateKeyPress(Keys key);
	bool EnableConsoleProtection = true;
	
	std::string DllPath;
	HWND WindowHandle;
	bool LoadBinds();
private:
	bool OnKeyPress(int vkey);
	bool BindsExists(std::string name);
	bool IsLoaded = false;
	json LoadedJson;

	void ClearKeyInputBuffer();
	int KeyToVKey(Keys key);
	int KeyToVKey(std::string key);
	bool AllowKeyInput = true;
};

