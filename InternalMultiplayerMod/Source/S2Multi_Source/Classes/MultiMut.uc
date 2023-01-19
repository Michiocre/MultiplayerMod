// *****************************************************
// *				Shrek 2 Multiplayer				   *
// *		   Coded internally by Master_64		   *
// *		   Coded externally by Michiocre		   *
// *	Copyrighted (c) Michiocre & Master_64, 2023	   *
// *   May be modified but not without proper credit!  *
// *****************************************************
// 
// The mutator Shrek 2 Multiplayer relies on to function
// 
// Open 3_The_Hunt_Part1?Mutator=S2Multi.MultiMut


class MultiMut extends MMutRPC
	Config(S2Multi);


event PostBeginPlay()
{
	super.PostBeginPlay();
}


defaultproperties
{
	NewController=class'MultiController'
}