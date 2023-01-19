// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Bounces a pawn to a specified point, just like a bounce pad would
// 
// Keywords:
// <PawnTag> or <TargetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_BouncePawnTo extends ScriptedAction
	Config(MGame);


var(Action) class<Pawn> PawnClass;		   // (The pawn to be bounced) What pawn class should be located
var(Action) name PawnTag;				   // (The pawn to be bounced) What pawn tag should be located
var(Action) class<Actor> TargetActorClass; // (The actor to bounce to) What actor class should be located
var(Action) name TargetActorTag;		   // (The actor to bounce to) What actor tag should be located
var(Action) float fTimeToHitTarget;		   // How long in seconds should the bounce take
var(Action) bool bCanMoveWhileJumping;	   // If true, the player can move while mid-bounce
var(Action) Sound BounceSound;			   // If provided a sound, what sound to play when bounced
var(Action) vector vTargetOffset;		   // The offset to apply to the bounce target
var(Action) float fBounceSoundVolume;	   // The volume that the bounce sound should play at
var Pawn HP;							   // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Pawn TargetPawn;
	local Actor TargetActor;
	local class<Pawn> TempPawnClass;
	local class<Actor> TempActorClass;
	local name TempPawnTag, TempActorTag;
	
	if(PawnTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempPawnClass = HP.Class;
		TempPawnTag = HP.Tag;
	}
	else
	{
		TempPawnClass = PawnClass;
		TempPawnTag = PawnTag;
	}
	
	if(TargetActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempActorClass = HP.Class;
		TempActorTag = HP.Tag;
	}
	else
	{
		TempActorClass = TargetActorClass;
		TempActorTag = TargetActorTag;
	}
	
	if(TempPawnClass == none || TempActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
		
		return false;
	}
	
	foreach C.DynamicActors(TempPawnClass, TargetPawn, TempPawnTag)
	{
		break;
	}
	
	foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
	{
		break;
	}
	
	if(TargetPawn == none || TargetActor == none)
	{
		Warn(ActionString @ "-- Failed to find either the pawn to bounce or the target to bounce to; aborting process");
		
		return false;
	}
	
	TargetPawn.SetPhysics(PHYS_Falling);
	TargetPawn.Velocity = ComputeTrajectoryByTime(TargetPawn, TargetPawn.Location, TargetActor.Location + vTargetOffset, fTimeToHitTarget);
	
	if(TargetPawn.IsA('SHHeroPawn'))
	{
		SHHeroPawn(TargetPawn).OnBounceExtra(bCanMoveWhileJumping);
	}
	
	if(BounceSound != none)
	{
		TargetPawn.PlaySound(BounceSound, SLOT_None, fBounceSoundVolume, true, 8192.0, 1.0, true);
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function Vector ComputeTrajectoryByTime(Pawn ComputeGravityActor, Vector vPosStart, Vector vPosEnd, float fTimeEnd, optional float AlternateZAccel)
{
	local vector Velocity;
	local float ZAccel;
	
	if(AlternateZAccel != 0.0)
	{
		ZAccel = AlternateZAccel;        
	}
	else
	{
		ZAccel = ComputeGravityActor.PhysicsVolume.Gravity.Z;
	}
	
	fTimeEnd = FMax(0.001, fTimeEnd);
	Velocity = (vPosEnd - vPosStart) / fTimeEnd;
	Velocity.Z = ((vPosEnd.Z - vPosStart.Z) - ((0.5 * ZAccel) * (fTimeEnd * fTimeEnd))) / fTimeEnd;
	
	return Velocity;
}

function string GetActionString()
{
	return ActionString @ "-- Bouncing pawn to point";
}


defaultproperties
{
	PawnClass=class'Pawn'
	TargetActorClass=class'Actor'
	fTimeToHitTarget=1.5
	BounceSound=Sound'items.boing_leaf'
	fBounceSoundVolume=0.4
	ActionString="Bounce Pawn To"
}