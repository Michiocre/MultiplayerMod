// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Gets a specific value from a specific actor and checks if it matches a condition
// Returns true if the TransferProp (the Get) matches the condition (dependent on the Get Type)
// 
// Keywords:
// GetProp.<ActorTag> or OptionalVars.Condition_TransferProp.<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_IfGetProp extends ScriptedAction
	Config(MGlobalData);


enum EGetType
{
	GT_BOOL, 				  // Type Boolean				-- Condition is equal to
	GT_INT, 				  // Type Int					-- Condition is equal to
	GT_LESSTHAN_INT, 		  // Type Int					-- Condition is less than Int
	GT_FLOAT, 				  // Type Float					-- Condition is equal to
	GT_LESSTHAN_FLOAT, 		  // Type Float					-- Condition is less than Float
	GT_STRING, 				  // Type String				-- Condition is equal to
	GT_LENGTH_STRING, 		  // Type String (length; Int)	-- Condition is equal to
	GT_LESSTHAN_LENGTH_STRING // Type String (length; Int)	-- Condition is less than String length
};

struct GetPropStruct
{
	var() class<Actor> ActorClass; // What actor's class to get
	var() name ActorTag; 		   // What actor's tag to get
	var() string Variable; 		   // What actor's variable to get
};

struct TransferPropStruct // If using bConditionFromGetInstead
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct OptionalVarsStruct
{
	var() bool bGetFromConsoleCommandInstead;		 // Whether a Get console command should be ran instead for the Get value
	var() string GetCCString;						 // What Get console command to run for the return value. Example: Get ini:Engine.Engine.ViewportManager WindowedViewportX (will check whether your default windowed X resolution is a certain value)
	var() bool bConditionFromGetInstead;			 // Should the condition be derived from a specific Get instead
	var() TransferPropStruct Condition_TransferProp; // The Gets required for the TransferProp
	var() bool bGetFromGlobalDataInstead;			 // Whether global data should be obtained for the Get value
	var() MGlobalData.EDataType DataType;			 // What data type to use
	var() int Slot;									 // What slot to load data from
	var() bool bGetCurrentGameSlot;					 // If true, gets the current game slot to save/load to
};

var(Action) MACTION_IfGetProp.EGetType GetType; // What Get type should be used for the condition
var(Action) GetPropStruct GetProp;				// The Gets required for the GetProp
var(Action) string Condition; 					// What the condition is (typically a number, but can be a string if you're using a GetType of GT_String)
var(Action) OptionalVarsStruct OptionalVars;	// What optional variables can be set
var Pawn HP;									// A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local KWHeroController PC;
	local Actor TargetActor;
	local string Value;
	local class<Actor> TempActorClass1, TempActorClass2;
	local name TempActorTag1, TempActorTag2;
	
	C.ActionNum++;
	
	if(GetProp.ActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			ProceedToSectionEnd(C);
		}
		
		TempActorClass1 = HP.Class;
		TempActorTag1 = HP.Tag;
	}
	else
	{
		TempActorClass1 = GetProp.ActorClass;
		TempActorTag1 = GetProp.ActorTag;
	}
	
	if(TempActorClass1 == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; returning false");
		
		ProceedToSectionEnd(C);
	}
	
	if(!OptionalVars.bGetFromConsoleCommandInstead && !OptionalVars.bGetFromGlobalDataInstead) // Running typical Get
	{
		foreach C.AllActors(TempActorClass1, TargetActor, TempActorTag1)
		{
			Value = TargetActor.GetPropertyText(GetProp.Variable);
		}
	}
	else if(OptionalVars.bGetFromConsoleCommandInstead && !OptionalVars.bGetFromGlobalDataInstead) // Going to Get from console command's return value
	{
		PC = KWGame(C.Level.Game).GetHeroController();
		
		if(PC == none)
		{
			Warn(ActionString @ "-- Hero controller could not be found; aborting process");
			
			ProceedToSectionEnd(C);
		}
		
		Value = PC.ConsoleCommand(OptionalVars.GetCCString);
	}
	else if(!OptionalVars.bGetFromConsoleCommandInstead && OptionalVars.bGetFromGlobalDataInstead) // Going to Get from global data
	{
		Value = class'MGlobalData'.static.LoadGlobalData(OptionalVars.DataType, OptionalVars.Slot, OptionalVars.bGetCurrentGameSlot);
	}
	else // Running typical Get as a backup
	{
		foreach C.AllActors(TempActorClass1, TargetActor, TempActorTag1)
		{
			Value = TargetActor.GetPropertyText(GetProp.Variable);
		}
	}
	
	if(OptionalVars.bConditionFromGetInstead) // Are we going to make the condition equal a TransferProp
	{
		if(OptionalVars.Condition_TransferProp.GetActorTag == 'CurrentPlayer')
		{
			GetHeroPawn(C);
			
			if(HP == none)
			{
				Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
				
				ProceedToSectionEnd(C);
			}
			
			TempActorClass2 = HP.Class;
			TempActorTag2 = HP.Tag;
		}
		else
		{
			TempActorClass2 = OptionalVars.Condition_TransferProp.GetActorClass;
			TempActorTag2 = OptionalVars.Condition_TransferProp.GetActorTag;
		}
		
		if(TempActorClass2 == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; returning false");
			
			ProceedToSectionEnd(C);
		}
		
		foreach C.AllActors(TempActorClass2, TargetActor, TempActorTag2)
		{
			Condition = TargetActor.GetPropertyText(OptionalVars.Condition_TransferProp.GetVariable);
		}
	}
	
	switch(GetType)
	{
		case GT_BOOL: // If GetBool is true
			if(bool(Value) == bool(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_INT: // If GetInt is equal to condition
			if(int(Value) == int(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_LESSTHAN_INT: // If GetInt is less than or equal to condition
			if(int(Value) <= int(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_FLOAT: // If GetFloat is equal to condition
			if(float(Value) == float(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_LESSTHAN_FLOAT: // If GetFloat is less than or equal to condition
			if(float(Value) <= float(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_STRING: // If GetString is equal to condition
			if(Value == Condition)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_LENGTH_STRING: // If GetString's character length is equal to condition
			if(len(Value) == len(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case GT_LESSTHAN_LENGTH_STRING: // If GetString's character length is less than or equal to condition
			if(len(Value) <= len(Condition))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed GetType; returning with false");
			
			ProceedToSectionEnd(C);
			
			break;
	}
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Comparing GetProp with condition";
}


defaultproperties
{
	ActionString="If Get Prop"
}