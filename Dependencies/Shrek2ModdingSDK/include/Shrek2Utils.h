/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Utils
{
public:
	static std::string FloatToLPCSTR(float fValue);
	static std::string FloatToLPCSTRRaw(float fValue);
	static std::string IntToLPCSTRRaw(int fValue);
	static std::string WS2String(const std::wstring& wstr);
	static Shrek2Maps MapStringToMap(std::string map);
	static std::string StringToLower(std::string str);
	static std::string ReplaceFirstOccurrence(std::string& s, const std::string& toReplace, const std::string& replaceWith);
	static bool DoesEqual(std::string str1, std::string str2);
	static bool DoesEqualForced(std::string str1, std::string str2);
	static RECT GetWindowSize(HWND windowHandle);
	static RECT GetClientSize(HWND windowHandle);
	static std::vector<std::string> SplitString(const std::string& stringToSplit, const std::string& regexPattern);
	static bool Contains(std::string source, std::string find);
	static bool ContainsForced(std::string source, std::string find);
	static bool Overlap(Shrek2Vector2 point, Shrek2Vector2 position, Shrek2Vector2 size);
	static bool Overlap(Shrek2Vector2 point, Shrek2Rect position, Shrek2Vector2 size);
	static bool Overlap(Shrek2Vector2 point, Shrek2Position position, Shrek2Vector2 size);
	static int GameToCharacterType(int gameCharacterId);
	static std::string GameToCharacterName(int gameCharacterId);
	static bool ContainsInVector(std::vector<std::string> list, std::string value);
	static void RemoveNullTerminators(std::string& str);
};

