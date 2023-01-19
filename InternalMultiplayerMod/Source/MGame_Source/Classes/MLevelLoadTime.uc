// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// If this actor is placed in the level before being loaded, the variable
// <fLevelLoadTime> will reflect how long it took the player to load into the level.
// 
// Note: The player must be using a controller derived from SHHeroController


class MLevelLoadtime extends MKeypoint
	Config(MGame);


#exec TEXTURE IMPORT NAME=MTimer FILE=Textures\MTimer.tga FLAGS=2


var float fLevelLoadTime;


function GetLevelLoadTime(KWHeroController PC)
{
	if(!(PC.IsA('SHHeroController')))
	{
		Warn("MLevelLoadTime -- The player is not using a SHHeroController; aborting process");
		
		return;
	}
	
	fLevelLoadTime = Level.TimeSeconds - SHHeroController(PC).TimeAfterLoading;
	
	Log("MLevelLoadTime -- This level took" @ string(fLevelLoadTime) @ "seconds to load");
}

auto state GetReferences // Gets a PlayerController reference via Tick(). We can't get it through PostBeginPlay() since this actor runs its code earlier than the PlayerController is made
{
	function Tick(float DeltaTime)
	{
		local KWHeroController PC;
		
		PC = KWGame(Level.Game).GetHeroController();
		
		if(PC != none) // Once this is true, we have all of the required references
		{
			GetLevelLoadTime(PC);
			
			GotoState('');
		}
	}
	
Begin:
	stop;
}


defaultproperties
{
	bStatic=false
	Texture=Texture'MTimer'
}