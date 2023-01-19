// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Sets the GameState the game is currently in
// This action is arbitrarily restricted to only work for the 6 GameStates shown in KnowWonder debug menu
// You can optionally run a TransferProp to figure out what the GameState is, but the player's controller MUST BE a MasterController


class MACTION_SetGameState extends ScriptedAction
	Config(MGame);


struct TransferPropStruct // If using TransferProp
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string SetVariable; 		  // What variable to set
};

var(Action) string NewGameState;				// What the new GSTATE should be
var(Action) bool bTransferPropGameStateInstead;	// Whether to TransferProp the GSTATE instead
var(Action) TransferPropStruct TransferProp;	// The Gets required for a TransferProp to work


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor;
	
	if(!bTransferPropGameStateInstead) // Set Game State
	{
		KWGame(C.Level.Game).SetGameState(NewGameState);
	}
	else // Executing TransferProp
	{
		if(TransferProp.GetActorClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
			
			return false;
		}
		
		foreach C.AllActors(TransferProp.GetActorClass, TargetActor, TransferProp.GetActorTag)
		{
			TargetActor.SetPropertyText(TransferProp.SetVariable, KWGame(C.Level.Game).CurrentGameState);
		}
	}
	
	return false;
}

function string GetActionString()
{
	if(!bTransferPropGameStateInstead)
	{
		return ActionString @ "-- Setting new GSTATE to:" @ NewGameState;
	}
	else
	{
		return ActionString @ "-- Getting the current GSTATE and TransferPropping it onto the actor with the tag:" @ string(TransferProp.GetActorTag);
	}
}


defaultproperties
{
	ActionString="Set Game State"
}