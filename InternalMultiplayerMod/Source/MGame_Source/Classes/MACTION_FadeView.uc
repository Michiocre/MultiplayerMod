// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Fades the screen
// Can be given a fade time, fade type, a color and can flash
// To reset the fade values of the screen, set the color value A to 0
// 
// Notice: any sort of screen fades can overwrite other screen fades (including cutscene fades)


class MACTION_FadeView extends ScriptedAction
	Config(MGame);


var(Action) Color ScreenColor;						// The color to fade to
var(Action) float fFadeTime;						// How long should the fade take in seconds
var(Action) FadeViewDelegate.enumMoveType FadeType;	// What fade type to use
var(Action) bool bFlash;							// If true, flashes the screen
var(Action) bool bRandomizeColor;					// If true, randomizes the color


function bool InitActionFor(ScriptedController C)
{
	local FadeViewDelegate Fader;
	local Color TempColor;
	
	if(bRandomizeColor)
	{
		TempColor.R = Rand(256);
		TempColor.G = Rand(256);
		TempColor.B = Rand(256);
		TempColor.A = ScreenColor.A;
	}
	else
	{
		TempColor.R = ScreenColor.R;
		TempColor.G = ScreenColor.G;
		TempColor.B = ScreenColor.B;
		TempColor.A = ScreenColor.A;
	}
	
	Fader = C.Spawn(class'FadeViewDelegate');
	Fader.Init(float(TempColor.A) / 255, float(TempColor.R) / 255, float(TempColor.G) / 255, float(TempColor.B) / 255, fFadeTime, FadeType, bFlash);
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Fading the screen";
}


defaultproperties
{
	ScreenColor=(R=128,G=128,B=128,A=255)
	ActionString="Fade View"
}