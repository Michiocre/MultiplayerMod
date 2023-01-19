// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Switches the currently controlled player to a different player
// Similar to the SCTP console command, however, this supports adding a time
// between switches and the ability to swap the locations of both of the players


class MACTION_SwitchControlTo extends ScriptedAction
	Config(MGame);


var(Action) string NewPlayerLabel; // Who is the player going to control next
var(Action) float fTimeToSwitch;   // How long should the camera take to transition between the two players
var(Action) bool bSwapLocations;   // Should the locations of the players be swapped
var Pawn HP;					   // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	GetHeroPawn(C);
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		return false;
	}
	
	if(!(HP.IsA('KWPawn'))) // If true, this means the current player isn't a KWPawn and a fallback method needs to be used instead
	{
		Warn(ActionString @ "-- Using fallback switching method; no additional features can be used aside from the SCTP itself");
		
		KWGame(C.Level.Game).GetHeroController().ConsoleCommand("SCTP" @ NewPlayerLabel);
		
		return false;
	}
	
	KWPawn(HP).SwitchControlToPawn(NewPlayerLabel,, fTimeToSwitch, bSwapLocations); // Switches the control to a different player
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	return ActionString @ "-- Switching control to the new player" @ NewPlayerLabel @ "in" @ string(fTimeToSwitch) @ "seconds. bSwapLocations:" @ string(bSwapLocations);
}


defaultproperties
{
	fTimeToSwitch=1.0
	ActionString="Switch Control To"
}