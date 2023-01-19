// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Executes a player console command (A player console command is meant to refer to a player 
// executing a console command and not just running the function ConsoleCommand(), which is
// limited to have almost no useful console commands)
//
// Supports executing a random console command, getting a console command from a TransferProp,
// replacing phrases through TransferProp and picking a random replace phrase
// 
// Keywords:
// PullTransferProp[i].<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_PlayerConsoleCommand extends ScriptedAction
	Config(MGame);


struct TransferPropStruct // If using TransferProp
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct ReplaceStruct // If bReplacePhraseWithTransferProp is true
{
	var() string ReplacePhrase; 			// What phrase to look for and to replace
	var() bool bDontTransferProp;			// Whether you want to use TransferProp or not. The reason this is an option and not on Debug is because there's randomization used here
	var() string ReplaceComment;			// The comment to use for the replace if not using TransferProp
	var() TransferPropStruct TransferProp;	// The Get's required for a TransferProp to work
	var() int Index;						// What array index to replace the phrase with
};

var(Action) array<string> ConsoleCommands; 				// Which console commands should be fired to
var(Action) bool bPickRandom;				 			// Whether to pick a random console command
var(Action) bool bPullCommandFromTransferProp;			// Whether to pull the command from a TransferProp
var(Action) array<TransferPropStruct> PullTransferProp; // What console command to pull from a TransferProp
var(Action) bool bReplacePhraseWithTransferProp; 		// Whether the replacement phrase below should be replaced with the value pulled from TransferProp
var(Action) array<ReplaceStruct> ReplacePhraseActions;	// What actions should be done in terms of replacing phrases with TransferProps
var(Action) bool bPickRandomReplacePhrase;			   	// Whether to pick a random replace phrase
var Pawn HP;											// A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local Actor TargetActor;
	local int i;
	local array<string> LocalConsoleCommands;
	local class<Actor> TempActorClass;
	local name TempActorTag;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	LocalConsoleCommands = ConsoleCommands;
	
	if(bPullCommandFromTransferProp) // Do we need to pull console commands from a TransferProp
	{
		for(i = 0; i < PullTransferProp.Length; i++)
		{
			if(PullTransferProp[i].GetActorTag == 'CurrentPlayer')
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
				TempActorClass = PullTransferProp[i].GetActorClass;
				TempActorTag = PullTransferProp[i].GetActorTag;
			}
			
			if(TempActorClass == none)
			{
				Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
				
				continue;
			}
			
			foreach C.AllActors(TempActorClass, TargetActor, TempActorTag)
			{
				LocalConsoleCommands[i] = TargetActor.GetPropertyText(PullTransferProp[i].GetVariable);
			}
		}
	}
	
	if(bReplacePhraseWithTransferProp) // Do we need to replace phrases before executing the console commands
	{
		if(!bPickRandomReplacePhrase) // Not picking random replace phrase
		{
			for(i = 0; i < ReplacePhraseActions.Length; i++)
			{
				LocalConsoleCommands = PreReplaceText(C, LocalConsoleCommands, i);
			}
		}
		else // Picking random replace phrase
		{
			i = Rand(ReplacePhraseActions.Length);
			
			LocalConsoleCommands = PreReplaceText(C, LocalConsoleCommands, i);
		}
	}
	
	if(!bPickRandom) // Not picking random console commands (executing all)
	{
		for(i = 0; i < LocalConsoleCommands.Length; i++) 
		{
			PC.ConsoleCommand(LocalConsoleCommands[i]);
		}
	}
	else // Picking random console command (executing single)
	{
		PC.ConsoleCommand(LocalConsoleCommands[Rand(LocalConsoleCommands.Length)]);
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function ReplaceText(out string Text, string Replace, string With) // Replaces text
{
	local int i;
	local string Input;
	
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	
	while(i != -1)
	{
		Text = (Text $ Left(Input, i)) $ With;
		Input = Mid(Input, i + Len(Replace));
		i = InStr(Input, Replace);
	}
	
	Text = Text $ Input;
}

function array<string> PreReplaceText(ScriptedController C, array<string> LocalConsoleCommands, int Index) // Before replacing text
{
	local Actor TargetActor;
	
	if(!ReplacePhraseActions[Index].bDontTransferProp) // Going to TransferProp
	{
		if(ReplacePhraseActions[Index].TransferProp.GetActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; defaulting to class'Engine.Actor'");
			
			ReplacePhraseActions[Index].TransferProp.GetActorClass = class'Engine.Actor';
		}
		
		foreach C.AllActors(ReplacePhraseActions[Index].TransferProp.GetActorClass, TargetActor, ReplacePhraseActions[Index].TransferProp.GetActorTag)
		{
			ReplaceText(LocalConsoleCommands[ReplacePhraseActions[Index].Index], ReplacePhraseActions[Index].ReplacePhrase, TargetActor.GetPropertyText(ReplacePhraseActions[Index].TransferProp.GetVariable));
		}
	}
	else // Not going to TransferProp
	{
		ReplaceText(LocalConsoleCommands[ReplacePhraseActions[Index].Index], ReplacePhraseActions[Index].ReplacePhrase, ReplacePhraseActions[Index].ReplaceComment);
	}
	
	return LocalConsoleCommands;
}

function string GetActionString()
{
	if(!bPickRandom)
	{
		return ActionString @ "-- Executing" @ string(ConsoleCommands.Length) @ "player console commands";
	}
	else
	{
		return ActionString @ "-- Executing a random player console command";
	}
}


defaultproperties
{
	ActionString="Player Console Command"
}