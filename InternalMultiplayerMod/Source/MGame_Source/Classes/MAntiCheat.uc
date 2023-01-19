// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// M.A.C. (Master's Anti-Cheat) is a simple place-and-forget anti-cheat for Shrek 2 (PC) that protects against various common cheats listed below
// When a cheat is suspected to currently be in use, M.A.C. will reverse the cheat and then an optional punishment can be ran
// M.A.C. is not meant to be intrusive; most cheat checks aren't overly enforced
// This likely shouldn't be used for maps that implement their own custom gamerules, as M.A.C. treats every map like an original KnowWonder map
// To stop M.A.C., you can do any of the 3:
// 1. If using a MasterController, simply run the console command "AntiAntiCheat" or "AAC" (doing this is permanent)
// 2. Use the ManageAntiCheat action to temporarily turn it off
// 3. Use the console command "KillAll MAntiCheat" (doing this is permanent)
// Do NOT include 2 or more of this actor in the same map
// 
// 
// Enforcement Features:
// 
// - No god mode
// - No ghosting (or flying)
// - No debug mode
// - No speed cheats
// - No jump cheats
// - No fall damage cheats
// - No acceleration rate cheats
// - No minimum floor angle cheats
// - No modified air control
// - No SloMo modification
// - No modified gravity
// - No screen fade cheats
// 
// 
// This does not protect against:
// 
// - Teleporting/Warping (reasoning here: cutscenes would cause issues, as well as saves and loads. Due to there being too many exceptions, this won't ever be implemented)
// - Any other minute or very visual cheats
// 
// 
// Important notice:
// 
// If your level features PIB and you play as PIB later in the level (meaning you didn't start as him), a cheat flag will go off for using jump cheats (v5).
// Now the reason behind this being cheat-flagged is actually pretty interesting; it's actually a bug in the stock game. When doing this normally, PIB's
// jump distance scalar will actually be incorrectly calculated by default, but this anti-cheat fixes this bug at the cost of saying a cheat was used.


class MAntiCheat extends MKeypoint
	Config(MGame);


enum EPunishType // What punish type to use
{
	PT_None,		   // No punishment is applied
	PT_ConsoleCommand, // Runs a console command each time the player cheats
	PT_SetProp,		   // Runs a SetProp each time the player cheats
	PT_Debug		   // Announces in-game which cheat was used
};

struct SetPropStruct // If using SetProp
{
	var() class<Actor> ActorClass; // What actor's class to get
	var() name ActorTag; 		   // What actor's tag to get
	var() string Variable; 		   // What actor's variable to get
	var() string Value; 		   // What actor's variable to set
};

struct AnnounceStruct // What settings to use when announcing
{
	var() float fAnnTime; // The announcement time
	var() Color AnnColor; // The text color for the announcement
};

var() bool bEnforceSteedsModifiedJumpHeight; // If true, enforces Steed's jump height to the default modified value it should be at
var() bool bEnforcePIBsFactoryFallDamage;	 // If true, enforces PIB's fall damage to the default modified value it would be at if it was in FGM PIB
var() MAntiCheat.EPunishType PunishType;	 // What punishment to use when the player cheats
var() array<string> ConsoleCommands;		 // Which console commands to all run if the punishment type is to run console commands. Note: these are player console commands
var() array<SetPropStruct> SetProps;		 // Which SetProps to run if the punishment type is to run SetProps
var() AnnounceStruct AnnouncementSettings;	 // Which announcement settings to use
var array<string> CheatMessages;			 // Which cheat(s) did the player use
var KWHeroController PCRef;					 // The Player Controller reference (the main player)
var Pawn PRef;								 // The Pawn reference (the main player)


event PostBeginPlay()
{
	local MAntiCheat AC;
	local int i;
	
	super.PostBeginPlay();
	
	foreach DynamicActors(class'MAntiCheat', AC) // A check to make sure no more than 2 MAntiCheats exist in the current level
	{
		i++;
		
		if(i > 1)
		{
			Warn("MAntiCheat -- Deleting a duplicate MAntiCheat");
			
			self.Destroy();
			
			return;
		}
	}
	
	Log("MGAME" @ class'MVersion'.default.Version @ "-- This level is running Master's Anti-Cheat (M.A.C.), made by Master_64");
}

function Tick(float DeltaTime)
{
	GetHeroPawn();
	EnforceNoCheats();
	
	if(CheatMessages.Length != 0)
	{
		ReactToCheats();
	}
}

