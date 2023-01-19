// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Gets a string from the computer's clipboard, then transfers that data onto an actor
// 
// Keywords:
// TransferClipboardActions[i].<ActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_TransferClipboard extends ScriptedAction
	Config(MGame);


struct TransferClipboardStruct
{
	var() class<Actor> ActorClass; // What actor's class to set to
	var() name ActorTag;		   // What actor's tag to set to
	var() string Variable;		   // What actor's variable to set to
	var() bool bControllerContext; // Should the TransferClipboard use the actor's variables or the controller's variables (controller variables are only available on pawns that have controllers)
};

var(Action) array<TransferClipboardStruct> TransferClipboardActions; // The list of actions that should be gone through
var(Action) bool bPickRandom;										 // If true, picks a random action to execute
var Pawn HP;														 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local Actor TargetActor;
	local int i;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	for(i = 0; i < TransferClipboardActions.Length; i++) // Executes a TransferClipboard action and continues going through the list until the list is finished
	{
		if(bPickRandom)
		{
			i = Rand(TransferClipboardActions.Length);
		}
		
		if(TransferClipboardActions[i].ActorTag == 'CurrentPlayer')
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
			TempActorClass = TransferClipboardActions[i].ActorClass;
			TempActorTag = TransferClipboardActions[i].ActorTag;
		}
		
		if(TempActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
			
			continue;
		}
		
		foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
		{
			if(!TransferClipboardActions[i].bControllerContext)
			{
				TargetActor.SetPropertyText(TransferClipboardActions[i].Variable, PC.PasteFromClipboard());
			}
			else
			{
				Pawn(TargetActor).Controller.SetPropertyText(TransferClipboardActions[i].Variable, PC.PasteFromClipboard());
			}
		}
		
		if(bPickRandom)
		{
			break;
		}
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	if(!bPickRandom)
	{
		return ActionString @ "-- Executing" @ string(TransferClipboardActions.Length) @ "actions";
	}
	else
	{
		return ActionString @ "-- Executing a random action";
	}
}


defaultproperties
{
	ActionString="Transfer Clipboard"
}