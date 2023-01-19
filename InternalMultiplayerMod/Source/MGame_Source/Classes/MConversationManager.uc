// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A manager actor that starts random conversations based on the configuration given
// The general formula for this actor is for a random amount of time to pass, then to start a random conversation
// A conversation is considered to be multiple dialogs fired one after another in succession
// This actor is essential for when you don't want to manually script this all out
// Bonus: this isn't a dialog-only deal! This supports ALL SOUNDS, meaning it's not just for dialogs


class MConversationManager extends MKeypoint
	Config(MGame);


struct CoversationStruct
{
	var() array<Sound> DialogsInOrder;		 // What sound files should be gone through in order
	var() array<string> SubtitlesInOrder;	 // What subtitles should be shown on screen in order
	var() array< class<Pawn> > PawnsInOrder; // Which pawns should be speaking when said dialog plays
	var() array<name> PawnTagsInOrder;		 // Which pawn tags should be speaking when said dialog plays
};

struct RandStruct
{
	var() float Min; // The minimum random value
	var() float Max; // The maximum random value
};

struct LocalizeSoundVarsStruct
{
	var() float fRadius; // How far should you be able to hear the sound
	var() float fPitch;	 // What pitch should the sound play at
};

var() array<CoversationStruct> Conversations;	 // The list of all possible conversations to go through
var() RandStruct ConversationDelay;				 // How long we should wait before attempting to start a conversation
var() RandStruct DialogDelay;					 // How long we should wait in between each dialog being said
var() float fVolume;							 // What volume do all voice lines play at
var() bool bAllowRepeats;						 // Whether repeating a conversation right after another is allowed. If there's only 1 conversation in the conversation list, this does nothing
var() LocalizeSoundVarsStruct LocalizeSoundVars; // The sound settings to use if using bPlaySound3D
var() bool bPlaySound3D;						 // Whether to localize the sound
var() bool bShowSubtitles;						 // Whether to show custom subtitles
var() bool bEnabled;							 // Whether this actor is currently enabled. Manually changing this to false at any point halts all conversations and awaits for this variable to be changed back to true
var array<float> DialogLengths;					 // How long in seconds is each dialog in the conversation we're about to play
var int iConversationToExecute;					 // What conversation to execute
var int iOldConversation;						 // What was the last conversation we played (used for preventing repeats)
var int iCurrentDialog;							 // What dialog are we currently playing
var Pawn HP;									 // A temporary hero pawn reference

// This is here so that the states below can have "local variables" (a state cannot have local variables by default)
var int i;   // Temp integer
var float f; // Temp float


event PostBeginPlay()
{
	local MConversationManager CM;
	local int i;
	
	super.PostBeginPlay();
	
	foreach DynamicActors(class'MConversationManager', CM) // Prevents multiple conversation managers from being on from the start
	{
		if(CM.bEnabled == true)
		{
			i++;
			
			if(i > 1)
			{
				Warn("MConversationManager -- More than one MConversationManager are enabled at the same time; this shouldn't be expected. Turning all but one off");
				
				CM.bEnabled = false;
			}
		}
	}
	
	if(bEnabled)
	{
		Log("MGAME" @ class'MVersion'.default.Version @ "-- This level is running Master's Conversation Manager, made by Master_64");
	}
}

function GetHeroPawn() // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", Level.GetPropertyText("PlayerHeroActor"));
}

function float GetRandomDelay() // Returns with a random delay
{
	return RandRange(ConversationDelay.Min, ConversationDelay.Max);
}

function SetConversationLengths(int Index) // Gets the delay of each dialog. Needed for allowing a bEnabled change mid-conversation to stop the entire conversation
{
	local array<float> f;
	local int i;
	
	for(i = 0; i < Conversations[Index].DialogsInOrder.Length; i++)
	{
		f[i] = GetSoundDuration(Conversations[Index].DialogsInOrder[i]);
	}
	
	DialogLengths = f;
}

