/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Triggers
{
public:
	Shrek2Trigger GetTrigger(std::string name);
	void OverwriteTrigger(std::string name, Shrek2Trigger trigger);
	void AddTrigger(std::string name, Shrek2Trigger trigger);
	void RemoveTrigger(std::string name);

	void CheckTriggers(Shrek2Vector3 position, Shrek2Maps map, Shrek2Vector3 currentSize);
	void ResetAllTriggers();

	void ResetTrigger(std::string name);
	void EnableTrigger(std::string name);
	void DisableTrigger(std::string name);

	bool EnableTriggers = true;
	bool EnableDebugging = false;

	void (*OnTriggerEnter)(std::string name, Shrek2Trigger trigger);
	void (*OnTriggerExit)(std::string name, Shrek2Trigger trigger);
	
	bool TriggerExist(std::string name);
private:
	std::map<std::string, Shrek2Trigger> Triggers;
};

