// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Similar to ACTION_IfRandomPct, but supports more than 2 outcomes and comes with weighted odds as an option


class MACTION_IfComplexRandomPct extends ScriptedAction
	Config(MGame);


struct RandStruct
{
	var() int ActionNum; // Which action will be gone to
	var() int Weight; 	 // The weight/chance of the choice. Higher numbers are higher chances
};

var(Action) array<RandStruct> RandActionNums; // The array of all ActionNums that can be gone to. Think of this as GotoAction, where it will pick to Goto a certain action
var(Action) bool bWeightedOdds;				  // Whether the odds should be weighted or not


function ProceedToNextAction(ScriptedController C)
{
	local int i, RandNum, TotalWeight;
	
	if(!bWeightedOdds) // Not using weighted odds
	{
		RandNum = Rand(RandActionNums.Length); 					 // Gets the total amount of events that exist in <RandActionNums>, then randomly chooses an action from the list
		C.ActionNum = Max(0, RandActionNums[RandNum].ActionNum); // Goes to action pulled randomly from the <RandActionNums> list
	}
	else // Using weighted odds
	{
		for(i = 0; i < RandActionNums.Length; i++) // Gets the total weight of all entries in the array
		{
			TotalWeight += RandActionNums[i].Weight;
		}
		
		RandNum = Rand(TotalWeight); // Picks a random number
		
		for(i = 0; i < RandActionNums.Length; i++) // Picks a random action based on the weights
		{
			if(RandNum < RandActionNums[i].Weight)
			{
				C.ActionNum = Max(0, RandActionNums[i].ActionNum); // We found the action that corresponds with the random number
				
				break;
			}
			
			RandNum -= RandActionNums[i].Weight; // Didn't find the action yet; iterate again
		}
	}
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
	ActionString="If Complex Random Pct"
}