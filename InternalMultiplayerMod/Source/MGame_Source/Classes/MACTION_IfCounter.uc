// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Emulates a physical Counter actor
// In contrast with the default Counter, you can count beyond 255 times, can
// randomize the amount of times it counts and can (technically) reset the counter


class MACTION_IfCounter extends ScriptedAction
	Config(MGame);


struct RandStruct
{
	var() int Min; // The minimum random value
	var() int Max; // The maximum random value
};

var(Action) int iNumToCount;			  // The total amount of counts required in order to return with true
var(Action) bool bUseRandValues;		  // Whether to use random values or not
var(Action) RandStruct Rand_MinMaxValues; // What random values to use (the range)
var(Action) bool bResetIfConditionTrue;	  // Whether to reset the counter or not depending on a condition value
var(Action) name TriggeredConditionTag;	  // The condition's tag
var(Action) bool bOnReset_RedoRandom;	  // Whether to make a new random number for the counter
var int iCurrentCount;					  // The current amount of counts done
var bool bFirstRun;						  // Whether this is the first time the action is being ran


function ProceedToNextAction(ScriptedController C)
{
	local TriggeredCondition TC;
	
	C.ActionNum++;
	
	iCurrentCount++;
	
	if(bResetIfConditionTrue) // Checks whether the counter should be reset or not
	{
		foreach C.AllActors(class'TriggeredCondition', TC, TriggeredConditionTag)
		{
			if(TC.bEnabled) // If this is true, this entire action is reset and will always return false at first
			{
				iCurrentCount = 0;
				
				if(bUseRandValues && bOnReset_RedoRandom)
				{
					SetRandomNumber();
					
					bFirstRun = false;
				}
			}
		}
	}
	
	if(bFirstRun && bUseRandValues) // If this is the first run and we're using random values, set the random value
	{
		SetRandomNumber();
	}
	
	bFirstRun = False;
	
	if(iNumToCount > iCurrentCount) // Checks how many times this action has been called to. If we've counted <iNumToCount> times, we stop counting and always return true
	{
		ProceedToSectionEnd(C);
	}
}

function SetRandomNumber()
{
	local int i1, i2, i3;
	
	// If we're using random values, we run the calculations for what the random number will be, then makes that the total amount of counts required
	
	i1 = Rand_MinMaxValues.Min;
	i2 = Rand_MinMaxValues.Max + 1;
	i3 = i2 - i1;
	
	iNumToCount = (Rand(i3) + i1);
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString;
}


defaultproperties
{
	bFirstRun=true
	bOnReset_RedoRandom=true
	ActionString="If Counter"
}