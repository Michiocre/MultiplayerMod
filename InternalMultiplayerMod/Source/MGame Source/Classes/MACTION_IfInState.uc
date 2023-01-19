// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks what the actor's current state is in
// Returns true if the specific actor is in a specific state
// 
// Keywords:
// <ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_IfInState extends ScriptedAction
	Config(MGame);


var(Action) class<Actor> ActorClass; // What actor's class to search for
var(Action) name ActorTag; 			 // What actor's tag to search for
var(Action) name StateName; 		 // What the state needs to be to return true
var(Action) bool bControllerContext; // Whether to use controller context or not
var Pawn HP;						 // A temporary hero pawn reference


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
		if(!bControllerContext) // Not using controller context
		{
			if(TargetActor.IsInState(StateName)) // Is the specified actor in the specified state
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
		}
		else // Using controller context
		{
			if(Pawn(TargetActor).Controller.IsInState(StateName)) // Is the specified controller in the specified state
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
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
	return ActionString @ "-- Checking if" @ string(ActorTag) @ "is in the state" @ string(StateName) $ ". Using controller context:" @ string(bControllerContext);
}


defaultproperties
{
	ActorClass=class'Actor'
	ActionString="If In State"
}