function ReactToCheats() // Reacts to used cheats
{
	local Actor TargetActor;
	local string CheatMessage;
	local int i;
	
	switch(PunishType)
	{
		case PT_None:
			break;
		case PT_ConsoleCommand:
			for(i = 0; i < ConsoleCommands.Length; i++)
			{
				PCRef.ConsoleCommand(ConsoleCommands[i]);
			}
			
			break;
		case PT_SetProp:
			for(i = 0; i < SetProps.Length; i++)
			{
				foreach AllActors(SetProps[i].ActorClass, TargetActor, SetProps[i].ActorTag)
				{
					TargetActor.SetPropertyText(SetProps[i].Variable, SetProps[i].Value);
				}
			}
			
			break;
		case PT_Debug:
			for(i = 0; i < CheatMessages.Length; i++)
			{
				if(i == 0)
				{
					CheatMessage = CheatMessages[i];
				}
				else
				{
					CheatMessage = CheatMessage @ "+" @ CheatMessages[i];
				}
			}
			
			PCRef.ClearProgressMessages();
			PCRef.SetProgressTime(AnnouncementSettings.fAnnTime);
			PCRef.SetProgressMessage(0, CheatMessage, class'Canvas'.static.MakeColor(AnnouncementSettings.AnnColor.R, AnnouncementSettings.AnnColor.G, AnnouncementSettings.AnnColor.B));
			
			break;
		default:
			Warn("MAntiCheat -- Default case triggered due to malformed PunishType; exiting process");
			
			break;
	}
}

function KWHeroController GetHero() // Gets the hero controller
{
	return KWGame(Level.Game).GetHeroController();
}

function GetHeroPawn() // Gets/refreshes the hero pawn
{
	SetPropertyText("PRef", Level.GetPropertyText("PlayerHeroActor"));
}

function EnforceNoCheats() // Check if the player is cheating, and if cheating is detected, re-inforce the cheated variables back to their default values
{
	local float TempF;
	local array<string> DetectedCheatMessages;
	
	if((PCRef.bGodMode != PCRef.default.bGodMode)) // God mode check 1
	{
		PCRef.bGodMode = PCRef.default.bGodMode;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using god mode (v1) cheats";
	}
	
	if(PRef.IsA('SHHeroPawn')) // God mode check 2
	{
		if(SHHeroPawn(PRef).AmInvunerable != SHHeroPawn(PRef).default.AmInvunerable)
		{
			SHHeroPawn(PRef).AmInvunerable = SHHeroPawn(PRef).default.AmInvunerable;
			
			DetectedCheatMessages[DetectedCheatMessages.Length] = "Using god mode (v2) cheats";
		}
	}
	
	if(PCRef.IsInState('PlayerFlying')) // Ghost check
	{
		PCRef.ConsoleCommand("Walk");
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using ghost cheats";
	}
	
	if(bool(ConsoleCommand("Get KWGame.KWVersion bDebugEnabled")) || bool(ConsoleCommand("Get SHGame.Version bDebugEnabled"))) // Debug mode check
	{
		PCRef.ConsoleCommand("Set KWGame.KWVersion bDebugEnabled False");
		PCRef.ConsoleCommand("Set SHGame.Version bDebugEnabled False");
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using debug mode";
	}
	
	if(PRef.IsA('KWPawn')) // Speed check
	{
		if(KWPawn(PRef).GroundRunSpeed != KWPawn(PRef).default.GroundRunSpeed)
		{
			KWPawn(PRef).GroundRunSpeed = KWPawn(PRef).default.GroundRunSpeed;
			
			DetectedCheatMessages[DetectedCheatMessages.Length] = "Using speed cheats";
		}
	}
	
	TempF = GetDefaultJumpValue(false);
	
	if(PRef.JumpZ != TempF) // Jump check 1
	{
		PRef.JumpZ = TempF;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v1) cheats";
	}
	
	if(PRef.IsA('KWPawn')) // Jump check 2
	{
		if(bEnforceSteedsModifiedJumpHeight && PRef.IsA('Steed'))
		{
			if(KWPawn(PRef).DoubleJumpZ != 505.964417)
			{
				KWPawn(PRef).DoubleJumpZ = 505.964417;
				
				DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v2) cheats";
			}
		}
		else
		{
			TempF = GetDefaultJumpValue(true);
			
			if(KWPawn(PRef).DoubleJumpZ != TempF)
			{
				KWPawn(PRef).DoubleJumpZ = TempF;
				
				DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v2) cheats";
			}
		}
	}
	
	if(PRef.IsA('SHHeroPawn')) // Jump check 3
	{
		if(SHHeroPawn(PRef).AirAttackBoost != SHHeroPawn(PRef).default.AirAttackBoost)
		{
			SHHeroPawn(PRef).AirAttackBoost = SHHeroPawn(PRef).default.AirAttackBoost;
			
			DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v3) cheats";
		}
	}
	
	if(PRef.IsA('SHHeroPawn')) // Jump check 4
	{
		if(SHHeroPawn(PRef).AirAttackFall != SHHeroPawn(PRef).default.AirAttackFall)
		{
			SHHeroPawn(PRef).AirAttackFall = SHHeroPawn(PRef).default.AirAttackFall;
			
			DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v4) cheats";
		}
	}
	
	if(PRef.IsA('SHCharacter')) // Jump check 5
	{
		TempF = GetDefaultJumpDistScalarValue();
		
		if(KWPawn(PRef).fJumpDistScalar != TempF)
		{
			KWPawn(PRef).fJumpDistScalar = TempF;
			
			DetectedCheatMessages[DetectedCheatMessages.Length] = "Using jump (v5) cheats";
		}
	}
	
	if(PRef.IsA('SHHeroPawn')) // Fall damage check
	{
		if(bEnforcePIBsFactoryFallDamage && PRef.IsA('PIB'))
		{
			if(SHHeroPawn(PRef).DeathIfFallDistance != 1000.0)
			{
				SHHeroPawn(PRef).DeathIfFallDistance = 1000.0;
				
				DetectedCheatMessages[DetectedCheatMessages.Length] = "Using fall damage cheats";
			}
		}
		else
		{
			if(SHHeroPawn(PRef).DeathIfFallDistance != SHHeroPawn(PRef).default.DeathIfFallDistance)
			{
				SHHeroPawn(PRef).DeathIfFallDistance = SHHeroPawn(PRef).default.DeathIfFallDistance;
				
				DetectedCheatMessages[DetectedCheatMessages.Length] = "Using fall damage cheats";
			}
		}
	}
	
	if(PRef.AccelRate != PRef.default.AccelRate) // Acceleration rate check
	{
		PRef.AccelRate = PRef.default.AccelRate;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using acceleration rate cheats";
	}
	
	if(float(PRef.GetPropertyText("fMinFloorZ")) != 0.7) // Min floor angle check
	{
		PRef.SetPropertyText("fMinFloorZ", "0.7");
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using minimum floor angle cheats";
	}
	
	if(PRef.AirControl != PRef.default.AirControl) // Air control check
	{
		PRef.AirControl = PRef.default.AirControl;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using air control cheats";
	}
	
	if(Level.TimeDilation != Level.default.TimeDilation) // SloMo check
	{
		Level.TimeDilation = Level.default.TimeDilation;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using SloMo cheats";
	}
	
	if(PhysicsVolume.Gravity.Z != PhysicsVolume.default.Gravity.Z) // Gravity check
	{
		PhysicsVolume.Gravity.Z = PhysicsVolume.default.Gravity.Z;
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using gravity Z cheats";
	}
	
	if(!bool(ConsoleCommand("Get ini:Engine.Engine.ViewportManager ScreenFlashes"))) // Screen fade check
	{
		ConsoleCommand("Set ini:Engine.Engine.ViewportManager ScreenFlashes True");
		
		DetectedCheatMessages[DetectedCheatMessages.Length] = "Using screen fade cheats";
	}
	
	CheatMessages = DetectedCheatMessages;
	
	return;
}

