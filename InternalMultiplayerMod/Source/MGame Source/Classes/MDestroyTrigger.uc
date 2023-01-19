// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_DestroyActors instead
// 
// Finds the specified actors, then destroys them


class MDestroyTrigger extends MTriggers
	Placeable
	Config(MGame);


struct DestroyStruct
{
	var() class<Actor> ActorClass; // What actor's class to search for
	var() name DestroyTag; 		   // Which actor's tag to search for (for destroying)
};

var() array<DestroyStruct> DestroyActions; // What actors to destroy
var() bool bEnabled;					   // Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	local Actor TargetActor;
	local int i;
	
	if(bEnabled)
	{
		for(i = 0; i < DestroyActions.Length; i++) 
		{
			if(DestroyActions[i].ActorClass == none)
			{
				Warn("MDestroyTrigger -- An actor class assignment is missing; skipping action");
				
				continue;
			}
			
			foreach AllActors(DestroyActions[i].ActorClass, TargetActor, DestroyActions[i].DestroyTag) 
			{
				TargetActor.Destroy(); // Destroys the actor
				
				Log("MDestroyTrigger -- Destroyed actor" @ TargetActor.Name);
			}
		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Activate(Other, Instigator);
}


defaultproperties
{
	bEnabled=true
}