// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks who you're currently playing as
// Returns true if you're playing as the character with the specified player tag


class MACTION_IfCurrentPlayer extends ScriptedAction
	Config(MGame);


var(Action) array<name> PlayerTags;	// Which players with the tags specified should be checked for
var Pawn HP;						// A temporary hero pawn reference


function ProceedToNextAction(ScriptedController C)
{
	local int i;
	
	C.ActionNum++;
	
	GetHeroPawn(C);
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		ProceedToSectionEnd(C);
	}
	
	for(i = 0; i < PlayerTags.Length; i++)
	{
		if(HP.Tag == PlayerTags[i]) // If true, the current player is expected
		{
			break;
		}
		
		if(i >= (PlayerTags.Length - 1)) // If true, all tags have been iterated through and none were who the current player is
		{
			ProceedToSectionEnd(C);
		}
	}
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Checking if the current player is expected";
}


defaultproperties
{
	PlayerTags(0)=Shrek
	ActionString="If Current Player"
}