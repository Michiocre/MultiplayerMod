/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Trigger
{
public:
	Shrek2Vector3 Position;
	Shrek2Vector3 Size;
	bool Triggered = false;
	bool TriggerOnce = false;
	bool TriggeredOnceExit = false;
	std::list<Shrek2Maps> TriggeredMaps;
	bool Enabled = true;

	bool IsPositionZero();

	Shrek2Trigger() {}

	Shrek2Trigger(Shrek2Vector3 position, Shrek2Vector3 size, bool triggerOnce = false, bool enabled = true)
	{
		Position = position;
		Size = size;
		TriggerOnce = triggerOnce;
		Enabled = enabled;
	}

	Shrek2Trigger(Shrek2Vector3 position, Shrek2Vector3 size, Shrek2Maps triggeredMap, bool triggerOnce = false, bool enabled = true)
	{
		Position = position;
		Size = size;
		TriggeredMaps.push_back(triggeredMap);
		TriggerOnce = triggerOnce;
		Enabled = enabled;
	}

	Shrek2Trigger(Shrek2Vector3 position, Shrek2Vector3 size, std::list<Shrek2Maps> triggeredMaps, bool triggerOnce = false, bool enabled = true)
	{
		Position = position;
		Size = size;
		TriggeredMaps = triggeredMaps;
		TriggerOnce = triggerOnce;
		Enabled = enabled;
	}

	int CheckTrigger(std::string name, Shrek2Vector3 valuePosition, Shrek2Vector3 valueSize, bool enableDebugging);
private:
	bool IsInsideTrigger(Shrek2Vector3 valuePosition, Shrek2Vector3 valueSize);
};

