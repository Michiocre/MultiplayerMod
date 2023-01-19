// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Goes to a specified menu, or closes a menu
// The menu name should be formatted as such: Class.Actor (Example: KWGame.KWPageFrontEnd)


class MACTION_GotoMenu extends ScriptedAction
	Config(MGame);


enum EActionType
{
	AT_OpenMenu, 	 // Opens a menu
	AT_CloseMenu, 	 // Closes the current menu (which is presumably the most recent menu opened)
	AT_CloseAllMenus // Closes all menus
};

struct OpenMenuStruct // If opening a menu
{
	var() string MenuName; 	// What menu will be selected to open. Example: KWGame.KWPageFrontEnd
	var() bool bDisconnect; // Whether or not opening the menu should exit all maps. Should never be used, but it's an option
	var() string Msg1; 		// ???
	var() string Msg2; 		// ???
};

var(Action) MACTION_GotoMenu.EActionType ActionType; // What action should be used
var(Action)	OpenMenuStruct OpenMenuVars; 			 // All the variables that can be configured for the OpenMenu action


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	switch(ActionType)
	{
		case AT_OpenMenu:
			PC.ClientOpenMenu(OpenMenuVars.MenuName, OpenMenuVars.bDisconnect, OpenMenuVars.Msg1, OpenMenuVars.Msg2); // Opens the menu
			
			break;
		case AT_CloseMenu:
			PC.ClientCloseMenu(false); // Closes the menu
			
			break;
		case AT_CloseAllMenus:
			PC.ClientCloseMenu(true); // Close all menus
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			break;
	}
	
	return false;
}

function string GetActionString()
{
	switch(ActionType)
	{
		case AT_OpenMenu:
			return ActionString @ "-- Opening menu" @ OpenMenuVars.MenuName;
			
			break;
		case AT_CloseMenu:
			return ActionString @ "-- Closing menu";
			
			break;
		case AT_CloseAllMenus:
			return ActionString @ "-- Closing all menus";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			return ActionString @ "-- ActionType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	ActionString="Goto Menu"
}