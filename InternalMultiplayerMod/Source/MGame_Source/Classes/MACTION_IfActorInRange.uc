// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks all actors that the specified actor is within range of
// Returns true if the specified actor is within range of another specified actor
// 
// Keywords:
// ActorRangeCondition.<ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_IfActorInRange extends ScriptedAction
	Config(MGame);


struct ActorStruct
{
	var() class<Actor> ActorClass; // What actor's class to search for
	var() name ActorTag;		   // What actor's tag to search for
};

struct RangeConditionStruct
{
	var() class<Actor> ActorClass; // What actor's class to search for
	var() name ActorTag;		   // What actor's tag to search for
	var() float Radius;			   // The maximum radius that any of the actors can be away from this conditional actor
};

enum EConditionType
{
	CT_Any_Actors_In_Range,
	CT_All_Actors_In_Range,
	CT_X_Amount_Of_Actors_In_Range,
	CT_No_Actors_In_Range
};

var(Action) array<ActorStruct> Actors;							 // What actors should be used to compare against the condition
var(Action) RangeConditionStruct ActorRangeCondition;			 // What is the actor we're checking to see if it's in range
var(Action) MACTION_IfActorInRange.EConditionType ConditionType; // What condition type should be used
var(Action) int ConditionAmount;								 // How many of the actors should be in range of the specified actor
var Pawn HP;													 // A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local Actor TargetActor;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	local int i, i1;
	
	C.ActionNum++;
	
	if(ActorRangeCondition.ActorTag == 'CurrentPlayer')
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
		TempActorClass = ActorRangeCondition.ActorClass;
		TempActorTag = ActorRangeCondition.ActorTag;
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
			if(IsActorInRange(C, TargetActor, TempActorClass, TempActorTag, ActorRangeCondition.Radius))
			{
				i1++;
			}
		}
	}
	
	switch(ConditionType)
	{
		case CT_Any_Actors_In_Range:
			if(i1 > 0)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_All_Actors_In_Range:
			if(i1 >= Actors.Length)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_X_Amount_Of_Actors_In_Range:
			if(i1 >= ConditionAmount)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case CT_No_Actors_In_Range:
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

function bool IsActorInRange(ScriptedController C, Actor Other, class<Actor> RangeClass, name RangeTag, float RangeRadius) // Returns with true if the actor <Other> is within range of the actor with the tag <RangeTag>
{
	local Actor TargetActor;
	
	foreach Other.RadiusActors(RangeClass, TargetActor, RangeRadius) 
	{
		if(TargetActor.Tag == RangeTag)
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
	return ActionString @ "-- Comparing if" @ ActorRangeCondition.ActorTag @ "and the list of actors are within a radius of" @ ActorRangeCondition.Radius @ "units of each other";
}


defaultproperties
{
	ActionString="If Actor In Range"
}