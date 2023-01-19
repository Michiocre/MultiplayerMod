// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Takes a specified condition and sets its condition to either true or false
// Also comes with the option to toggle the condition if you need that instead


class MACTION_ChangeCondition extends ScriptedAction
	Config(MGame);


var(Action) bool bNewCondition; 		// What new condition value should be assigned
var(Action) name TriggeredConditionTag; // The condition's tag to target
var(Action) bool bToggleInstead; 		// Toggle the condition instead
var TriggeredCondition TempTrig;		// Used in GetActionString()


function bool InitActionFor(ScriptedController C)
{
	local TriggeredCondition TargetActor;
	
	foreach C.DynamicActors(class'TriggeredCondition', TargetActor, TriggeredConditionTag)
	{
		if(!bToggleInstead) // Not toggling
		{
			TargetActor.bEnabled = bNewCondition; // Sets the condition to the new condition value
		}
		else // Toggling
		{
			TargetActor.bEnabled = !TargetActor.bEnabled; // Flips the condition
		}
		
		TempTrig = TargetActor;
	}
	
	return false;
}

function string GetActionString()
{
	if(!bToggleInstead) // Not toggling
	{
		return ActionString @ "-- Set condition" @ string(TriggeredConditionTag) @ "to equal" @ string(bNewCondition);
	}
	else // Toggling
	{
		return ActionString @ "-- Toggled condition" @ string(TriggeredConditionTag) @ "to equal" @ string(TempTrig.bEnabled);
	}
}


defaultproperties
{
	ActionString="Change Condition"
}