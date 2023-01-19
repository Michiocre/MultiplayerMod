// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_TriggerRandomEvent instead
// 
// Randomly fires to an event inside of the <Events> array


class MComplexRandomTrigger extends MTriggers
	Placeable
	Config(MGame);


var() array<name> Events; // The array of events that can all be fired to (only one will be picked to be fired)
var() bool bEnabled; 	  // Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	local int RandNum;
	
	if(bEnabled)
	{
		RandNum = Rand(Events.Length); // Gets the total amount of events that exist in <Events>, then randomly chooses a number from the list
		
		TriggerEvent(Events[RandNum], none, none); // Triggers an event, which is based off of the previous line of code
		
		Log("MComplexRandomTrigger -- Executing event" @ (RandNum + 1));
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