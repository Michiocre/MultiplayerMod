// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Plays an un-localized sound (meaning a sound with no distance; a "2D sound"), or a localized sound (a 3D sound)
// For the PlayLocalSound part of this action, this one can have the volume customized and can have the mouth movement of the main player toggled
// For the PlaySound part of this action, this one allows you to assign any actor to the sound instead of only pawns that can be linked up
// 
// Keywords:
// Actors.<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_PlaySound extends ScriptedAction
	Config(MGame);


struct GetPropStruct
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
};

struct LocalizeSoundVarsStruct
{
	var() float fRadius; // How far should you be able to hear the sound
	var() float fPitch;	 // What pitch should the sound play at
};

var(Action) array<Sound> Sounds;					   // What sound(s) to play
var(Action) array<GetPropStruct> Actors;			   // Which actors should be saying the sound specified
var(Action) bool bControlVolume;					   // Whether a volume override should be used
var(Action) float fVolume;							   // What new volume to use
var(Action) LocalizeSoundVarsStruct LocalizeSoundVars; // The sound settings to use if using bPlaySound3D
var(Action) bool bPickRandom;						   // Whether to pick a random sound to play
var(Action) bool bPlaySound3D;						   // Whether to localize the sound
var(Action) bool bMoveMouth;						   // Whether to move the players's mouth in accordance with the dialog playing. If this dialog is modded, the mouth won't move regardless
var int iSoundIndex;								   // What sound is going to be played (used for syncing actors with sounds)
var Pawn HP;										   // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	iSoundIndex = 0;
	
	if(bPickRandom) // If playing random sound
	{
		iSoundIndex = Rand(Sounds.Length);
	}
	
	PlaySound(C, iSoundIndex, bControlVolume, fVolume, bPlaySound3D);
	
	return false;
}

function PlaySound(ScriptedController C, int Index, bool bControl, float fVol, bool bPlaySound3D) // Plays a 2D or a 3D sound with a configurable volume
{
	local KWHeroController PC;
	local Actor TargetActor;
	local string MB;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	local int i;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	GetHeroPawn(C);
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return;
	}
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		return;
	}
	
	if(!bPlaySound3D) // 2D sound
	{
		if(!bMoveMouth)
		{
			MB = HP.GetPropertyText("MouthBone"); // Saves the mouth bone name
			HP.SetPropertyText("MouthBone", "");  // Disables the mouth bone so that the sound played in the next line of code doesn't move the player's mouth
		}
		
		PC.ClientPlaySound(Sounds[Index], bControl, fVol); // Plays the sound
		
		if(!bMoveMouth)
		{
			HP.SetPropertyText("MouthBone", MB); // Loads the previously saved mouth bone so that the player's mouth moves
		}
	}
	else // 3D sound
	{
		for(i = 0; i < Actors.Length; i++)
		{
			if(Actors[i].GetActorTag == 'CurrentPlayer')
			{
				TempActorClass = HP.Class;
				TempActorTag = HP.Tag;
			}
			else
			{
				TempActorClass = Actors[i].GetActorClass;
				TempActorTag = Actors[i].GetActorTag;
			}
		}
		
		if(TempActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
			
			return;
		}
		
		foreach C.DynamicActors(TempActorClass, TargetActor, TempActorTag)
		{
			if(!bMoveMouth && (TargetActor.IsA('Pawn') || TargetActor.ClassIsChildOf(TargetActor.Class, class'Pawn')))
			{
				MB = Pawn(TargetActor).GetPropertyText("MouthBone"); // Saves the mouth bone name
				Pawn(TargetActor).SetPropertyText("MouthBone", "");  // Disables the mouth bone so that the sound played in the next line of code doesn't move the actor's mouth
			}
			
			TargetActor.PlaySound(Sounds[Index], SLOT_Talk, fVolume, true, LocalizeSoundVars.fRadius, LocalizeSoundVars.fPitch, true); // Plays the sound + moves actor's mouth + localizes the sound to come from the actor
			
			if(!bMoveMouth && (TargetActor.IsA('Pawn') || TargetActor.ClassIsChildOf(TargetActor.Class, class'Pawn')))
			{
				Pawn(TargetActor).SetPropertyText("MouthBone", MB); // Loads the previously saved mouth bone so that the actor's mouth moves
			}
		}
	}
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	if(!bPickRandom)
	{
		return ActionString @ "-- Playing sound" @ string(Sounds[0]);
	}
	else
	{
		return ActionString @ "-- Playing a random sound";
	}
}


defaultproperties
{
	bControlVolume=true
	fVolume=0.9
	LocalizeSoundVars=(fRadius=8192.0,fPitch=1.0)
	ActionString="Play Sound"
}