// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Saves or loads a game. Can save or load to the current save slot
// Simply provide a save slot ID along with whether you wish to save or load a game


class MACTION_SaveLoadGame extends ScriptedAction
	Config(MGame);


enum EActionType // What action type to use
{
	AT_SaveGame,
	AT_LoadGame
};

var(Action) MACTION_SaveLoadGame.EActionType ActionType; // Whether to save or load a game
var(Action) int SaveSlotID;								 // Which save slot to target
var(Action) bool bGetCurrentGameSlot;					 // If true, gets the current game slot to save/load to


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	if(bGetCurrentGameSlot)
	{
		SaveSlotID = class'ShFEGUIPage'.default.GameSlot;
	}
	
	switch(ActionType)
	{
		case AT_SaveGame:
			PC.ConsoleCommand("SaveGame" @ string(SaveSlotID));
			
			break;
		case AT_LoadGame:
			PC.ConsoleCommand("LoadGame" @ string(SaveSlotID));
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			break;
	}
	
	return false;
}

function string GetActionString()
{
	if(bGetCurrentGameSlot)
	{
		SaveSlotID = class'ShFEGUIPage'.default.GameSlot;
	}
	
	switch(ActionType)
	{
		case AT_SaveGame:
			return ActionString @ "-- Saving to save slot" @ string(SaveSlotID);
			
			break;
		case AT_LoadGame:
			return ActionString @ "-- Loading save slot" @ string(SaveSlotID);
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			return ActionString @ "-- ActionType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	ActionString="Save/Load Game"
}