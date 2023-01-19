// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Waits a certain amount of time before continuing the AI script
// Can be assigned a random time and can be assigned a time from a TransferProp
// 
// Keywords:
// TransferProp[i].<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_WaitForTimer extends LatentScriptedAction
	Config(MGame);


struct TransferPropStruct // If using TransferProp
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct RandStruct
{
	var() float Min; // The minimum random value
	var() float Max; // The maximum random value
};

var(Action) float PauseTime;					 // How long to pause for
var(Action) bool bUseRandomValues; 				 // Whether to wait for a random amount of time
var(Action) RandStruct Rand_MinMaxValues; 		 // What random values to use (the range)
var(Action) bool bPullPauseTimeFromTransferProp; // Whether to pull the time from a TransferProp
var(Action) TransferPropStruct TransferProp[2];  // The Get's required for a TransferProp to work. The second TransferProp is optional and works in combination with bUseRandomValues, where the first TransferProp will assign the Min random value and the second will assign the Max random value
var Pawn HP;									 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor;
	local string S;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	local int i;
	
	if(bPullPauseTimeFromTransferProp) // Are we pulling the pause time from a TransferProp
	{
		if(!bUseRandomValues) // Not using random values
		{
			if(TransferProp[0].GetActorTag == 'CurrentPlayer')
			{
				GetHeroPawn(C);
				
				if(HP == none)
				{
					Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
					
					return false;
				}
				
				TempActorClass = HP.Class;
				TempActorTag = HP.Tag;
			}
			else
			{
				TempActorClass = TransferProp[0].GetActorClass;
				TempActorTag = TransferProp[0].GetActorTag;
			}
			
			if(TempActorClass == none)
			{
				Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
				
				return true;
			}
			
			foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
			{
				S = TargetActor.GetPropertyText(TransferProp[0].GetVariable);
				PauseTime = float(S);
			}
		}
		else // Using random values (with TransferProp)
		{
			for(i = 0; i < 2; i++)
			{
				if(TransferProp[i].GetActorTag == 'CurrentPlayer')
				{
					GetHeroPawn(C);
					
					if(HP == none)
					{
						Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
						
						return true;
					}
					
					TransferProp[i].GetActorClass = HP.Class;
					TransferProp[i].GetActorTag = HP.Tag;
				}
				
				if(TransferProp[i].GetActorClass == none)
				{
					Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
					
					return true;
				}
				
				foreach C.AllActors(TransferProp[i].GetActorClass, TargetActor, TransferProp[i].GetActorTag)
				{
					S = TargetActor.GetPropertyText(TransferProp[i].GetVariable);
					
					if(i < 1)
					{
						Rand_MinMaxValues.Min = float(S);
					}
					else
					{
						Rand_MinMaxValues.Max = float(S);
					}
				}
			}
		}
	}
	
	if(bUseRandomValues) // Using random values (with or without TransferProp)
	{
		PauseTime = RandRange(Rand_MinMaxValues.Min, Rand_MinMaxValues.Max);
	}
	
	C.CurrentAction = self;
	C.SetTimer(PauseTime, false);
	
	return true;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool CompleteWhenTriggered()
{
	return true;
}

function bool CompleteWhenTimer()
{
	return true;
}

function string GetActionString()
{
	if(!bUseRandomValues) // Not using random values
	{
		return ActionString @ "-- Pausing for" @ string(PauseTime) @ "seconds";
	}
	else // Using random values (with TransferProp)
	{
		return ActionString @ "-- Pausing for a random amount of time";
	}
}


defaultproperties
{
	ActionString="Wait For Timer"
}