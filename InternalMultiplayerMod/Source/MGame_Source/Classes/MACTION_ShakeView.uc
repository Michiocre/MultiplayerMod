// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Shakes your screen with the settings provided
// This is essentially a port of the ViewShaker actor, but without the need of an additional actor


class MACTION_ShakeView extends ScriptedAction
	Config(MGame);


var(Action) float ViewRollTime;			// How long to roll the instigator's view (I don't think this actually works)
var(Action) float RollMag;				// How far to roll view
var(Action) float RollRate;				// How fast to roll view
var(Action) float OffsetMagVertical;	// Max view offset vertically
var(Action) float OffsetRateVertical;	// How fast to offset view vertically
var(Action) float OffsetMagHorizontal;	// Max view offset horizontally
var(Action) float OffsetRateHorizontal;	// How fast to offset view horizontally
var(Action) float OffsetIterations;		// How many iterations to offset view


function bool InitActionFor(ScriptedController C)
{
	local vector OffsetMag, OffsetRate;
	local KWHeroController PC;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	OffsetMag = (OffsetMagHorizontal * vect(1, 1, 0)) + (OffsetMagVertical * vect(0, 0, 1));
	OffsetRate = (OffsetRateHorizontal * vect(1, 1, 0)) + (OffsetRateVertical * vect(0, 0, 1));
	
	PC.ShakeView(ViewRollTime, RollMag, OffsetMag, RollRate, OffsetRate, OffsetIterations); // Shakes the screen
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Shaking the view";
}


defaultproperties
{
	ViewRollTime=5
	OffsetMagVertical=10
	OffsetRateVertical=400
	OffsetRateHorizontal=353
	OffsetIterations=500
	ActionString="Shake View"
}