// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A better version of ACTION_PlayMusic that allows you to play a song, randomly play a song or stop all songs


class MACTION_PlayMusic extends ScriptedAction
	Config(MGame);


var(Action) array<String> Songs; // What song(s) to randomly play
var(Action) float fFadeOutTime;	 // How long in seconds to fade out the current song
var(Action) float fFadeInTime;	 // How long in seconds to fade in the new song
var(Action) bool bPickRandom;	 // Whether to pick a random song
var(Action) bool bStopMusic;	 // Whether to stop all music instead


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	PC.StopAllMusic(fFadeOutTime); // Stops all other songs
	
	if(!bStopMusic) // Whether to play another song
	{
		if(!bPickRandom) // Not playing random song
		{
			PC.PlayMusic(Songs[0], fFadeInTime);
		}
		else // Playing random song
		{
			PC.PlayMusic(Songs[Rand(Songs.Length)], fFadeInTime);
		}
	}
	
	return false;
}

function string GetActionString()
{
	if(!bPickRandom)
	{
		return ActionString @ "-- Playing song" @ Songs[0];
	}
	else
	{
		return ActionString @ "-- Playing a random song";
	}
}


defaultproperties
{
	fFadeOutTime=1.0
	fFadeInTime=1.0
	ActionString="Play Music"
}