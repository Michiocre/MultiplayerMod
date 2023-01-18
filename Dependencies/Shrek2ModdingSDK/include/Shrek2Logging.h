#pragma once
class Shrek2Logging
{
public:
	static void Log(std::string message);
	static void Log(char* message);
	static void LogError(std::string title, std::string message);
	static void LogError(std::string title, char* message);
};

