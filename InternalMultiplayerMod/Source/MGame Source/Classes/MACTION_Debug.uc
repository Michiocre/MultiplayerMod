// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// An essential action for any developmental work
// Can DisplayMessage, Announce, Log, Warn or comment to simply do nothing other than to be a note to everyone viewing the script
// Supports replace phrases (done with TransferProp), which allows you to replace phrases with data from a TransferProp


class MACTION_Debug extends ScriptedAction
	Config(MGame);


struct TransferPropStruct
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct ReplaceStruct // If bReplacePhraseWithTransferProp is true
{
	var() string ReplacePhrase; 		   // What phrase to look for and to replace
	var() TransferPropStruct TransferProp; // The Get's required for a TransferProp to work
};

struct AnnounceStruct // What settings to use when announcing
{
	var() float fAnnTime; // The announcement time
	var() Color AnnColor; // The text color for the announcement
};

enum EDebugType // What debug type to use
{
	DT_DisplayMessage,			// Display Message -- Displays a message in the KW log
	DT_DisplayMessage_Announce,	// Display Message (Announce) -- Displays a message onscreen (settings can be configured)
	DT_Log,						// Log -- Logs to the log file
	DT_Warn,					// Warn -- Logs a warning to the log file
	DT_Comment					// Comment -- Does nothing and makes this action serve as a comment for your own and other's own reference as to what your script is doing
};

var(Action) MACTION_Debug.EDebugType DebugType;		   // The debug type to use
var(Action) string Comment;							   // The comment/message
var(Action) bool bReplacePhraseWithTransferProp; 	   // Whether the replacement phrase below should be replaced with the value pulled from TransferProp
var(Action) array<ReplaceStruct> ReplacePhraseActions; // What actions should be done in terms of replacing phrases with TransferProps
var(Action) AnnounceStruct AnnouncementSettings;	   // What settings should be used when announcing


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local Actor TargetActor;
	local int i;
	local string LocalComment;
	
	if(DebugType == DT_Comment)
	{
		return false;
	}
	
	PC = KWGame(C.Level.Game).GetHeroController();
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	LocalComment = Comment;
	
	if(DebugType != DT_Comment && bReplacePhraseWithTransferProp) // Are we replacing phrases
	{
		for(i = 0; i < ReplacePhraseActions.Length; i++)
		{
			if(ReplacePhraseActions[i].TransferProp.GetActorClass == none)
			{
				Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
				
				continue;
			}
			
			foreach C.AllActors(ReplacePhraseActions[i].TransferProp.GetActorClass, TargetActor, ReplacePhraseActions[i].TransferProp.GetActorTag)
			{
				ReplaceText(LocalComment, ReplacePhraseActions[i].ReplacePhrase, TargetActor.GetPropertyText(ReplacePhraseActions[i].TransferProp.GetVariable)); // Replaces the phrases
			}
		}
	}
	
	switch(DebugType)
	{
		case DT_DisplayMessage:
			PC.ClientMessage(LocalComment, 'CriticalEvent');
			
			break;
		case DT_DisplayMessage_Announce:
			PC.ClearProgressMessages();
			PC.SetProgressTime(AnnouncementSettings.fAnnTime);
			PC.SetProgressMessage(0, LocalComment, class'Canvas'.static.MakeColor(AnnouncementSettings.AnnColor.R, AnnouncementSettings.AnnColor.G, AnnouncementSettings.AnnColor.B));
			
			break;
		case DT_Log:
			Log(LocalComment);
			
			break;
		case DT_Warn:
			Warn(LocalComment);
			
			break;
		case DT_Comment:
			// No code is in this block as if the type is Comment, nothing should occur
			// The code should not be able to reach this point due to the return false;
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed DebugType; aborting process");
			
			break;
	}
	
	return false;
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

function string GetActionString()
{
	switch(DebugType)
	{
		case DT_DisplayMessage: // Display Message
			return ActionString @ "-- Displaying message";
			
			break;
		case DT_DisplayMessage_Announce: // Display Message (Announce)
			return ActionString @ "-- Announcing message";
			
			break;
		case DT_Log: // Log
			return ActionString @ "-- Logging";
			
			break;
		case DT_Warn: // Warn
			return ActionString @ "-- Warning";
			
			break;
		case DT_Comment: // Comment
			return ActionString @ "-- Commenting (nothing occurred)";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed DebugType; aborting process");
			
			return ActionString @ "-- DebugType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	AnnouncementSettings=(fAnnTime=6,AnnColor=(R=255,G=255,B=255,A=255))
	ActionString="Debug"
}