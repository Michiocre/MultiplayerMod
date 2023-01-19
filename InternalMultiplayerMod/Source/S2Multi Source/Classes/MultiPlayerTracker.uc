// *****************************************************
// *				Shrek 2 Multiplayer				   *
// *		   Coded internally by Master_64		   *
// *		   Coded externally by Michiocre		   *
// *	Copyrighted (c) Michiocre & Master_64, 2023	   *
// *   May be modified but not without proper credit!  *
// *****************************************************
// 
// 


class MultiPlayerTracker extends MKeypoint
	Config(S2Multi);


var KWHeroController PC;
var bool bTestBool;


event PostBeginPlay()
{
	super.PostBeginPlay();
	
	PC = KWGame(Level.Game).GetHeroController();
}

auto state TrackPlayer
{
	function Tick(float DeltaTime)
	{
		if(bTestBool)
		{
			bTestBool = false;
			
			GotoState('WaitASec');
		}
	}
	
Begin:
	stop;
}

state WaitASec
{
Begin:
	PC.ConsoleCommand("RMODE 1");
	PC.ConsoleCommand("PlayASound AllDialog.pc_dnk_bumpline_1575");
	
	Sleep(1.0);
	
	PC.ConsoleCommand("RMODE 5");
	
	GotoState('TrackPlayer');
	stop;
}


defaultproperties
{
	bStatic=false
}