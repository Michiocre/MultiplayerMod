// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Locks or unlocks the player's camera to a specific point, just like cutscenes can
// Stoping the LockCamTo is as simple as making <bLock> false


class MACTION_LockCamTo extends ScriptedAction
	Config(MGame);


var(Action) class<Actor> TargetActorClass; // What actor to lock the camera onto
var(Action) name TargetActorTag;		   // What tag to lock the camera onto
var(Action) bool bLock;					   // If true, causes the camera to lock onto the target. If false, will unlock the camera
var(Action) rotator LockCone;			   // The radius at which the player can move their camera around while locked onto a target
var(Action) float fSpeed;				   // The speed at which the camera will move to the target
var(Action) float fTightness;			   // The tightness at which the camera will move to the target


function bool InitActionFor(ScriptedController C)
{
	local CamLockDelegate CL;
	local Actor TargetActor;
	
	if(TargetActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
		
		return false;
	}
	
	foreach C.AllActors(TargetActorClass, TargetActor, TargetActorTag)
	{
		break;
	}
	
	if(TargetActor == none)
	{
		Warn(ActionString @ "-- Failed to find the actor to lock the camera onto; aborting process");
		
		return false;
	}
	
	CL = C.Spawn(class'CamLockDelegate');
	CL.Init(TargetActor, LockCone, bLock, fSpeed, fTightness);
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Locking/unlocking camera onto the actor:" @ string(TargetActorTag);
}


defaultproperties
{
	TargetActorClass=class'Actor'
	bLock=true
	LockCone=(Pitch=2000,Yaw=2000,Roll=2000)
	fSpeed=8.0
	fTightness=8.0
	ActionString="Lock Cam To"
}