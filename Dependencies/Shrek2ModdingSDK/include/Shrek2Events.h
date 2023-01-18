/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Events
{
private:
	Shrek2Pointers Variables;

	// OnPlayerInWater
	bool IsPlayerInWater = false;

	// OnPlayerHealth
	float OldPlayerHealth = -1;
	bool PlayerDied = false;

	// OnPlayerInAir
	bool IsPlayerInAir = false;

	// OnPlayerHitJumpMagnet
	bool IsPlayerOnJumpMagnet = false;

	// OnPlayerHitBouncePad
	bool IsPlayerOnBouncePad = false;

	// OnPlayerInfo (Position and Rotation)
	float OldPlayerPositionX = -1;
	float OldPlayerPositionY = -1;
	float OldPlayerPositionZ = -1;

	short OldPlayerRotationX = -1;
	short OldPlayerRotationY = -1;
	short OldPlayerRotationZ = -1;

	// OnMapLoad
	std::string OldMap = "DEFAULT";

	// OnCharacterChanged
	std::string OldCharacterName = "DEFAULT";

	// OnCutLogTick
	int PrevBufCursor = 0;
	std::string PrevBuf = "";

public:
	// Event Update Functions
	void EU_OnPlayerInWater();
	void EU_OnPlayerHealthUpdate();
	void EU_OnPlayerInAirLand();
	void EU_OnPlayerJumpMagnet();
	void EU_OnPlayerBouncePad();
	void EU_OnPlayerInfo();
	void EU_OnMapLoad();
	void EU_OnCharacterChanged();
	void EU_OnCutLogTick();

	Shrek2Events() {
		Variables = Shrek2Pointers();
	}

	void EventUpdates();
	void (*ReorderEvents)();

	/*DONE*/ void (*OnStart)();
	/*DONE*/ void (*OnTick)();
	/*DONE*/ void (*OnMapLoad)(Shrek2Maps oldMap, Shrek2Maps newMap, std::string rawMap); // Fires ONCE when a Map Load is happening
	/*DONE*/ void (*OnPlayerHealthUpdate)(float oldHealth, float newHealth); // Fires EVERY TIME the Player's Health changes
	/*DONE*/ void (*OnPlayerDie)(); // Fires ONCE when the Player dies
	/*DONE*/ void (*OnPlayerRespawn)(); // Fires ONCE when the Player respawns
	/*DONE*/ void (*OnPlayerMove)(float x, float y, float z); // Fires EVERY TIME the Player's Position changes
	/*DONE*/ void (*OnPlayerRotate)(short x, short y, short z); // Fires EVERY TIME the Player's Rotation changes
	/*UNREADY*/ void (*OnPlayerClimb)(); // Fires ONCE when the Player starts climbing
	/*UNREADY*/ void (*OnPlayerClimbDone)(); // Fires ONCE when the Player is done climbing
	/*DONE*/ void (*OnPlayerInWaterEnter)(); // Fires ONCE when the Player enters the water
	/*DONE*/ void (*OnPlayerInWaterTick)(); // Fires EVERY TICK when the Player is in the water
	/*DONE*/ void (*OnPlayerInWaterExit)(); // Fires ONCE when the Player leaves the water
	/*DONE*/ void (*OnPlayerInAirEnter)(); // Fires ONCE when the Player enters the air
	/*DONE*/ void (*OnPlayerInAirTick)(); // Fires EVERY TICK when the Player is in the air
	/*DONE*/ void (*OnPlayerLand)(); // Fires ONCE when the Player lands on the ground
	/*DONE*/ void (*OnPlayerHitJumpMagnetHit)(); // Fires ONCE when the Player hits a Jump Magnet (Auto Jump)
	/*DONE*/ void (*OnPlayerHitJumpMagnetDone)(); // Fires ONCE when the Player finishes a Jump Magnet (Auto Jump)
	/*DONE*/ void (*OnPlayerHitBouncePadHit)(); // Fires ONCE when the Player hits a Bounce Pad
	/*DONE*/ void (*OnPlayerHitBouncePadDone)(); // Fires ONCE when the Player finishes a Bounce Pad
	/*WIP*/ void (*OnPlayerMenuOpen)(); // Fires ONCE when the Player opens the Pause Menu
	/*WIP*/ void (*OnPlayerMenuClose)(); // Fires ONCE when the Player closes the Pause Menu
	/*DONE*/ void (*OnCharacterChanged)(std::string oldCharacter, std::string newCharacter); // Fires ONCE when the Player character is changed
	/*DONE*/ void (*OnCutLogTick)(std::string line); // Fires EVERY TICK with new lines of CutLog Data
	/*WIP*/ void (*OnActorList)(); // Fires every 10th MS (used for Actor stuff)

	// NYI
	/*WIP*/ void (*OnSave)(); // Fires ONCE when a Save is happening
	/*WIP*/ void (*OnLoad)(); // Fires ONCE when a Load is happening
};

