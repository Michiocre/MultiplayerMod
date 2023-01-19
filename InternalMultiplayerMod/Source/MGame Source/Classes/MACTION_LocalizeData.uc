// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Takes external data out of <FileName>.int and transfers that data to an actor (through TransferProp)
// If the filename contains "\\", you can read from a directory starting from ..\\system\\ (example: Cutscenes\\BeanStalkBonus_Intro will open the cutscene file BeanStalkBonus_Intro.int)
// This is essential for any sort of external resource management


class MACTION_LocalizeData extends ScriptedAction
	Config(MGame);


struct TransferPropStruct
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string SetVariable; 		  // What actor's variable to set to
};

struct LocalizeStruct
{
	var() string SectionName; // The name of the section
	var() string Key;		  // The key name
	var() string FileName;	  // The name of the file (do not add .int)
};

struct ActionStruct
{
	var() LocalizeStruct Localize;		   // The localized data to pull from
	var() TransferPropStruct TransferProp; // The TransferProp to execute for the data transfer
};

var(Action) array<ActionStruct> LocalizeActions; // The list of actions that should be gone through


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor;
	local int i;
	
	for(i = 0; i < LocalizeActions.Length; i++)
	{
		if(LocalizeActions[i].TransferProp.GetActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
			
			continue;
		}
		
		foreach C.AllActors(LocalizeActions[i].TransferProp.GetActorClass, TargetActor, LocalizeActions[i].TransferProp.GetActorTag)
		{
			TargetActor.SetPropertyText(LocalizeActions[i].TransferProp.SetVariable, Localize(LocalizeActions[i].Localize.SectionName, LocalizeActions[i].Localize.Key, LocalizeActions[i].Localize.FileName)); // Pulls from <FileName>, gets its data, then transfers that data to the actor specified
		}
	}
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Transferring" @ string(LocalizeActions.Length) @ "bits of localized data to various specified actors";
}


defaultproperties
{
	ActionString="Localize Data"
}