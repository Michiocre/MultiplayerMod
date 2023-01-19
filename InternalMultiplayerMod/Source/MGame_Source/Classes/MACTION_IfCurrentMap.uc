// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks what the current map name is
// Returns true if the current map is expected
// Make sure to include the literal name of each map (example: 1_Shreks_Swamp.unr)
// Map names must be case-sensitive


class MACTION_IfCurrentMap extends ScriptedAction
	Config(MGame);


var(Action) array<string> ExpectedMapNames; // What does the map name have to be in order to return true


function ProceedToNextAction(ScriptedController C)
{
	local string CurrentMap;
	local int i;
	
	C.ActionNum++;
	
	CurrentMap = C.Level.GetLocalURL() $ ".unr";
	
	for(i = 0; i < ExpectedMapNames.Length; i++)
	{
		if(Right(ExpectedMapNames[i], 4) != ".unr") // Adds .unr to all expected map entries if it wasn't provided
		{
			ExpectedMapNames[i] = ExpectedMapNames[i] $ ".unr";
		}
		
		if(CurrentMap == ExpectedMapNames[i]) // If true, the current map is expected
		{
			break;
		}
		
		if(i >= (ExpectedMapNames.Length - 1)) // If true, all expected map names have been iterated through and none were expected
		{
			ProceedToSectionEnd(C);
		}
	}
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Checking if the current map is any of the expected maps";
}


defaultproperties
{
	ExpectedMapNames(0)="1_Shreks_Swamp.unr"
	ActionString="If Current Map"
}