// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks what the current game state is
// Returns true if the game is currently in an expected game state
// Game states must be case-sensitive (aside from caps)


class MACTION_IfGameState extends ScriptedAction
	Config(MGame);


var(Action) array<string> ExpectedGameStates; // Which game states are expected


function ProceedToNextAction(ScriptedController C)
{
	local string GSTATE;
	local int i;
	
	C.ActionNum++;
	
	GSTATE = KWGame(C.Level.Game).CurrentGameState;
	
	for(i = 0; i < ExpectedGameStates.Length; i++)
	{
		if(Caps(ExpectedGameStates[i]) == GSTATE) // If true, the current game state is expected
		{
			break;
		}
		
		if(i >= (ExpectedGameStates.Length - 1)) // If true, all expected game states have been iterated through and none were what the current game state is
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
	return ActionString @ "-- Checking if the current game state is expected";
}


defaultproperties
{
	ExpectedGameStates(0)="GSTATE000"
	ActionString="If Game State"
}