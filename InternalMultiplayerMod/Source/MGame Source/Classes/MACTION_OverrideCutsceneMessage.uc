// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Overrides the current cutscene message on-screen (or makes its own)
// Can change the text for the top or bottom text and the text color
// If no cutscene message is currently on-screen, you can choose to add it


class MACTION_OverrideCutsceneMessage extends ScriptedAction
	Config(MGame);


enum EDisplayType
{
	DT_ApplyChanges,   // Apply the changes to the cutscene message
	DT_UndoChanges,    // Turns off the cutscene bars and undoes the text and color overrides
	DT_ChangeTextColor // Changes the text color for the cutscene message only
};

var(Action) MACTION_OverrideCutsceneMessage.EDisplayType DisplayType; // Which type of cutscene message display do we want to use
var(Action) string BottomText; 										  // The bottom text that will be displayed
var(Action) string TopText; 										  // The top text that will be displayed
var(Action) Color TextColor; 										  // The text color to use
var(Action) bool bRandomizeColor;									  // If true, randomizes the color
var(Action) bool bSlideBarsIn; 										  // Whether the cutscene bars should be forced on


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local Color TempColor;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	switch(DisplayType)
	{
		case DT_ApplyChanges:
			if(bSlideBarsIn)
			{
				KWHud(PC.myHUD).ShowCutBorders(bSlideBarsIn);
			}
			
			if(BottomText != "")
			{
				C.ConsoleCommand("Set KWCutTextController strText" @ BottomText);
			}
			
			if(TopText != "")
			{
				C.ConsoleCommand("Set KWCutTextController strCutCommentText" @ TopText);
			}
			
			C.ConsoleCommand("Set KWCutTextController colorCutText (R=" $ string(TextColor.R) $ ",G=" $ string(TextColor.G) $ ",B=" $ string(TextColor.B) $ ",A=" $ string(TextColor.A));
			
			break;
		case DT_UndoChanges:
			KWHud(PC.myHUD).EndCutScene();
			C.ConsoleCommand("Set KWCutTextController strText");
			C.ConsoleCommand("Set KWCutTextController strCutCommentText");
			C.ConsoleCommand("Set KWCutTextController colorCutText (R=127,G=127,B=255,A=255)");
			
			break;
		case DT_ChangeTextColor:
			if(bRandomizeColor)
			{
				TempColor.R = Rand(256);
				TempColor.G = Rand(256);
				TempColor.B = Rand(256);
				TempColor.A = TextColor.A;
			}
			else
			{
				TempColor.R = TextColor.R;
				TempColor.G = TextColor.G;
				TempColor.B = TextColor.B;
				TempColor.A = TextColor.A;
			}
			
			C.ConsoleCommand("Set KWCutTextController colorCutText (R=" $ string(TempColor.R) $ ",G=" $ string(TempColor.G) $ ",B=" $ string(TempColor.B) $ ",A=" $ string(TempColor.A));
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed DisplayType; aborting process");
			
			break;
	}
	
	return false;
}

function string GetActionString()
{
	switch(DisplayType)
	{
		case DT_ApplyChanges:
			return ActionString @ "-- Applying changes";
			
			break;
		case DT_UndoChanges:
			return ActionString @ "-- Undoing changes";
			
			break;
		case DT_ChangeTextColor:
			return ActionString @ "-- Changing text color only";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed DisplayType; aborting process");
			
			return ActionString @ "-- DisplayType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	TextColor=(R=127,G=127,B=255,A=255)
	bSlideBarsIn=true
	ActionString="Override Cutscene Message"
}