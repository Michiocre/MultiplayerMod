// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks if the specific actor is possessed by a specific controller
// Returns true if the specific actor is possessed by a specific controller
// The most useful function of this action is the ability to figure out whether or not the player is in a cutscene
// 
// Keywords:
// <ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_IfPossessedByController extends ScriptedAction
	Config(MGame);


var(Action) name ControllerClassNameCondition; // What controller class we're making the condition
var(Action) class<Actor> ActorClass;		   // What actor's class to search for
var(Action) name ActorTag;					   // What actor's tag to search for
var Pawn HP;								   // A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local Actor TargetActor;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	
	C.ActionNum++;
	
	if(ActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			ProceedToSectionEnd(C);
		}
		
		TempActorClass = HP.Class;
		TempActorTag = HP.Tag;
	}
	else
	{
		TempActorClass = ActorClass;
		TempActorTag = ActorTag;
	}
	
	if(TempActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; returning false");
		
		ProceedToSectionEnd(C);
	}
	
	foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
	{
		if(!Pawn(TargetActor).Controller.IsA(ControllerClassNameCondition)) // Returns true if the specified actor is currently possessed by the controller class specified
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
	return ActionString @ "-- Checking if" @ string(ActorTag) @ "is possessed by the controller type" @ string(ControllerClassNameCondition);
}


defaultproperties
{
	ActorClass=class'Actor'
	ActionString="If Possessed By Controller"
}