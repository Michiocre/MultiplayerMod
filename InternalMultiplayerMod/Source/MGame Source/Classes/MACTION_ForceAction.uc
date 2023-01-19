// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Makes the specified pawn single jump, double jump, punch/use or skip a cutscene
// 
// 
// When forcing a single jump:
// - Follows game rules; won't execute otherwise
// 
// When forcing a double jump:
// - Does not follow game rules; will always execute
// - Can act as an air jump
// - Pawn must be a KWPawn for this to work
// 
// When forcing a punch:
// - Follows game rules; won't execute otherwise
// - Only works on the current player
// - Pawn must be a ShHeroPawn for this to work
// 
// When forcing a cutscene skip:
// - Follows game rules; won't execute otherwise
// - Doesn't require specifying a pawn as it's global
// 
// When forcing a movie skip:
// - Follows game rules; won't execute otherwise
// - Will pull up a potion menu just like it does in the original game if a movie isn't playing
// 
// When forcing a potion menu:
// - Follows game rules; won't execute otherwise
// 
// When forcing a pause menu:
// - Follows game rules; won't execute otherwise
// 
// 
// Keywords:
// <GetPawnTag> -- CurrentPlayer -- Targets the current player


class MACTION_ForceAction extends ScriptedAction
	Config(MGame);


enum EActionType
{
	AT_Single_Jump,
	AT_Double_Jump,
	AT_Punch,
	AT_Skip_Cutscene,
	AT_Skip_Movie,
	AT_Potion_Menu,
	AT_Pause_Menu
};

var(Action) MACTION_ForceAction.EActionType ActionType;	// Which action should be executed
var(Action) class<Pawn> GetPawnClass;					// What pawn's class to get (if needed)
var(Action) name GetPawnTag;							// What pawn's tag to get (if needed)
var Pawn HP;											// A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local Pawn TargetPawn;
	local class<Pawn> TempPawnClass;
	local name TempPawnTag;
	
	if(GetPawnTag == 'CurrentPlayer')
	{
		GetHeroPawn(C);
		
		if(HP == none)
		{
			Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
			
			return false;
		}
		
		TempPawnClass = HP.Class;
		TempPawnTag = HP.Tag;
	}
	else
	{
		TempPawnClass = GetPawnClass;
		TempPawnTag = GetPawnTag;
	}
	
	if(int(ActionType) <= 2)
	{
		if(TempPawnClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; aborting process");
			
			return false;
		}
		
		foreach C.AllActors(TempPawnClass, TargetPawn, TempPawnTag)
		{
			switch(ActionType)
			{
				case AT_Single_Jump:
					TargetPawn.DoJump(false);
					
					break;
				case AT_Double_Jump:
					if(TargetPawn.IsA('KWPawn'))
					{
						KWPawn(TargetPawn).DoDoubleJump(false);
					}
					
					break;
				case AT_Punch:
					TargetPawn.Fire();
					
					if(TargetPawn.IsA('ShHeroPawn'))
					{
						ShHeroPawn(TargetPawn).DoSomeAction();
					}
					
					break;
				default:
					break;
			}
		}
	}
	else
	{
		PC = KWGame(C.Level.Game).GetHeroController();
		
		switch(ActionType)
		{
			case AT_Skip_Cutscene:
				KWHud(PC.myHUD).BypassCutscene();
				
				break;
			case AT_Skip_Movie:
				PC.StopMoviePlayback();
				
				break;
			case AT_Potion_Menu:
				PC.ForceLoadPotionSelectMenu();
				
				break;
			case AT_Pause_Menu:
				PC.EscHandler();
				
				break;
			default:
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
	switch(ActionType)
	{
		case AT_Single_Jump:
			return ActionString @ "-- Executing single jump on target pawn";
			
			break;
		case AT_Double_Jump:
			return ActionString @ "-- Executing double jump on target pawn";
			
			break;
		case AT_Punch:
			return ActionString @ "-- Executing punch on target pawn";
			
			break;
		case AT_Skip_Cutscene:
			return ActionString @ "-- Executing a cutscene skip";
			
			break;
		case AT_Skip_Movie:
			return ActionString @ "-- Executing a movie skip";
			
			break;
		case AT_Potion_Menu:
			return ActionString @ "-- Executing potion menu popup";
			
			break;
		case AT_Pause_Menu:
			return ActionString @ "-- Executing pause menu popup";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed ActionType; aborting process");
			
			break;
	}
}


defaultproperties
{
	ActionString="Force Action"
	GetPawnClass=class'Pawn'
}