// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Triggers a random event upon being fired
// If enabled, supports using weighted odds to make certain events have a higher chance of being fired


class MACTION_TriggerRandomEvent extends ScriptedAction
	Config(MGame);


struct RandStruct
{
	var() name Event; // Which event will be fired to
	var() int Weight; // The weight/chance of the choice. Higher numbers are higher chances
};

var(Action) array<RandStruct> RandEvents; // The array of all Events that can be fired to
var(Action) bool bWeightedOdds;			  // Whether the odds should be weighted or not


function bool InitActionFor(ScriptedController C)
{
	local int i, RandNum, TotalWeight;
	
	if(!bWeightedOdds) // Not using weighted odds
	{
		RandNum = Rand(RandEvents.Length);
		C.TriggerEvent(RandEvents[RandNum].Event, C.SequenceScript, C.GetInstigator());
	}
	else // Using weighted odds
	{
		for(i = 0; i < RandEvents.Length; i++) // Gets the total weight of all entries in the array
		{
			TotalWeight += RandEvents[i].Weight;
		}
		
		RandNum = Rand(TotalWeight); // Picks a random number
		
		for(i = 0; i < RandEvents.Length; i++) // Picks a random action based on the weights
		{
			if(RandNum < RandEvents[i].Weight)
			{
				C.TriggerEvent(RandEvents[i].Event, C.SequenceScript, C.GetInstigator()); // We found the action that corresponds with the random number
				
				break;
			}
			
			RandNum -= RandEvents[i].Weight; // Didn't find the action yet; iterate again
		}
	}
	
	return false;
}

function string GetActionString()
{
	if(!bWeightedOdds) // Not using weighted odds
	{
		return ActionString @ "-- Non-weighted odds";
	}
	else // Using weighted odds
	{
		return ActionString @ "-- Weighted odds";
	}
}


defaultproperties
{
	ActionString="Trigger Random Event"
}