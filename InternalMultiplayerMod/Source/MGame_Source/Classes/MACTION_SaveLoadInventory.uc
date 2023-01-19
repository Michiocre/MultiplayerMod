// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Saves or loads an inventory from global data
// Simply save an inventory, then load it back any time
// The inventory is considered to be all of your current coins and
// potions, not your health (you can already save your health if needed)


class MACTION_SaveLoadInventory extends ScriptedAction
	Config(MGlobalData);


enum EActionType // What action type to use
{
	AT_SaveInventory,
	AT_LoadInventory
};

var(Action) MACTION_SaveLoadInventory.EActionType ActionType; // Whether to save or load an inventory
var(Action) int Slot;										  // Which save slot to use
var(Action) bool bGetCurrentGameSlot;						  // If true, gets the current game slot to save/load to
var name ActorTagName;										  // Blame UE2 for this


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local int i;
	local array<int> CurrInv;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	// Prevents major errors
	PC.ConsoleCommand("AddCoins 0");
	PC.ConsoleCommand("AddPotions 0");
	
	switch(ActionType)
	{
		case AT_SaveInventory:
			CurrInv[0] = int(GetProp(C, "CoinCollection", "iNumItems"));
			
			for(i = 1; i < 10; i++)
			{
				CurrInv[i] = int(GetProp(C, "Potion" $ string(i) $ "Collection", "iNumItems"));
			}
			
			class'MGlobalData'.static.SaveInvGlobalData(Slot, CurrInv, bGetCurrentGameSlot);
			
			break;
		case AT_LoadInventory:
			CurrInv = class'MGlobalData'.static.LoadInvGlobalData(Slot, bGetCurrentGameSlot);
			
			SetProp(C, "CoinCollection", "iNumItems", string(CurrInv[0]));
			
			for(i = 1; i < 10; i++)
			{
				SetProp(C, "Potion" $ string(i) $ "Collection", "iNumItems", string(CurrInv[i]));
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			break;
	}
	
	return false;
}

function SetProp(ScriptedController C, string ActorTag, string Variable, string Value) // A simple SetProp
{
	local KWInventoryCollection TargetActor;
	
	SetPropertyText("ActorTagName", ActorTag);
	
	foreach C.AllActors(class'KWInventoryCollection', TargetActor, ActorTagName)
	{
		TargetActor.SetPropertyText(Variable, Value);
	}
}

function string GetProp(ScriptedController C, string ActorTag, string Variable) // A simple GetProp
{
	local string Value;
	local KWInventoryCollection TargetActor;
	
	SetPropertyText("ActorTagName", ActorTag);
	
	foreach C.AllActors(class'KWInventoryCollection', TargetActor, ActorTagName)
	{
		Value = TargetActor.GetPropertyText(Variable);
	}
	
	return Value;
}

function string GetActionString()
{
	switch(ActionType)
	{
		case AT_SaveInventory:
			return ActionString @ "-- Saving inventory to save slot" @ string(Slot);
			
			break;
		case AT_LoadInventory:
			return ActionString @ "-- Loading inventory from save slot" @ string(Slot);
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			return ActionString @ "-- ActionType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	ActionString="Save/Load Inventory"
}