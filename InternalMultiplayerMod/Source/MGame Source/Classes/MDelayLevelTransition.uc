// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A fork of MConsoleCommandDelegate that only changes the level
// Used from within MACTION_ChangeLevel


class MDelayLevelTransition extends Actor
	Notplaceable
	Config(MGame);


var float fSleepFor;		// How long in seconds to sleep for
var string NextLevelName;	// What level to transition to next
var bool bShowLoadingImage;	// Whether the loading image should show or not
var bool bTravelInventory;	// Whether the inventory should travel or not


state WaitForTime // Waits the amount of seconds <fSleepFor> returns with, then transitions to another level
{
Begin:
	Sleep(fSleepFor);
	
	if(bShowLoadingImage)
	{
		Level.ServerTravel(NextLevelName, bTravelInventory);
	}
	else
	{
		Level.ServerTravel(NextLevelName $ "?quiet", bTravelInventory);
	}
	
	self.Destroy();
	
	stop;
}


defaultproperties
{
	bHidden=true
}