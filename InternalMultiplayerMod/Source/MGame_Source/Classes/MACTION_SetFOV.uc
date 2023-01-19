// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Sets your FOV to the specified value
// Can be added or multiplied to and can be randomized
// An ease type and time can also be specified
// 
// Keywords:
// fNewFOV -- -1.0 -- Changes to default FOV


class MACTION_SetFOV extends ScriptedAction
	Config(MGame);


struct RandStruct
{
	var() float Min; // The minimum random value
	var() float Max; // The maximum random value
};

var(Action) float fNewFOV;						 // What new FOV should be assigned
var(Action) float fChangeTime;					 // How long it should take for the FOV to change
var(Action) FOVController.enumMoveType EaseType; // What ease type should be used
var(Action) bool bAddFOV;						 // Whether to add to the current FOV or not
var(Action) bool bMultiplyInstead;				 // Whether to multiply instead
var(Action) bool bUseRandValues;				 // Whether to use random values or not
var(Action) RandStruct Rand_MinMaxValues;		 // What random values to use (the range)


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local FOVController Fader;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	Fader = C.Spawn(class'FOVController');
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	if(fNewFOV <= -1.0)
	{
		fNewFOV = PC.default.DefaultFOV;
	}
	
	if(bUseRandValues)
	{
		fNewFOV = RandRange(Rand_MinMaxValues.Min, Rand_MinMaxValues.Max);
	}
	
	if(bAddFOV && !bMultiplyInstead)
	{
		Fader.Init(PC.FovAngle + fNewFOV, fChangeTime, EaseType); // Add FOV
	}
	else if(!bAddFOV && bMultiplyInstead)
	{
		Fader.Init(PC.FovAngle * fNewFOV, fChangeTime, EaseType); // Multiply FOV
	}
	else
	{
		Fader.Init(fNewFOV, fChangeTime, EaseType); // Set FOV
	}
	
	return false;
}

function string GetActionString()
{
	if(!bAddFOV && !bUseRandValues)
	{
		return ActionString @ "-- Setting FOV to" @ string(fNewFOV) @ "over the course of" @ string(fChangeTime) @ "seconds with the ease type of" @ string(EaseType);
	}
	else
	{
		return ActionString @ "-- Setting FOV to either a random value and/or adding/multiplying to FOV over the course of" @ string(fChangeTime) @ "seconds with the ease type of" @ string(EaseType);
	}
}


defaultproperties
{
	fNewFOV=85
	EaseType=MOVE_TYPE_EASE_FROM_AND_TO
	ActionString="Set FOV"
}