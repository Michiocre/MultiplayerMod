// *****************************************************
// *				Shrek 2 Multiplayer				   *
// *		   Coded internally by Master_64		   *
// *		   Coded externally by Michiocre		   *
// *	Copyrighted (c) Michiocre & Master_64, 2023	   *
// *   May be modified but not without proper credit!  *
// *****************************************************
// 
// 


class MultiController extends MasterController
	Config(User);


event PostBeginPlay()
{
	super.PostBeginPlay();
	
	Level.PauseDelay = 2147483647.0;
	
	Spawn(class'MultiPlayerTracker');
}

exec function Test(int I)
{
	Announce(string(I));
}


defaultproperties
{
}