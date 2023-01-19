// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Finds the specified pawn, then drops the currently held actor (or instantly destroys if need be)
// This is used for when it's needed to force a pawn to drop an object they're holding
// 
// Keywords:
// <PawnTag> -- CurrentPlayer -- Targets the current player


class MACTION_DropCarryingActor extends ScriptedAction
	Config(MGame);


var(Action) name PawnTag;  // What pawn tag should be located
var(Action) bool bDestroy; // Should the held actor be destroyed instead
var Pawn HP;			   // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local KWPawn KWP;
	local name TempPawnTag;
	
	if(PawnTag == 'CurrentPlayer') // Affecting current player
	{
		GetHeroPawn(C);
		
		TempPawnTag = HP.Tag;
	}
	else // Affecting the specified pawn tag
	{
		foreach C.DynamicActors(class'KWPawn', KWP)
		{
			if(KWP.Tag == PawnTag)
			{
				TempPawnTag = KWP.Tag;
				
				break;
			}
		}
		
		HP = KWP;
	}
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		return false;
	}
	
	if(!(HP.IsA('KWPawn'))) // If this is true, this means the pawn found isn't a KWPawn (which is required for the drop carrying actor to work)
	{
		Warn(ActionString @ "-- Targeted pawn is not a KWPawn; aborting process");
		
		return false;
	}
	
	if(HP.Tag == TempPawnTag)
	{
		if(bDestroy)
		{
			KWPawn(HP).aHolding.Destroy(); // Destroys the carrying actor
		}
		
		KWPawn(HP).DropCarryingActor(); // Drops the carrying actor
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	if(!bDestroy)
	{
		return ActionString @ "-- Dropping" @ string(PawnTag) $ "'s currently held actor";
	}
	else
	{
		return ActionString @ "-- Destroying" @ string(PawnTag) $ "'s currently held actor";
	}
}


defaultproperties
{
	PawnTag=CurrentPlayer
	ActionString="Drop Carrying Actor"
}