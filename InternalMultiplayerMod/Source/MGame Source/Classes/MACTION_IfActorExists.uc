// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks all actors existing in the map
// Returns true if the specified actor exists and fits the exist type condition


class MACTION_IfActorExists extends ScriptedAction
	Config(MGame);


enum EExistType
{
	ET_DOES_EXIST, 			 // Makes the condition whether <ActorTag> exists at all
	ET_DO_MORE_THAN_X_EXIST, // Makes the condition whether more than <ConditionValue> of <ActorTag> exists
	ET_DOES_X_AMOUNT_EXIST 	 // Makes the condition whether theres exactly <ConditionValue> <ActorTag>
};

var(Action) MACTION_IfActorExists.EExistType ExistType; // What type of existence should be used for the condition
var(Action) int ConditionValue; 						// What value to compare against (depending on the exist type)
var(Action) class<Actor> ActorClass; 					// What actor's class to search for
var(Action) name ActorTag; 								// What actor's tag to search for


function ProceedToNextAction(ScriptedController C)
{
	local Actor TargetActor;
	local int i;
	
	C.ActionNum++;
	
	if(ActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; returning false");
		
		ProceedToSectionEnd(C);
	}
	
	// Gets the total amount of the specified actors in the current level
	foreach C.AllActors(ActorClass, TargetActor, ActorTag)
	{
		i++;
	}
	
	// Returns true or false depending on defined existence type
	switch(ExistType)
	{
		case ET_DOES_EXIST:
			if(i > 0)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case ET_DO_MORE_THAN_X_EXIST:
			if(i > ConditionValue)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case ET_DOES_X_AMOUNT_EXIST:
			if(i == ConditionValue)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ExistType; returning with false");
			
			ProceedToSectionEnd(C);
			
			break;
	}
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Does" @ string(ActorTag) @ "exist";
}


defaultproperties
{
	ActorClass=class'Actor'
	ActionString="If Actor Exists"
}