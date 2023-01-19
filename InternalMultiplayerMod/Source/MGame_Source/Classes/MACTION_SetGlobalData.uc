// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Sets a value to a slot of global data


class MACTION_SetGlobalData extends ScriptedAction
	Config(MGlobalData);


struct ActionStruct
{
	var() int Slot;						  // Which slot should be saved to
	var() MGlobalData.EDataType DataType; // What data type do we save to
	var() string Value;					  // What is the new value for the data
	var() bool bGetCurrentGameSlot;		  // If true, gets the current game slot to save/load to
};

var(Action) array<ActionStruct> DataActions; // The list of actions that should be gone through
var(Action) bool bResetAllGlobalData;		 // If true, resets all global data



function bool InitActionFor(ScriptedController C)
{
	local int i;
	
	if(!bResetAllGlobalData) // Setting global data
	{
		for(i = 0; i < DataActions.Length; i++)
		{
			class'MGlobalData'.static.SaveGlobalData(DataActions[i].DataType, DataActions[i].Slot, DataActions[i].Value, DataActions[i].bGetCurrentGameSlot);
		}
	}
	else // Resetting global data
	{
		class'MGlobalData'.static.ResetGlobalData();
	}
	
	return false;
}

function string GetActionString()
{
	if(!bResetAllGlobalData)
	{
		return ActionString @ "-- Executing" @ string(DataActions.Length) @ "actions";
	}
	else
	{
		return ActionString @ "-- Resetting all global data";
	}
}


defaultproperties
{
	ActionString="Set Global Data"
}