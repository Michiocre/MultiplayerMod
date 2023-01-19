// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks what the current player's actor class is
// Returns true if the current player is a parent or child of the condition class
// In other words, if the found actor is the same class or a sub-class of the condition class, it will return true


class MACTION_IfCurrentPlayerIsDerivedFrom extends ScriptedAction
	Config(MGame);


var(Action) name ConditionClassName; // What the actor's class needs to be a parent or child of to be true
var Pawn HP;						 // A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local Actor TargetActor;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	
	C.ActionNum++;
	
	GetHeroPawn(C);
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		ProceedToSectionEnd(C);
	}
	
	TempActorClass = HP.Class;
	TempActorTag = HP.Tag;
	
	if(TempActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; returning false");
		
		ProceedToSectionEnd(C);
	}
	
	foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
	{
		if(TargetActor.IsA(ConditionClassName)) // Is the specified actor a parent or child of the condition class?
		{
			break;
		}
		else
		{
			ProceedToSectionEnd(C);
		}
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
	return ActionString @ "-- Checking if current player's class is derived from" @ string(ConditionClassName);
}


defaultproperties
{
	ActionString="If Current Player Is Derived From"
}