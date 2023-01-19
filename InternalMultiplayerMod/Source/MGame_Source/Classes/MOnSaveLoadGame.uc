// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Fires an event depending upon said game event being fired to
// This can be used to create custom events upon a save game or a load game, which is very helpful in some scenarios
// 
// Notice: Pre means before the action happens and Post means after the action has happened


class MOnSaveLoadGame extends MKeypoint
	Config(MGame);


var() name OnPreSaveGameEvent;	// On event PreSaveGame(), what event to fire to
var() name OnPostSaveGameEvent;	// On event PostSaveGame(), what event to fire to
var() name OnPostLoadGameEvent;	// On event PostLoadGame(), what event to fire to


event PreSaveGame()
{
	if(OnPreSaveGameEvent != '')
	{
		TriggerEvent(OnPreSaveGameEvent, none, none);
	}
}

event PostSaveGame()
{
	if(OnPostSaveGameEvent != '')
	{
		TriggerEvent(OnPostSaveGameEvent, none, none);
	}
}

event PostLoadGame(bool bLoadFromSaveGame)
{
	if(bLoadFromSaveGame && OnPostLoadGameEvent != '')
	{
		TriggerEvent(OnPostLoadGameEvent, none, none);
	}
}