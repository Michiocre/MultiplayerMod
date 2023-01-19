// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// An all-in-one action that provides the best way to change to a different level
// 
// Can customize whether the loading image shows, what the
// new game state should be, whether to fade the screen out
// (as well as what color, fade time, etc.), whether to fade
// out the music, whether to travel the inventory and how
// long it should take before a level transition actually occurs


class MACTION_ChangeLevel extends ScriptedAction
	Config(MGame);


struct FadeStruct
{
	var() Color ScreenColor;					  // The color to fade to
	var() float fFadeTime;						  // How long should the fade take in seconds
	var() FadeViewDelegate.enumMoveType FadeType; // What fade type to use
	var() bool bFlash;							  // Whether to flash the fade or not
};

var(Action) string NextLevelName;		// The level to change to
var(Action) bool bShowLoadingImage;		// If true, shows the LOADING image on-screen when the level transition begins
var(Action) bool bSetGameState;			// If true, makes <NewGameState> become the new game state
var(Action) string NewGameState;		// Which game state to change to
var(Action) bool bFadeScreen;			// If true, fades the screen with the settings provided
var(Action) FadeStruct FadeSettings;	// What settings to use when fading the screen
var(Action) bool bFadeOutMusic;			// If true, fades out the music at the same rate as <fLevelTransitionTime>
var(Action) bool bTravelInventory;		// If true, travels the inventory across levels (persists the amount of coins and potions the player had)
var(Action) float fLevelTransitionTime;	// How long the level transition should take (before actually changing the level)


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local FadeViewDelegate Fader;
	local MDelayLevelTransition LT;
	
	if(bSetGameState)
	{
		KWGame(C.Level.Game).SetGameState(NewGameState);
	}
	
	if(bFadeScreen)
	{
		Fader = C.Spawn(class'FadeViewDelegate');
		Fader.Init(float(FadeSettings.ScreenColor.A) / 255, float(FadeSettings.ScreenColor.R) / 255, float(FadeSettings.ScreenColor.G) / 255, float(FadeSettings.ScreenColor.B) / 255, FadeSettings.fFadeTime, FadeSettings.FadeType, FadeSettings.bFlash);
	}
	
	if(bFadeOutMusic)
	{
		PC = KWGame(C.Level.Game).GetHeroController();
		
		if(PC == none)
		{
			Warn(ActionString @ "-- Hero controller could not be found; aborting process");
			
			return false;
		}
		
		PC.StopAllMusic(fLevelTransitionTime);
	}
	
	LT = C.Spawn(class'MDelayLevelTransition');
	LT.fSleepFor = fLevelTransitionTime;
	LT.NextLevelName = NextLevelName;
	LT.bShowLoadingImage = bShowLoadingImage;
	LT.bTravelInventory = bTravelInventory;
	LT.GotoState('WaitForTime');
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Changing to level" @ NextLevelName;
}


defaultproperties
{
	bShowLoadingImage=true
	NewGameState="GSTATE000"
	bFadeScreen=true
	FadeSettings=(ScreenColor=(R=0,G=0,B=0,A=255),fFadeTime=0.0,FadeType=MOVE_TYPE_EASE_FROM,bFlash=false)
	bTravelInventory=true
	ActionString="Change Level"
}