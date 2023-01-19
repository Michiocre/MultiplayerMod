// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_IfGetProp instead
// 
// Gets the return value from a Get console command, then fires to either event 1 (if true) or event 2 (if false) depending on the return value


class MIfGetTrigger extends MTriggers
	Placeable
	Config(MGame);


var() string CC_String; 			// What Get console command to run. Example: "Get ini:Engine.Engine.ViewportManager WindowedViewportX" will return with the game's windowed resolution (on X)
var() name Event1; 					// The event to trigger if the comparison check is true
var() name Event2; 					// The event to trigger if the comparison check is false
var() string Condition; 			// What does <CC_String> get compared against (what value)
var() bool bUseLessThanCondition; 	// Whether or not to use less than condition
var() bool bEnabled; 				// Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	local string CC_String2;
	
	if(bEnabled)
	{
		CC_String2 = ConsoleCommand(CC_String);
		// The rest of the code below simply does a comparison of <CC_String2>, which is derived from the Get console command we just ran (the return value), to <Condition>
		if(bUseLessThanCondition)
		{
			if(float(CC_String2) <= float(Condition))
			{
				TriggerEvent(Event1, none, none);
				Log("IfGetTrigger -- '" $ CC_String2 $ "' is less than or equal to '" $ Condition $ "' -- Executing event 1");
			}
			else
			{
				TriggerEvent(Event2, none, none);
				Log("IfGetTrigger -- '" $ CC_String2 $ "' is greater than '" $ Condition $ "' -- Executing event 2");
			}
		}
		if(!bUseLessThanCondition)
		{
			if(float(CC_String2) == float(Condition))
			{
				TriggerEvent(Event1, none, none);
				Log("IfGetTrigger -- '" $ CC_String2 $ "' is exactly equal to '" $ Condition $ "' -- Executing event 1");
			}
			else
			{
				TriggerEvent(Event2, none, none);
				Log("IfGetTrigger -- '" $ CC_String2 $ "' is not exactly equal to '" $ Condition $ "' -- Executing event 2");
			}
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