// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks all actors that the specified actor is touching
// Returns true if the specified actor is touching another specified actor
// 
// Keywords:
// ActorTouchCondition.<ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_IfActorTouching extends ScriptedAction
	Config(MGame);


struct ActorStruct
{
	var() class<Actor> ActorClass; // What actor's class to search for
	var() name ActorTag;		   // What actor's tag to search for
};

enum EConditionType
{
	CT_Any_Actors_Touching,
	CT_All_Actors_Touching,
	CT_X_Amount_Of_Actors_Touching,
	CT_No_Actors_Touching
};

var(Action) array<ActorStruct> Actors;							  // What actors should be used to compare against the condition
var(Action) ActorStruct ActorTouchCondition;					  // What is the actor we're checking to see if it's being touched
var(Action) MACTION_IfActorTouching.EConditionType ConditionType; // What condition type should be used
var(Action) int ConditionAmount;								  // How many of the actors should be touching the specified actor
var Pawn HP;													  // A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local Actor TargetActor;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	local int i, i1;
	
	C.ActionNum++;
	
	if(ActorTouchCondition.ActorTag == 'CurrentPlayer')
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
		TempActorClass = ActorTouchCondition.ActorClass;
		TempActorTag = ActorTouchCondition.ActorTag;
	}
	
	if(Actors[i].ActorClass == none || TempActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; returning false");
		
		ProceedToSectionEnd(C);
	}
	
	// Counts how many actors fit the condition
	for(i = 0; i < Actors.Length; i++)
	{
		foreach C.AllActors(Actors[i].ActorClass, TargetActor, Actors[i].ActorTag)
		{
			if(IsActorTouching(C, TargetActor, TempActorClass, TempActorTag))
			{
				i1++;
			}
		}
	}
	
	switch(ConditionType)
	{
		case CT_Any_Actors_Touching:
			if(i1 > 0)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_All_Actors_Touching:
			if(i1 >= Actors.Length)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_X_Amount_Of_Actors_Touching:
			if(i1 >= ConditionAmount)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_No_Actors_Touching:
			if(i1 <= 0)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ConditionType; returning with false");
			
			ProceedToSectionEnd(C);
			
			break;
	}
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool IsActorTouching(ScriptedController C, Actor Other, class<Actor> TouchClass, name TouchTag) // Returns with true if the actor <Other> is touching the actor with the tag <RangeTag>
{
	local Actor TargetActor;
	
	foreach Other.TouchingActors(TouchClass, TargetActor) 
	{
		if(TargetActor.Tag == TouchTag)
		{
			return true;
		}
	}
	
	return false;
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Comparing if" @ string(ActorTouchCondition.ActorTag) @ "and the list of actors are touching";
}


defaultproperties
{
	ActionString="If Actor Touching"
}