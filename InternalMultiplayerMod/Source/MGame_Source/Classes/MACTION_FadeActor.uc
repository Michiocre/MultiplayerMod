// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Fades an actor
// Can be given a fade time, fade type, a color and can be destroyed when done
// To reset the fade values of an actor, set the color to (A=255,R=128,G=128,B=128)
// 
// Keywords:
// FadeActorActions[i].<ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_FadeActor extends ScriptedAction
	Config(MGame);


struct FadeActorStruct
{
	var() class<Actor> ActorClass;				   // What actor class should be located
	var() name ActorTag;						   // What actor tag should be located
	var() Color ActorColor;						   // The color to fade to
	var() float fFadeTime;						   // How long should the fade take in seconds
	var() FadeActorDelegate.enumMoveType FadeType; // What fade type to use
	var() bool bDestroyOnFadeEnd;				   // If true, destroys the actor when the fade ends
	var() bool bRandomizeColor;					   // If true, randomizes the color
};

var(Action) array<FadeActorStruct> FadeActorActions; // The list of actions that should be gone through
var Pawn HP;										 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local FadeActorDelegate Fader;
	local Actor TargetActor;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	local Color TempColor;
	local int i;
	
	for(i = 0; i < FadeActorActions.Length; i++)
	{
		if(FadeActorActions[i].ActorTag == 'CurrentPlayer')
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
			TempActorClass = FadeActorActions[i].ActorClass;
			TempActorTag = FadeActorActions[i].ActorTag;
		}
		
		if(TempActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
			
			continue;
		}
		
		foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
		{
			break;
		}
		
		if(TargetActor == none)
		{
			Warn(ActionString @ "-- Failed to find an actor to fade; aborting process");
			
			continue;
		}
		
		if(FadeActorActions[i].bRandomizeColor)
		{
			TempColor.R = Rand(256);
			TempColor.G = Rand(256);
			TempColor.B = Rand(256);
			TempColor.A = FadeActorActions[i].ActorColor.A;
		}
		else
		{
			TempColor.R = FadeActorActions[i].ActorColor.R;
			TempColor.G = FadeActorActions[i].ActorColor.G;
			TempColor.B = FadeActorActions[i].ActorColor.B;
			TempColor.A = FadeActorActions[i].ActorColor.A;
		}
		
		Fader = C.Spawn(class'FadeActorDelegate');
		Fader.Init(TargetActor, TempColor.A, TempColor.R, TempColor.G, TempColor.B, FadeActorActions[i].fFadeTime, FadeActorActions[i].FadeType, FadeActorActions[i].bDestroyOnFadeEnd);
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	return ActionString @ "-- Fading" @ string(FadeActorActions.Length) @ "actors";
}


defaultproperties
{
	ActionString="Fade Actor"
}