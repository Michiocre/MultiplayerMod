// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Manages M.A.C. (Master's Anti-Cheat) to change whether it's on or off
// MAntiCheat must be present in the level for this to have an effect


class MACTION_ManageAntiCheat extends ScriptedAction
	Config(MGame);


var(Action) bool bAntiCheatOn; // Whether M.A.C. should be on
var MAntiCheat ACRef;		   // A reference to the anti-cheat actor


function bool InitActionFor(ScriptedController C)
{
	local MAntiCheat AC;
	
	foreach C.DynamicActors(class'MAntiCheat', AC)
	{
		ACRef = AC;
		
		break;
	}
	
	if(ACRef == none)
	{
		Warn(ActionString @ "-- No anti-cheat actor was found in the current level; aborting process");
		
		return false;
	}
	
	if(bAntiCheatOn)
	{
		ACRef.TickEnabled(true);
	}
	else
	{
		ACRef.TickEnabled(false);
	}
	
	return false;
}

function string GetActionString()
{
	if(bAntiCheatOn)
	{
		return ActionString @ "-- Turning on M.A.C.";
	}
	else
	{
		return ActionString @ "-- Turning off M.A.C.";
	}
}


defaultproperties
{
	ActionString="Manage Anti-Cheat"
}