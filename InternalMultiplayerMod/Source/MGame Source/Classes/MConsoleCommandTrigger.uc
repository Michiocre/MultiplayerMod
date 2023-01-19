// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_PlayerConsoleCommand instead
// 
// Runs a player console command upon being activated


class MConsoleCommandTrigger extends MTriggers
	Placeable
	Config(MGame);


#exec TEXTURE IMPORT NAME=MConsoleCommandTrigger FILE=Textures\MConsoleCommandTrigger.tga FLAGS=2


var() array<string> ConsoleCommands; // What console commands to run as the player
var() bool bEnabled;				 // Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	local int i;
	
	if(bEnabled)
	{
		for(i = 0; i < ConsoleCommands.Length; i++) 
		{
			KWGame(Level.Game).GetHeroController().ConsoleCommand("" $ ConsoleCommands[i]); // Executes a console command as if the player did it
			
			Log("MConsoleCommandTrigger -- Executing console command" @ ConsoleCommands[i]);
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
	Texture=Texture'MConsoleCommandTrigger'
}