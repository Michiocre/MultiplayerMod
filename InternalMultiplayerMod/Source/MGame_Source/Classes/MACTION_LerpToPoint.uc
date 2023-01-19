// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Finds the KWPawn with the tag <GetPawnTag> and lerps/moves 
// the actor from its current point to the <LerpToTarget> point
// 
// Keywords:
// <GetPawnTag> or LerpToTarget.<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_LerpToPoint extends LatentScriptedAction
	Config(MGame);


struct GetPropStruct
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag;			  // What actor's tag to get
};

var(Action) float LerpToTime;			  // How long will the LerpTo take in seconds
var(Action) KWPawn.enumMoveType EaseType; // What kind of easing should be used
var(Action) GetPropStruct LerpToTarget;	  // What the LerpTo target should be
var(Action) name GetPawnTag;			  // What is the tag of what we're going to move
var Pawn HP;							  // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor;
	local KWPawn TargetPawn;
	local class<Actor> TempActorClass;
	local name TempActorTag1, TempActorTag2;
	
	if(LerpToTarget.GetActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempActorClass = HP.Class;
		TempActorTag1 = HP.Tag;
	}
	else
	{
		TempActorClass = LerpToTarget.GetActorClass;
		TempActorTag1 = LerpToTarget.GetActorTag;
	}
	
	if(GetPawnTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempActorTag2 = HP.Tag;
	}
	else
	{
		TempActorTag2 = GetPawnTag;
	}
	
	if(TempActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
		
		return false;
	}
	
	foreach C.AllActors(TempActorClass, TargetActor, TempActorTag1)
	{
		break;
	}
	
	foreach C.AllActors(class'KWPawn', TargetPawn, TempActorTag2)
	{
		break;
	}
	
	TargetPawn.DoFlyTo(TargetActor.Location, EaseType, LerpToTime);
	
	C.CurrentAction = self;
	C.SetTimer(LerpToTime, false);
	
	return true;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool CompleteWhenTriggered()
{
	return true;
}

function bool CompleteWhenTimer()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Making pawn '" $ string(GetPawnTag) $ "' lerp to point:" @ string(LerpToTarget.GetActorTag);
}


defaultproperties
{
	ActionString="Lerp To Point"
}