// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_SetProp instead
// 
// Sets a variable to a specific value on a specific actor


class MSetPropTrigger extends MTriggers
	Placeable
	Config(MGame);


var() class<Actor> ActorClass;	// What actor's class to search for
var() name ActorTag; 			// What actor's tag to search for
var() string Variable; 			// What variable to look for
var() string Value; 			// What value to assign to <Variable>
var() bool bEnabled; 			// Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	local Actor TargetActor;
	
	if(bEnabled == true && ActorTag != '')
	{
		if(ActorClass == none)
		{
			Warn("MSetPropTrigger -- An actor class assignment is missing; aborting process");
			
			return;
		}
		
		foreach AllActors(ActorClass, TargetActor, ActorTag)
		{
			TargetActor.SetPropertyText(Variable, Value); // Sets the actor <ActorTag> with the variable <Variable> to a value of <Value>
			
			Log("MSetPropTrigger --" @ string(ActorTag) @ Variable @ "=" @ Value);
		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Activate(Other, Instigator);
}


defaultproperties
{
	ActorClass=class'Actor'
	bEnabled=true
}