function float GetDefaultJumpValue(bool bGetDoubleJumpZ)
{
	if(!bGetDoubleJumpZ)
	{
		if(PRef.IsA('Donkey'))
		{
			return Sqrt((-2.0 * Donkey(PRef).default.fJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
		else if(PRef.IsA('PIB'))
		{
			return Sqrt((-2.0 * PIB(PRef).default.fJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
		else
		{
			return Sqrt((-2.0 * KWPawn(PRef).default.fJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
	}
	else
	{
		if(PRef.IsA('Donkey'))
		{
			return Sqrt((-2.0 * Donkey(PRef).default.fDoubleJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
		else if(PRef.IsA('PIB'))
		{
			return Sqrt((-2.0 * PIB(PRef).default.fDoubleJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
		else
		{
			return Sqrt((-2.0 * KWPawn(PRef).default.fDoubleJumpHeight) * PhysicsVolume.default.Gravity.Z);
		}
	}
}

function float GetDefaultJumpDistScalarValue()
{
    local float Time, Distance;
	
    Time = -GetDefaultJumpValue(false) / PhysicsVolume.default.Gravity.Z;
    Distance = (SHCharacter(PRef).default.GroundSpeed * Time) * 2.0;
	
    return KWPawn(PRef).default.fJumpDist / Distance;
}

function TickEnabled(bool B) // Used from MACTION_ManageAntiCheat
{
	if(B)
	{
		self.Enable('Tick');
	}
	else
	{
		self.Disable('Tick');
	}
}

auto state GetReferences // Gets a PlayerController reference and a Pawn via Tick(). We can't get it through PostBeginPlay() since this actor runs its code earlier than the PlayerController is made
{
	function Tick(float DeltaTime)
	{
		PCRef = GetHero();
		GetHeroPawn();
		
		if(PCRef != none && PRef != none) // Once this is true, we have all of the required references
		{
			GotoState('');
		}
	}
	
Begin:
	stop;
}


defaultproperties
{
	bEnforceSteedsModifiedJumpHeight=true
	AnnouncementSettings=(fAnnTime=3,AnnColor=(R=255,G=0,B=0,A=255))
	bStatic=false
}