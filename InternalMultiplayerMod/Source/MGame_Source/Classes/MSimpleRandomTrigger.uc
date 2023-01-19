// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_TriggerRandomEvent instead
// 
// A trigger that will either fire to event 1 or event 2 when triggered


class MSimpleRandomTrigger extends MTriggers
	Placeable
	Config(MGame);


var() float Probability; // When using the equation, "FRand() > Probability" (FRand() returns a random value between 0 and 1), what number should it compare against? Example: 0.3 = 30% chance
var() name Event1; 		 // The event to run if the comparison check is true
var() name Event2; 		 // The event to run if the comparison check is false
var() bool bEnabled; 	 // Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	if(bEnabled)
	{
		if(FRand() > Probability)
		{
			TriggerEvent(Event1, none, none);
			
			Log("MSimpleRandomTrigger -- Executing event 1");
		}
		else
		{
			TriggerEvent(Event2, none, none);
			
			Log("MSimpleRandomTrigger -- Executing event 2");
		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Activate(Other, Instigator);
}


defaultproperties
{
	bEnabled=true
}