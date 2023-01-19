// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Teleports an actor to a specified point
// 
// Keywords:
// <ActorTag> or <TargetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_Teleport extends ScriptedAction
	Config(MGame);


var(Action) class<Actor> ActorClass;		  // (The actor to be teleported) What actor class should be located
var(Action) name ActorTag;					  // (The actor to be teleported) What actor tag should be located
var(Action) class<Actor> TargetActorClass;	  // (The actor to teleport to) What actor class should be located
var(Action) name TargetActorTag;			  // (The actor to teleport to) What actor tag should be located
var(Action) bool bRotateToPoint;			  // If true, the camera and player will rotate to the teleportation point's rotation
var(Action) Sound TeleportSound;			  // If provided a sound, what sound to play when teleported
var(Action) Sound TeleportFailedSound;		  // If provided a sound, what sound to play when a teleport fails
var(Action) float fTeleportSoundVolume;		  // The volume the teleport sound should play at
var(Action) int iTeleportAdjustRetryAttempts; // How many times should a teleport be retried if the teleport initially fails (due to the location being blocked). A safe value is 28, however if a teleport you need isn't working consistently, you may need to increase this value (however higher values may impact performance)
var(Action) bool bTeleportAdjustZOnly;		  // If true, if a teleport fails, teleport adjustments will only be made on the Z axis
var Pawn HP;								  // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor1, TargetActor2;
	local class<Actor> TempActorClass1, TempActorClass2;
	local name TempActorTag1, TempActorTag2;
	
	if(ActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempActorClass1 = HP.Class;
		TempActorTag1 = HP.Tag;
	}
	else
	{
		TempActorClass1 = ActorClass;
		TempActorTag1 = ActorTag;
	}
	
	if(TargetActorTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempActorClass2 = HP.Class;
		TempActorTag2 = HP.Tag;
	}
	else
	{
		TempActorClass2 = TargetActorClass;
		TempActorTag2 = TargetActorTag;
	}
	
	if(TempActorClass1 == none || TempActorClass2 == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
		
		return false;
	}
	
	foreach C.DynamicActors(TempActorClass1, TargetActor1, TempActorTag1)
	{
		break;
	}
	
	foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
	{
		break;
	}
	
	if(TargetActor1 == none || TargetActor2 == none)
	{
		Warn(ActionString @ "-- Failed to find either the actor to teleport or the target to teleport to; aborting process");
		
		return false;
	}
	
	if(!FancySetLocation(TargetActor1, TargetActor2.Location, iTeleportAdjustRetryAttempts, bTeleportAdjustZOnly))
	{
		Warn(ActionString @ "-- Failed to teleport; aborting process");
		
		if(TeleportFailedSound != none)
		{
			TargetActor1.PlaySound(TeleportFailedSound, SLOT_None, fTeleportSoundVolume, true, 8192.0, 1.0, true);
		}
		
		return false;
	}
	
	if(bRotateToPoint)
	{
		TargetActor1.SetRotation(TargetActor2.Rotation);
		KWGame(C.Level.Game).GetHeroController().Camera.SetRot(TargetActor2.Rotation);
	}
	
	if(TeleportSound != none)
	{
		TargetActor1.PlaySound(TeleportSound, SLOT_None, fTeleportSoundVolume, true, 8192.0, 1.0, true);
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function bool FancySetLocation(Actor TargetActor, Vector NewLocation, int iSetLocationAttempts, optional bool bZOnly) // Sets the location of an actor. If the actor cannot move to the location, we iterate in all 6 possible directions to see if said adjustment allows it to successfully teleport
{
	local float R;
	local vector V, TV;
	
	V = NewLocation;
	
	if(iSetLocationAttempts < 1)
	{
		iSetLocationAttempts = 1;
	}
	
	if(TargetActor.SetLocation(V))
	{
		return true;
	}
	
	for(R = 2.5; R <= (float(iSetLocationAttempts) * 2.5); R += 2.5)
	{
		TV = V;
		TV.Z += R; // This is the only way to add to a single vector axis because UE2 is weird
		if(TargetActor.SetLocation(TV))
		{
			return true;
		}
		
		TV = V;
		TV.Z -= R;
		if(TargetActor.SetLocation(TV))
		{
			return true;
		}
		
		if(!bZOnly)
		{
			TV = V;
			TV.X += R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.X -= R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.Y += R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.Y -= R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
		}
	}
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Teleporting actor to point:" @ string(TargetActorTag);
}


defaultproperties
{
	ActorClass=class'Actor'
	TargetActorClass=class'Actor'
	bRotateToPoint=true
	TeleportSound=Sound'soundeffects.transform_poof'
	TeleportFailedSound=Sound'UI.PotionUI_cancel'
	fTeleportSoundVolume=0.4
	iTeleportAdjustRetryAttempts=28
	ActionString="Teleport"
}