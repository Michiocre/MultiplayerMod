#pragma once
class Shrek2Config
{
public:
	Shrek2Config() {}
	Shrek2Config(std::string dllPath) {
		DllPath = dllPath;
	}

	bool Load();

	std::string GetString(std::string fieldName);
	int GetInt(std::string fieldName);
	bool GetBool(std::string fieldName);
	float GetFloat(std::string fieldName);
	long GetLong(std::string fieldName);
private:
	std::string DllPath;
	bool ConfigExists(std::string name);
	bool IsLoaded = false;
	json LoadedJson;
};