function PlayConversationSound(int Index, int Index2, bool bControl, float fVol) // Plays a 2D or 3D sound
{
	local PlayerController PC;
	local Pawn TargetPawn;
	local string MB;
	
	PC = KWGame(Level.Game).GetHeroController();
	
	if(!bPlaySound3D)
	{
		GetHeroPawn();
		
		if(HP == none)
		{
			Warn("MConversationManager -- Hero pawn could not be found; aborting process");
			
			return;
		}
		
		MB = HP.GetPropertyText("MouthBone"); // Saves the mouth bone name
		HP.SetPropertyText("MouthBone", "");  // Disables the mouth bone so that the sound played in the next line of code doesn't move the player's mouth
		
		PC.ClientPlaySound(Conversations[Index].DialogsInOrder[Index2], bControl, fVol); // Plays the sound
		
		HP.SetPropertyText("MouthBone", MB); // Loads the previously saved mouth bone so that the player's mouth moves
	}
	else
	{
		if(Conversations[Index].PawnsInOrder[Index2] == none)
		{
			Warn("MConversationManager -- An actor class assignment is missing; aborting process");
			
			return;
		}
		
		foreach DynamicActors(Conversations[Index].PawnsInOrder[Index2], TargetPawn, Conversations[Index].PawnTagsInOrder[Index2])
		{
			TargetPawn.PlaySound(Conversations[Index].DialogsInOrder[Index2], SLOT_Talk, fVol, true, LocalizeSoundVars.fRadius, LocalizeSoundVars.fPitch, true); // Plays the sound + moves actor's mouth + localizes the sound to come from the actor
		}
	}
	
	if(bShowSubtitles)
	{
		KWHud(PC.myHUD).SetSubtitleText(Conversations[Index].SubtitlesInOrder[Index2], DialogLengths[Index2]);
	}
}

auto state Idle // Waits and constantly checks whether bEnabled and bEnabledOverride are true or not. If it is true, change to state 'WaitBeforeSpeakTimer'
{
	function Timer()
	{
		if(bEnabled)
		{
			SetTimer(0.0, false);
			
			GotoState('WaitBeforeSpeakTimer');
		}
	}
	
Begin:
	
	SetTimer(0.1, true);
	
	stop;
}

state WaitBeforeSpeakTimer // Starts a big random delay, then checks if bEnabled and bEnabledOverride are still true. If it's still true, calculate which conversation to play, then go to state 'StartConversation'
{
	function Timer()
	{
		if(!bEnabled)
		{
			SetTimer(0.0, false);
			
			GotoState('Idle');
		}
		
		iConversationToExecute = Rand(Conversations.Length);
		
		if(!bAllowRepeats) // If not true, not allowing repeats
		{
			if(iOldConversation == iConversationToExecute && Conversations.Length != 1)
			{
				if(Conversations.Length == iConversationToExecute)
				{
					iConversationToExecute -= 1;
				}
				else
				{
					iConversationToExecute++;
				}
			}
		}
		
		iOldConversation = iConversationToExecute; // Saves the conversation last played
		
		GotoState('StartConversation');
	}
	
Begin:
	f = GetRandomDelay();
	
	SetTimer(f, true);
	
	stop;
}

state StartConversation // Plays out a conversation. If at any point bEnabled or bEnabledOverride is changed to false mid-way through, the conversation will be stopped
{
	function Timer()
	{
		if(!bEnabled) // If this is false, this means we need to end the conversation immediately
		{
			ConsoleCommand("StopSounds");
			
			SetTimer(0.0, false);
			
			GotoState('Idle');
		}
	}
	
	function Conversate()
	{
		PlayConversationSound(iConversationToExecute, iCurrentDialog, true, fVolume);
	}
	
Begin:
	SetConversationLengths(iConversationToExecute);
	SetTimer(0.1, true);
	
	for(i = 0; i < Conversations[iConversationToExecute].DialogsInOrder.Length; i++)
	{
		iCurrentDialog = i;
		f = RandRange(DialogDelay.Min, DialogDelay.Max);
		Conversate();
		
		Sleep(DialogLengths[i] + f);
	}
	
	SetTimer(0.0, false);
	
	GotoState('Idle');
	
	stop;
}


defaultproperties
{
	bEnabled=true
	fVolume=1.4
	ConversationDelay=(Min=15.0,Max=30.0)
	DialogDelay=(Min=0.2,Max=0.2)
	LocalizeSoundVars=(fRadius=8192.0,fPitch=1.0)
	iOldConversation=-1 // This allows the first conversation to be any conversation while preventing repeats
	bStatic=false
}