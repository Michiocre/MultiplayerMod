#pragma once
class Shrek2Storage
{
public:
	Shrek2Storage() {}
	Shrek2Storage(std::string dllPath) {
		DllPath = dllPath;
	}

	std::string GetString(std::string fieldName);
	int GetInt(std::string fieldName);
	bool GetBool(std::string fieldName);
	float GetFloat(std::string fieldName);
	long GetLong(std::string fieldName);

	bool SetString(std::string fieldName, std::string fieldValue);
	bool SetInt(std::string fieldName, int fieldValue);
	bool SetBool(std::string fieldName, bool fieldValue);
	bool SetFloat(std::string fieldName, float fieldValue);
	bool SetLong(std::string fieldName, long fieldValue);
	
	bool Load();
private:
	bool Save();
	std::string DllPath;
	bool SavedVariablesExists(std::string name);
	bool IsLoaded = false;
	json LoadedJson;
};

