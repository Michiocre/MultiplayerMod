// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// This actor is obsolete! Use MACTION_PlaySound or the console command PlayADialog instead
// 
// Plays a voiceline from MVoice.uax and displays a subtitle from MDialog.int
// MDialog.int must be formatted in the same way HpDialog.int is, but without the [_Calm] tags in the strings


class MCustomPopupTrigger extends MTriggers
	Placeable
	Config(MGame);


var() string dialogId; 		 // What voice line to play from MVoice.uax (in ..\Sounds\)
var() bool bPlayDialogSound; // Whether the sound should be played
var() float fVolume; 		 // The volume at which this voice line should be played at
var() bool bNoSubtitle; 	 // Whether or not the subtitle (that's pulled from ..\System\MDialog.int\) should be displayed on the bottom (provided the cutscene bars are on screen currently)
var() bool bEnabled; 		 // Is this trigger enabled


function Activate(Actor Other, Pawn Instigator)
{
	if(bEnabled)
	{
		DeliverLocalizedDialog(dialogId, bPlayDialogSound, fVolume, bNoSubtitle); // Plays the voice line with the specified settings
		
		Log("MCustomPopupTrigger -- Playing voice line" @ dialogId);
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Activate(Other, Instigator);
}

function DeliverLocalizedDialog(string DlgID, bool bPlaySound, optional float fVolume, optional bool bNoSubtitle, optional float fDisplayDuration, optional string IntFileName, optional string ExplicitString, optional bool bUseSlotIn, optional ESoundSlot SlotIn)
{
	// It's worth mentioning that this entire function is simply ported from Shrek 2's code, with a few adjustments
	
	local Sound DialogSound;
	local string dlgString;
	local float sndLen;
	local ESoundSlot slot;
	
	if(fVolume == 0)
	{
		fVolume = 1.4;
	}
	
	if(ExplicitString == "")
	{
		if(IntFileName == "")
		{
			dlgString = Localize("all", DlgID, "MDialog");
		}
		else
		{
			dlgString = Localize("all", DlgID, IntFileName);
		}
		
		if(bPlaySound)
		{
			DialogSound = Sound(DynamicLoadObject("MVoice." $ DlgID, class'Sound'));
		}
	}
	else
	{
		dlgString = ExplicitString;
	}
	
	if(DialogSound != none)
	{
		slot = SlotIn;
		sndLen = GetSoundDuration(DialogSound);
		PlaySound(DialogSound, slot, fVolume,, 100000,, false);
	}
	else
	{
		sndLen = FMax(Len(dlgString) * 3 / 20, 3);
	}
	
	if(fDisplayDuration > 0)
	{
		sndLen = fDisplayDuration;
	}
	
	Log("Saying bump line: " $ dlgString);
	
	if(!bNoSubtitle)
	{
		KWHud(KWGame(Level.Game).GetHeroController().myHUD).SetSubtitleText(dlgString, sndLen);
	}
}


defaultproperties
{
	bEnabled=true
	bPlayDialogSound=true
	fVolume=1.4
}