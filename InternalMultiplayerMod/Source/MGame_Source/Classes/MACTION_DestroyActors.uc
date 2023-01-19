// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Locates the specified actors, then destroys them permanently
// Has an option to only execute a single DestroyAction, meaning only destroying 1 random actor


class MACTION_DestroyActors extends ScriptedAction
	Config(MGame);


struct DestroyStruct
{
	var() class<Actor> ActorClass; // What actor's class to search for
	var() name DestroyTag; 		   // Which actor's tag to search for (for destroying)
};

var(Action) array<DestroyStruct> DestroyActions; // What actors to destroy
var(Action) bool bPickRandom; 					 // Whether to pick a random actor to destroy
var(Action) bool bOnlyDestroyFirst;				 // Whether to only destroy the first found actor instead of all found actors


function bool InitActionFor(ScriptedController C)
{
	local int i;
	
	if(!bPickRandom) // Not random
	{
		for(i = 0; i < DestroyActions.Length; i++)
		{
			DestroyActor(C, DestroyActions[i].ActorClass, DestroyActions[i].DestroyTag);
		}
	}
	else // Random
	{
		i = Rand(DestroyActions.Length);
		DestroyActor(C, DestroyActions[i].ActorClass, DestroyActions[i].DestroyTag);
	}
	
	return false;
}

function DestroyActor(ScriptedController C, class<Actor> ActorClass, name DestroyTag) // Destroys the specified actor
{
	local Actor TargetActor;
	
	if(ActorClass == none)
	{
		Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
		
		return;
	}
	
	foreach C.AllActors(ActorClass, TargetActor, DestroyTag)
	{
		TargetActor.Destroy();
		
		if(bOnlyDestroyFirst)
		{
			break;
		}
	}
}

function string GetActionString()
{
	if(!bPickRandom) // Not random
	{
		return ActionString @ "-- Destroying" @ string(DestroyActions.Length) @ "actors";
	}
	else // Random
	{
		return ActionString @ "-- Destroying a random actor";
	}
}


defaultproperties
{
	ActionString="Destroy Actors"
}