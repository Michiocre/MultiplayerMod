// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A controller that features a port of all console commands that are inside the cheat manager, as well as a ton of other new console commands
// This controller also fully strips away the game's default cheat manager, meaning that all of the console commands here overwrite the original CheatManager's console commands
// In a sense, think of this controller as both a cheat manager port and it's own custom controller
// This cheat manager port that's in this controller is modified quite heavily, but fixes a lot of bugs/glitches/issues with the original (see below)
// 
// 
// Simple list of all stock console command changes:
// 
// ListDynamicActors			Fixed to work as intended (was listing static actors)
// LockCamera					Fixed to work as intended (wasn't working)
// SetCameraDist				Fixed to work as intended (wasn't working)
// God <bool>					Not a toggle; requires a bool. Fixed to prevent other sources of damage/knockback
// Invisible <bool>				Not a toggle; requires a bool. Fixed to work as intended (only worked for a tick)
// SloMo <float>				No longer persists the speed across levels (use the console command SloMoSave instead if you need this to persist)
// SetJumpZ <float> <bool>		Added an optional bool. If <bool> is true, affects the double jump height instead
// SetHealth <float>			Health is now clamped to the minimum and maximum health values by default
// SetSpeed <float>				Takes a raw speed value instead of a multiplier and fixed to work as intended (would stop working all the time)
// ViewPlayer					Removed as ViewSelf does the same thing
// ViewFlag						Removed as this doesn't work for Shrek 2
// 
// 
// Full list of all new (or heavily edited) console commands:
// 
// MGameVersion													Displays to the user what the current MGame version is
// UnCauseEvent <event>											Does the opposite of CauseEvent
// ListStaticActors												Lists all static actors
// SloMoSave <float>											Acts like the original SloMo command where the SloMo speed persists
// SetPotions <int>												Sets the total of all potion totals to a specific value
// SetCoins <int>												Sets the coin total to a specific value
// ShowAINodes <bool>											Turns on ShowDebug, then shows all AI node lines/paths
// SetJumpZ <bool>												Sets your player's jump height (not for the double jump) to <float>. If the optional bool after is true, then the command changes the double jump height. The default value varies between characters
// Invisible <bool>												Turns on the player's invisibility
// NoTarget <bool>												Turns on the player's NoTarget
// FullDebug <bool>												Turns on both notable debug features
// SummonNoRot <library>.<class>								Same as Summon, but doesn't pitch the actor. The camera angle will still dictate how high or low the actor will spawn however
// SummonCoords <library>.<class> <float1> <float2> <float3>	Same as SummonNoRot, but spawns an actor at specific coordinates and doesn't rotate on any axis. Example: Summon SHGame.Shrek 360 420 640
// SetProp <ActorTag> <ActorVariable> <ActorValue>				Emulates SetProp. Example: "SetProp Shrek Health 64" sets the health of Shrek to a value of 64
// GetProp <ActorTag> <ActorVariable>							Just like SetProp, but will return with the value of the variable
// WhoAmI														Tells you who you are playing as
// Rocket														Takes away all movement input and propells in the direction you were last flying in
// Spider														Converts your character into a spider
// Driving														Takes away all movement input and makes you walk in the direction you were last walking in
// Announce <message>											Acts like AdminSay, but that can have the display time and colors customized (making it practical for real maps)
// AnnounceTime <float>											Sets the length at which an announcement should be onscreen for
// AnnounceColor <red> <green> <blue>							Sets the color of the announcement text (Example: "AnnounceSettings 127 255 0" will make the text have a greenish color)
// TP <float1> <float2> <float3>								Teleports the player to the specified coordinates
// TPBack														If the player has used the TP command, teleports them back to where they were originally
// WriteString <string>											Logs the entire string
// WriteStrings <string(s)>										Logs each word provided into a separate log
// UpdateInv													Updates the inventory, which is required to do when checking how many coins or potions a player has via a GetProp (not doing so may crash the game)
// SetBoth <int>												Sets to both the coin total and the potion total
// AddBoth <int>												Adds to both the coin total and the potion total
// BossCheat													Sets the health of all 4 main boss types to 1
// ChangeState <state> <bool>									Changes the state of the player to the state specified. If <bool> is true, then the state is changed relative to the pawn (instead of the controller)
// ChangePhysics <int>											Changes the physics of the player to the physics mode specified. Converts a numerical value to a physics enumerator
// AntiAntiCheat												Disables M.A.C. (Master's Anti-Cheat) permanently
// WaterJump													Makes the player jump out of the water
// AirJump														Executes an air jump if the player is falling (a time where you wouldn't otherwise be able to normally jump)
// AirJumpLimited												Same as AirJump, but has a maximum amount of air jumps (tied to iAirJumpMax)
// AddHealth <float>											Adds to the player's health
// Execute <string>												Allows you to execute multiple console commands from within a single console command. Simply add the keyword "|" between each console command, just like when configurating binds. Example: "Execute Ghost | SetHealth 50" runs both the console command "Ghost" and "SetHealth 50"
// SleepFor <float> <string>									The same as Execute but takes a time delay before working
// PlayASound <string>											Plays a 2D sound. Example: "PlayASound Shrek.Faint" will play Shrek's faint sound
// PlayADialog <string>											Plays a dialog from the player's mouth. Example: "PlayADialog pc_dnk_CarHijack_34" will play the voice line "Are we there yet?"
// PlayAMusic <string>											Plays a song. Example: "PlayAMusic 1_Swamp" will play the Shrek's Swamp theme
// RefreshJumpVars												Refreshes all jump variables on the current player to match the default values and the current environment. This should be used when the gravity changes or when the variables need to be defaulted
// SetGameState <string>										Sets the GSTATE (or GameState) to the value provided. Due to an arbitrary "valid check" forced by KnowWonder that can't be bypassed, this command can only change to the 6 GameStates you see in the KnowWonder debug menu
// GetGameState													Returns with the current GSTATE (or GameState) and prints the value in the KW debug log
// DropCarryingActor <bool>										Drops the currently held actor onto the ground. If <bool> is true, then the held actor is destroyed
// ConsoleKey <byte>											Changes the current console key to whichever key matches the number provided. This change persists until Default.ini is refreshed
// SetShamrock <int>											Sets the player's total shamrocks to <I>. Takes a value between -1 - 5. 5 is all shamrocks and 0 is no shamrocks
// AddShamrock <int>											Adds the player's total shamrocks by <I>
// 
// 
// New command aliases:
// 
// LogAIS -- LogScriptedSequences
// CE -- CauseEvent
// UCE -- UnCauseEvent
// SH -- SetHealth
// SP -- SetPotions
// SC -- SetCoins
// SB -- SetBoth
// AH -- AddHealth
// AP -- AddPotions
// AC -- AddCoins
// AB -- AddBoth
// BC -- BossCheat
// MV -- MGameVersion
// FD -- FullDebug
// AAC -- AntiAntiCheat
// 
// 
// New states:
// 
// PlayerCanWaterJump -- Allows the player to jump out of the water
// PlayerCanAirJump -- Allows the player to jump while in the air with no restrictions
// PlayerCanAirJumpLimited -- The same as PlayerCanAirJump but the player can only air jump a limited amount of times. The default amount of air jumps is 1
// PlayerAlwaysTripleJump -- The player will always be able to do a triple jump without the downward push afterward
// PlayerCannotDoubleJump -- Blocks the usage of double jumping
// PlayerCannotPunch -- Blocks the usage of punching


class MasterController extends ShrekController
	Config(User);


var name ActorTagName;
var float fAnnTime;
var byte AnnColorR;
var byte AnnColorG;
var byte AnnColorB;
var name NewState;
var bool bCanTPBack;
var vector OldTPLoc;
var Pawn ICP;
var float fTimeAfterLoading;
var int iAirJumpCounter;
var int iAirJumpMax;			 // The maximum amount of air jumps (limited) that can be used in a row
var float fPlayASoundVolume;	 // The volume at which any sound played with the console command "PlayASound" plays at
var bool bModifyHealthSFX;		 // Whether a sound effect should play when using SetHealth or AddHealth
var bool bModifyHealthKnockback; // Whether a sound effect should play when using SetHealth or AddHealth
var string ModifyHealthHealSFX;	 // What sound effect should play if SetHealth or AddHealth causes the player's health to increase
var string ModifyHealthHurtSFX;	 // What sound effect should play if SetHealth or AddHealth causes the player's health to decrease
var string ModifyHealthDeathCC;	 // What console command should be ran if SetHealth or AddHealth causes the player's health to go to 0 or below
var bool bTPBackOncePerTP;		 // If true, a TPBack only works once per TP (meaning a TP must be done before a TPBack can work once)
var int iTPRetryAttempts;		 // How many times should a TP be retried if the TP initially fails (due to the location being blocked). A safe value is 28, however if a TP you need isn't working consistently, you may need to increase this value (however higher values may impact performance)
var int iSummonRetryAttempts;	 // How many times should a summon be retried if the summoned actor is attempted to be spawned in an illegal position
var float fTeleportDist;		 // The maximum distance a teleport will work


event PostBeginPlay()
{
	super.PostBeginPlay();
	
	Log("MGAME" @ class'MVersion'.default.Version @ "-- A pawn is using Master's Controller, made by Master_64");
}

function array<string> Split(string Source, optional string Delimiter) // Takes a string, splits it up, then takes every individual string and puts it into its own array index
{
	local int place;
	local array<string> returnArray;
	
	if(Delimiter == "")
	{
		Delimiter = " ";
	}
	
	while(Len(Source) > 0)
	{
		place = InStr(Source, Delimiter);
		
		if(place < 0)
		{
			returnArray[returnArray.Length] = Source;
			Source = "";
		}
		else
		{
			if(place == 0)
			{
				Source = Mid(Source, 1);
			}
			else
			{
				returnArray[returnArray.Length] = Left(Source, place);
				Source = Mid(Source, place + 1);
			}
		}
	}
	
	return returnArray;
}

function CMAndLog(coerce string S) // Does a client message and a log
{
	ClientMessage(S);
	Log(S);
}

function CM(coerce string S) // Does a client message
{
	ClientMessage(S);
}

event OnEnginePreFirstTick(bool bLoadFromSaveGame) // Gets the time after loading, which allows for calculating a loadless time
{
	super.OnEnginePreFirstTick(bLoadFromSaveGame);
	
	fTimeAfterLoading = Level.TimeSeconds;
}

exec function MGameVersion() // Displays to the user what the current MGame version is
{
	local float fSavedAnnTime;
	local byte SavedAnnColorR, SavedAnnColorG, SavedAnnColorB;
	
	fSavedAnnTime = fAnnTime;
	SavedAnnColorR = AnnColorR;
	SavedAnnColorG = AnnColorG;
	SavedAnnColorB = AnnColorB;
	
	fAnnTime = 6.4;
	AnnColorR = 0;
	AnnColorG = 255;
	AnnColorB = 0;
	
	Announce("The current MGame version is:" @ class'MVersion'.default.Version);
	CMAndLog("The current MGame version is:" @ class'MVersion'.default.Version);
	
	fAnnTime = fSavedAnnTime;
	AnnColorR = SavedAnnColorR;
	AnnColorG = SavedAnnColorG;
	AnnColorB = SavedAnnColorB;
}

exec function ReviewJumpSpots(name TestLabel) // It's unknown what this console command does
{
	switch(TestLabel)
	{
		case 'Transloc':
			TestLabel = 'Begin';
			
			break;
		case 'Jump':
			TestLabel = 'Finished';
			
			break;
		case 'Combo':
			TestLabel = 'FinishedJumping';
			
			break;
		case 'LowGrav':
			TestLabel = 'FinishedComboJumping';
			
			break;
		default:
			break;
	}
	
	CMAndLog("TestLabel is " $ string(TestLabel));
	Level.Game.ReviewJumpSpots(TestLabel);
}

exec function ListStaticActors() // Logs all static actors
{
	local Actor A;
	local int i;
	
	foreach AllActors(class'Actor', A)
	{
		if(A.bStatic == true)
		{
			i++;
			Log(string(i) @ string(A));
		}
	}
	
	CMAndLog("Num static actors: " $ string(i));
}

exec function ListDynamicActors() // Logs all dynamic actors
{
	local Actor A;
	local int i;
	
	foreach DynamicActors(class'Actor', A)
	{
		i++;
		Log(string(i) @ string(A));
	}
	
	CMAndLog("Num dynamic actors: " $ string(i));
}

exec function FreezeFrame(float Delay) // Freezes the game until you click back into it. <Delay> is optional, but adds in a delay before freezing the game. A <Delay> of 1 is the equivalent of 1 second
{
	Level.Game.SetPause(true, self);
	Level.PauseDelay = Level.TimeSeconds + Delay;
}

exec function WriteToLog() // Will log "NOW!" in the log file
{
	CMAndLog("NOW!");
}

exec function SetFlash(float F) // Sets the opacity of the screen to <F>. A value of 0 is invisible and a value of 1 is visible
{
	FlashScale.X = F;
}

exec function KillViewedActor() // WARNING: DOING THIS WILL SOFTLOCK YOUR GAME COMPLETELY. Completely deletes yourself from the game, forcing you to have to quit out of the game
{
	if(ViewTarget != none)
	{
		if((Pawn(ViewTarget) != none) && (Pawn(ViewTarget).Controller != none))
		{
			Pawn(ViewTarget).Controller.Destroy();
		}
		
		ViewTarget.Destroy();
		SetViewTarget(none);
	}
}

exec function LogScriptedSequences() // Toggles logging of scripted sequences. This logs what exactly is happening from within a ScriptedSequence and is very helpful for advanced mappers
{
	local AIScript S;
	
	foreach AllActors(class'AIScript', S)
	{
		S.bLoggingEnabled =	!S.bLoggingEnabled;
	}
}

exec function Teleport() // Teleports yourself to where ever you're looking at. This appears to be inconsistent and related to who the current character is
{
	local Actor HitActor;
	local vector HitNormal, HitLocation;
	
	HitActor = Trace(HitLocation, HitNormal, ViewTarget.Location + fTeleportDist * vector(Rotation), ViewTarget.Location, true);
	
	if(HitActor == None)
	{
		HitLocation = ViewTarget.Location + fTeleportDist * vector(Rotation);
	}
	else
	{
		HitLocation = HitLocation + ViewTarget.CollisionRadius * HitNormal;
	}
	
	ViewTarget.SetLocation(HitLocation);
}

exec function ChangeSize(float F) // Changes the size of your player to <F>. A value of 1 is the normal size. This command appears to be a little bit glitchy
{
	if(Pawn.SetCollisionSize(Pawn.default.CollisionRadius * F, Pawn.default.CollisionHeight * F))
	{
		Pawn.SetDrawScale(F);
		Pawn.SetLocation(Pawn.Location);
	}
}

exec function LockCamera() // Toggles a camera lock. Does this through the use of the console command "MenuCam" that is normally locked behind the KW Debug mode, but is bypassed
{
	local bool b;
	
	b = bool(ConsoleCommand("Get KWGame.KWVersion bDebugEnabled"));
	
	if(!b)
	{
		ConsoleCommand("Set KWGame.KWVersion bDebugEnabled True");
	}
	
	ConsoleCommand("MenuCam");
	ConsoleCommand("Set KWGame.KWVersion bDebugEnabled" @ string(b));
}

exec function SetCameraDist(string S) // Sets the distance that the camera is from the player. Takes an optional boolean after it, which if true, instantly moves the camera
{
	local array<string> TokenArray;
	local BaseCam BC;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 1)
	{
		Warn("Master Controller (SetCameraDist) -- Missing arguments; aborting process");
		
		return;
	}
	
	foreach DynamicActors(class'BaseCam', BC)
	{
		BC.fDesiredLookAtDistance = float(TokenArray[0]);
		
		if(TokenArray.Length < 2)
		{
			return;
		}
		else if(bool(TokenArray[1]))
		{
			BC.fCurrLookAtDistance = float(TokenArray[0]);
		}
	}
}

exec function CauseEvent(name EventName) // Fires an event to <EventName>. Extremely helpful command
{
	TriggerEvent(EventName, Pawn, Pawn);
}

exec function UnCauseEvent(name EventName) // Does the opposite of CauseEvent
{
	UnTriggerEvent(EventName, Pawn, Pawn);
}

exec function Amphibious() // Makes the player able to breathe underwater for an "infinite" amount of time, however this isn't able to be used in Shrek 2 by default
{
	Pawn.UnderWaterTime = 2147483647;
}

exec function Fly() // Causes the player to fly around, while colliding with everything
{
	Pawn.UnderWaterTime = Pawn.default.UnderWaterTime;
	CM("You feel much lighter");
	Pawn.SetCollision(true, true, true);
	Pawn.bCollideWorld = true;
	bCheatFlying = true;
	GotoState('PlayerFlying');
}

exec function Ghost() // Causes the player to enter noclip mode, where you can fly through everything
{
	if(!Pawn.IsA('Vehicle'))
	{
		Pawn.UnderWaterTime = -1.0;
		CM("You feel ethereal");
		Pawn.SetCollision(false, false, false);
		Pawn.bCollideWorld = false;
		bCheatFlying = true;
		GotoState('PlayerFlying');
	}
	else
	{
		CMAndLog("Can't ghost in vehicles");
	}
}

exec function Walk() // Disables Fly or Ghost
{
	bCheatFlying = false;
	Pawn.UnderWaterTime = Pawn.default.UnderWaterTime;
	Pawn.SetCollision(true, true, true);
	Pawn.SetPhysics(PHYS_Walking);
	Pawn.bCollideWorld = true;
	ClientReStart();
}

exec function God(bool bGod) // Enables god mode, making you invincible to nearly everything. An exception to this is swinging logs and falling into the void
{
	if(bGod)
	{
		bGodMode = true;
		ShHeroPawn(Pawn).AmInvunerable = true;
		CM("God mode on");
	}
	else
	{
		bGodMode = false;
		ShHeroPawn(Pawn).AmInvunerable = false;
		CM("God mode off");
	}
}

exec function SloMo(float F) // Sets the game's speed to <F>. A value of 1 is the default
{
	Level.Game.SetGameSpeed(F);
}

exec function SloMoSave(float F) // Acts like the original SloMo command where the SloMo speed persists
{
	Level.Game.SetGameSpeed(F);
	Level.Game.SaveConfig();
	Level.Game.GameReplicationInfo.SaveConfig();
}

exec function SetPotions(int I) // Sets the total of all potion totals to a specific value
{
	local int iFor;
	local Potion1Collection PC1;
	local Potion2Collection PC2;
	local Potion3Collection PC3;
	local Potion4Collection PC4;
	local Potion5Collection PC5;
	local Potion6Collection PC6;
	local Potion7Collection PC7;
	local Potion8Collection PC8;
	local Potion9Collection PC9;
	
	UpdateInv();
	
	for(iFor = 0; iFor < 9; iFor++)
	{
		switch(iFor)
		{
			case 0: // Potion 1
				foreach AllActors(class'Potion1Collection', PC1)
				{
					PC1.iNumItems = I;
				}
				
				break;
			case 1: // Potion 2
				foreach AllActors(class'Potion2Collection', PC2)
				{
					PC2.iNumItems = I;
				}
				
				break;
			case 2: // Potion 3
				foreach AllActors(class'Potion3Collection', PC3)
				{
					PC3.iNumItems = I;
				}
				
				break;
			case 3: // Potion 4
				foreach AllActors(class'Potion4Collection', PC4)
				{
					PC4.iNumItems = I;
				}
				
				break;
			case 4: // Potion 5
				foreach AllActors(class'Potion5Collection', PC5)
				{
					PC5.iNumItems = I;
				}
				
				break;
			case 5: // Potion 6
				foreach AllActors(class'Potion6Collection', PC6)
				{
					PC6.iNumItems = I;
				}
				
				break;
			case 6: // Potion 7
				foreach AllActors(class'Potion7Collection', PC7)
				{
					PC7.iNumItems = I;
				}
				
				break;
			case 7: // Potion 8
				foreach AllActors(class'Potion8Collection', PC8)
				{
					PC8.iNumItems = I;
				}
				
				break;
			case 8: // Potion 9
				foreach AllActors(class'Potion9Collection', PC9)
				{
					PC9.iNumItems = I;
				}
				
				break;
		}
	}
}

exec function SetCoins(int I) // Sets the coin total to a specific value
{
	local CoinCollection CC;
	
	UpdateInv();
	
	foreach AllActors(class'CoinCollection', CC)
	{
		CC.iNumItems = I;
	}
}

exec function SetHealth(float H) // Sets the player's health to <H>. A value of 100 is the default (without clovers; each clover is +100)
{
	ModifyHealth(H);
}

exec function AddHealth(float H) // Adds to the player's health
{
	ModifyHealth(float(Pawn.GetPropertyText("Health")) + H);
}

function ModifyHealth(float H) // The core function behind modifying the player's health
{
	if(Pawn.IsInState('stateHeroDying')) // If the player is already dying and the player's health is attempted to be lowered, the command will not run
	{
		return;
	}
	
	UpdateHealthManagerStatus();
	
	if(bModifyHealthSFX && float(Pawn.GetPropertyText("Health")) < H) // If enabled, plays a hero bar pickup sound if the player is being healed, or a punch sound if being hurt
	{
		PlayASound(ModifyHealthHealSFX);
	}
	else if(bModifyHealthSFX)
	{
		PlayASound(ModifyHealthHurtSFX);
	}
	
	if(Pawn.IsA('SHHeroPawn') && bModifyHealthKnockback && !(float(Pawn.GetPropertyText("Health")) <= H) && 0.0 < H && Pawn.IsInState('StateIdle')) // If enabled, knocks the player back if the health change causes damage
	{
		SHHeroPawn(Pawn).GoToStateKnock(false);
	}
	
	Pawn.SetPropertyText("Health", string(FClamp(H, 0.0, HudHealthPtr.NumIcons * 100.0)));
	
	if(float(Pawn.GetPropertyText("Health")) <= 0.0 && (!ShHeroPawn(Pawn).AmInvunerable && !bGodMode)) // If health is going to 0 or below and no god mode is being used, kill the player
	{
		ConsoleCommand(ModifyHealthDeathCC);
	}
}

exec function SetShamrock(int I) // Sets the player's total shamrocks to <I>. Takes a value between -1 - 5. 5 is all shamrocks and 0 is no shamrocks
{
	if(Pawn.IsA('KWPawn'))
	{
		ModifyShamrock(I);
	}
}

exec function AddShamrock(int I) // Adds the player's total shamrocks by <I>
{
	local int iMinShamrock, iMaxShamrock;
	
	if(Pawn.IsA('KWPawn'))
	{
		SetPropertyText("ICP", Level.GetPropertyText("InventoryCarrierPawn"));
		
		iMinShamrock = -(KWPawn(ICP).GetInventoryCount('Shamrock') + 1);
		iMaxShamrock = 6 - (KWPawn(ICP).GetInventoryCount('Shamrock') + 1);
		
		I = Clamp(I, iMinShamrock, iMaxShamrock);
		
		if(I == 0)
		{
			return;
		}
		
		ModifyShamrock(KWPawn(ICP).GetInventoryCount('Shamrock') + I);
	}
}

function ModifyShamrock(int I) // The core function behind modifying the player's shamrock total
{
	local Shrek S;
	local int iOldShamrockCount;
	
	SetPropertyText("ICP", Level.GetPropertyText("InventoryCarrierPawn"));
	
	iOldShamrockCount = KWPawn(ICP).GetInventoryCount('Shamrock');
	
	KWPawn(ICP).AddToInventoryCollection(class'ShamrockCollection', -KWPawn(ICP).GetInventoryCount('Shamrock'));
	KWPawn(ICP).AddToInventoryCollection(class'ShamrockCollection', I);
	
	foreach DynamicActors(class'Shrek', S)
	{
		S.TotalHealthIcons = I;
	}
	
	Pawn.SetPropertyText("Health", string(100.0 * float(KWPawn(ICP).GetInventoryCount('Shamrock') + 1)));
	
	if(float(Pawn.GetPropertyText("Health")) > 1000.0)
	{
		Pawn.SetPropertyText("Health", "1000.0");
	}
	
	if(I >= iOldShamrockCount)
	{
		if(Pawn.IsA('ShHeroPawn'))
		{
			ShHeroPawn(Pawn).ResetSkinUp();
			ShHeroPawn(Pawn).PlayPickupShamrockBumpLine();
		}
		
		PlayASound("Items.PickupShamrock");
	}
	
	UpdateHealthManagerStatus();
	
	if(float(Pawn.GetPropertyText("Health")) <= 0.0 && (!ShHeroPawn(Pawn).AmInvunerable && !bGodMode))
	{
		ConsoleCommand("Suicide");
	}
}

exec function SetJumpZ(string S) // Sets your player's jump height (not for the double jump) to <float>. If the optional bool after is true, then the command changes the double jump height. The default value varies between characters
{
	local array<string> TokenArray;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 1)
	{
		Warn("Master Controller (SetJumpZ) -- Missing arguments; aborting process");
		
		return;
	}
	
	if(TokenArray.Length > 1)
	{
		if(bool(TokenArray[1]))
		{
			if(Pawn.IsA('KWPawn'))
			{
				KWPawn(Pawn).DoubleJumpZ = float(TokenArray[0]);
			}
		}
		else
		{
			Pawn.JumpZ = float(TokenArray[0]);
		}
	}
	else
	{
		Pawn.JumpZ = float(TokenArray[0]);
	}
}

exec function SetGravity(float F) // Sets the world's gravity to <float>. The default value is -1000
{
	PhysicsVolume.Gravity.Z = F;
}

exec function SetSpeed(float F) // Changes the player's speed to <F>. Some KnowWonder systems override this
{
	if(Pawn.IsA('KWPawn'))
	{
		KWPawn(Pawn).GroundRunSpeed = F;
	}
}

exec function KillAll(class<Actor> aClass) // Destroys all actors in the current map with the class <aClass>
{
	local Actor A;
	
	if(ClassIsChildOf(aClass, class'AIController'))
	{
		Level.Game.KillBots(Level.Game.NumBots);
		
		return;
	}
	
	if(ClassIsChildOf(aClass, class'Pawn'))
	{
		KillAllPawns(class<Pawn>(aClass));
		
		return;
	}
	
	foreach AllActors(class'Actor', A)
	{
		if(ClassIsChildOf(A.Class, aClass))
		{
			A.Destroy();
		}
	}
}

function KillAllPawns(class<Pawn> aClass) // Destroys all pawns in the current map. This always results in a softlock, but you can still save yourself with debugging tools or console commands
{
	local Pawn P;
	
	Level.Game.KillBots(Level.Game.NumBots);
	
	foreach AllActors(class'Pawn', P)
	{
		if(ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
		{
			if(P.Controller != none)
			{
				P.Controller.Destroy();
			}
			
			P.Destroy();
		}
	}
}

exec function KillPawns() // An alias for KillAllPawns() that kills all pawns instead of a specific type
{
	KillAllPawns(class'Pawn');
}

exec function Avatar(string ClassName) // Switches control to <library>.<class>, but camera remains on your last controlled character. Recommended to use SwapPawn over this, since it works better
{
	local class<Actor> NewClass;
	local Pawn P;
	
	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));
	
	foreach AllActors(class'Pawn', P)
	{
		if((P.Class == NewClass) && (P != Pawn))
		{
			if(Pawn.Controller != none)
			{
				Pawn.Controller.PawnDied(Pawn);
			}
			
			Possess(P);
		}
	}
}

exec function Summon(string ClassName) // Summons the actor <library>.<class> in front of you, with the rotation of your camera and the position a bit in front of you. This actor will fail to place if the actor collides with yourself during this. It's recommended to use the Ghost command before using this
{
	local class<Actor> NewClass;
	local vector SpawnLoc;
	
	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));
	
	if(Pawn != none)
	{
		SpawnLoc = Pawn.Location;
	}
	else
	{
		SpawnLoc = Location;
	}
	
	if(!FancySpawn(NewClass, iSummonRetryAttempts, SpawnLoc + 72 * vector(Rotation) + vect(0, 0, 1) * 15, Rotation))
	{
		CM("Failed to spawn actor");
		
		return;
	}
}

function bool FancySpawn(class<Actor> ClassType, int iSpawnAttempts, optional vector SpawnLocation, optional rotator SpawnRotation, optional bool bZOnly) // Sets the location of an actor. If the actor cannot move to the location, we iterate in all 6 possible directions to see if said adjustment allows it to successfully teleport
{
	local float R;
	local Actor A;
	local vector V, TV;
	local bool bNotFirst;
	
	V = SpawnLocation;
	
	if(iSpawnAttempts < 1)
	{
		iSpawnAttempts = 1;
	}
	
	if(!bNotFirst)
	{
		A = Spawn(ClassType,,, SpawnLocation, SpawnRotation);
		
		if(A != none)
		{
			return true;
		}
		
		bNotFirst = true;
	}
	
	for(R = 25.0; R <= (float(iSpawnAttempts) * 25.0); R += 25.0)
	{
		TV = V;
		TV.Z += R; // This is the only way to add to a single vector axis because UE2 is weird
		A = Spawn(ClassType,,, TV, SpawnRotation);
		if(A != none)
		{
			return true;
		}
		
		TV = V;
		TV.Z -= R;
		A = Spawn(ClassType,,, TV, SpawnRotation);
		if(A != none)
		{
			return true;
		}
		
		if(!bZOnly)
		{
			TV = V;
			TV.X += R;
			A = Spawn(ClassType,,, TV, SpawnRotation);
			if(A != none)
			{
				return true;
			}
			
			TV = V;
			TV.X -= R;
			A = Spawn(ClassType,,, TV, SpawnRotation);
			if(A != none)
			{
				return true;
			}
			
			TV = V;
			TV.Y += R;
			A = Spawn(ClassType,,, TV, SpawnRotation);
			if(A != none)
			{
				return true;
			}
			
			TV = V;
			TV.Y -= R;
			A = Spawn(ClassType,,, TV, SpawnRotation);
			if(A != none)
			{
				return true;
			}
		}
	}
	
	return false;
}

exec function PlayersOnly() // Freezes everything in the game except for all players, which in this case, is simply yourself
{
	Level.bPlayersOnly = !Level.bPlayersOnly;
}

exec function CheatView(class<Actor> aClass, optional bool bQuiet) // If you're using the FocusOn command to have a camera of an actor at the bottom left, using this command will change the focus to actor <class>. <bool1> does nothing, so ignore it. This command is basically the same as ViewClass
{
	ViewClass(aClass, bQuiet, true);
}

exec function FocusOn(optional class<Actor> aClass, optional bool bQuiet) // Enables the ShowDebug menu and then focuses on <aClass> in a smaller camera in the bottom left. This is super helpful when trying to watch what a certain actor is doing
{
	local HUD H;
	
	foreach AllActors(class'HUD', H)
	{
		H.bShowDebugInfo = true;
		H.SetPropertyText("bPortalDebugView", "True");
	}
	
	if(aClass != none)
	{
		ViewClass(aClass, bQuiet);
	}
}

exec function FocusOff() // Removes the camera in the bottom left, but doesn't toggle ShowDebug
{
	local HUD H;
	
	foreach AllActors(class'HUD', H)
	{
		H.SetPropertyText("bPortalDebugView", "False");
	}
}

exec function RememberSpot() // If ShowDebug is enabled, this will record the spot of whoever is being focused on in ShowDebug, then render a line that goes between where they were when they were recorded and where they are currently. Running this command again will re-record the spot
{
	if(Pawn != none)
	{
		Destination = Pawn.Location;
	}
	else
	{
		Destination = Location;
	}
}

exec function ViewSelf(optional bool bQuiet) // Focuses on yourself. Using the Walk command also emulates this for some reason
{
	bBehindView = false;
	bViewBot = false;
	
	SetViewTarget(Pawn);
	
	if(!bQuiet)
	{
		CM(OwnCamera);
	}
	
	FixFOV();
}

exec function ViewActor(name ActorName) // Focuses on a specific actor with the object name <ActorName>. Very helpful if you don't want to randomly cycle through the actor list like FocusOn does
{
	local Actor A;
	
	foreach AllActors(class'Actor', A)
	{
		if(A.Name == ActorName)
		{
			SetViewTarget(A);
			bBehindView = true;
			HandleViewTargetCam(ViewTarget);
			
			break;
		}
	}
}

exec function ViewTag(name TagName) // Just like ViewActor, but takes a tag instead. This is usually more useful, but not always
{
	local Actor A;
	
	foreach AllActors(class'Actor', A, TagName)
	{
		SetViewTarget(A);
		bBehindView = true;
		HandleViewTargetCam(ViewTarget);
		
		break;
	}
}

exec function ViewBot() // Focuses on the first enemy it finds
{
	local Actor first;
	local bool bFound;
	local Controller C;
	
	bViewBot = true;
	myHUD.bShowDebugInfo = true;
	myHUD.SetPropertyText("bDrawLines", "True");
	C = Level.ControllerList;
	
	if(C != none)
	{
		if(C.IsA('AIController') && (C.Pawn != none))
		{
			SetDebug(false);
			
			if(bFound || (first == none))
			{
				SetDebug(true);
				
				first = C.Pawn;
			}
			else
			{
				if((C.Pawn == ViewTarget) || (ViewTarget == none))
				{
					bFound = true;
				}
			}
		}
		
		C = C.nextController;
	}
	
	if(first != none)
	{
		SetViewTarget(first);
		bBehindView = true;
		CM("ALLRIGHT!!!");
		ViewTarget.BecomeViewTarget();
		FixFOV();
	}
	else
	{
		CM("DAMMIT!!!"); // Kids game by the way
		ViewSelf(true);
	}
}

function SetDebug(bool B) // Used in ViewBot to toggle debug mode
{
	local KWAIController KWAI;
	
	foreach DynamicActors(class'KWAIController', KWAI)
	{
		KWAI.bDebug = B;
	}
}

exec function ViewClass(class<Actor> aClass, optional bool bQuiet, optional bool bCheat) // If you're using the FocusOn command to have a camera of an actor at the bottom left, using this command will change the focus to actor <aClass>
{
	local Actor Other, first;
	local bool bFound;
	
	if((Level.Game != none) && !Level.Game.bCanViewOthers)
	{
		return;
	}
	
	first = none;
	
	foreach AllActors(aClass, Other)
	{
		if(bFound || (first == none))
		{
			first = Other;
			
			if(bFound)
			{
				break;
			}
		}
		
		if(Other == ViewTarget)
		{
			bFound = true;
		}
	}
	
	if(first != none)
	{
		if(!bQuiet)
		{
			if(Pawn(first) != none)
			{
				CM(ViewingFrom @ first.GetHumanReadableName());
			}
			else
			{
				CM(ViewingFrom @ string(first));
			}
		}
		
		SetViewTarget(first);
		bBehindView = ViewTarget != Pawn;
		
		if(bBehindView)
		{
			ViewTarget.BecomeViewTarget();
		}
		
		FixFOV();
		HandleViewTargetCam(ViewTarget);
	}
	else
	{
		ViewSelf(bQuiet);
	}
}

function HandleViewTargetCam(Actor ViewTarget); // Does nothing, but as it's in the game by default, it's kept in here

exec function SetMinPibBossHealth() // Sets the health of BossPIB to 1
{
	local BossPIB Boss;
	
	foreach DynamicActors(class'BossPIB', Boss)
	{
		Boss.SetPropertyText("Health", "1.0");
	}
}

exec function SetMinFGMBossHealth() // Sets the health of BossFGM to 1
{
	local BossFGM Boss;
	
	foreach DynamicActors(class'BossFGM', Boss)
	{
		Boss.SetPropertyText("Health", "1.0");
	}
}

exec function SetMinFatKnightHealth() // Sets the health of FatKnight to 1
{
	local FatKnight Boss;
	
	foreach DynamicActors(class'FatKnight', Boss)
	{
		Boss.SetPropertyText("Health", "1.0");
	}
}

exec function ShowAINodes(bool bAINodesEnabled) // Turns on ShowDebug, then shows all AI node lines/paths
{
	if(bAINodesEnabled)
	{
		ConsoleCommand("Set Engine.Hud bShowDebugInfo True");
		ConsoleCommand("Set Engine.Hud bDrawLines True");
		
		CM("AI nodes turned on");
	}
	else
	{
		ConsoleCommand("Set Engine.Hud bShowDebugInfo False");
		ConsoleCommand("Set Engine.Hud bDrawLines False");
		
		CM("AI nodes turned off");
	}
}

exec function Invisible(bool bInvisibilityEnabled) // Turns on the player's invisibility
{
	local bool b;
	
	b = bool(GetProp("CurrentPlayer bInvisible", true));
	
	if(!b && bInvisibilityEnabled)
	{
		ConsoleCommand("ToggleVisibility");
		
		CM("Invisibility turned on");
	}
	else if(b && !bInvisibilityEnabled)
	{
		ConsoleCommand("ToggleVisibility");
		
		CM("Invisibility turned off");
	}
}

exec function NoTarget(bool bNoTargetEnabled) // Turns on the player's NoTarget
{
	if(Pawn.IsA('ShHeroPawn') && bNoTargetEnabled)
	{
		ShHeroPawn(Pawn).bInvisible = true;
		
		CM("NoTarget turned on");
	} 
	else
	{
		ShHeroPawn(Pawn).bInvisible = false;
		
		CM("NoTarget turned off");
	}
}

exec function FullDebug(bool bFullDebug) // Turns on both notable debug features
{
	if(bFullDebug)
	{
		ConsoleCommand("Set KWGame.KWVersion bDebugEnabled True");
		ConsoleCommand("Set SHGame.Version bDebugEnabled True");
		
		CM("Both debug modes turned on");
	}
	else
	{
		ConsoleCommand("Set KWGame.KWVersion bDebugEnabled False");
		ConsoleCommand("Set SHGame.Version bDebugEnabled False");
		
		CM("Both debug modes turned off");
	}
}

exec function SummonNoRot(string ClassName) // Same as Summon, but doesn't pitch the actor. The camera angle will still dictate how high or low the actor will spawn however
{
	local class<Actor> NewClass;
	local vector SpawnLoc;
	local rotator TempRot;
	
	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));
	
	if(Pawn != none)
	{
		SpawnLoc = Pawn.Location;
	}
	else
	{
		SpawnLoc = Location;
	}
	
	TempRot = Rotation;
	TempRot.Pitch = 0;
	
	if(!FancySpawn(NewClass, iSummonRetryAttempts, SpawnLoc + 72 * vector(Rotation) + vect(0, 0, 1) * 15, TempRot))
	{
		CM("Failed to spawn actor");
		
		return;
	}
}

exec function SummonCoords(string S) // Same as SummonNoRot, but spawns an actor at specific coordinates and doesn't rotate on any axis. Example: Summon SHGame.Shrek 360 420 640
{
	local array<string> TokenArray;
	local class<Actor> NewClass;
	local vector SpawnLoc;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 4)
	{
		Warn("Master Controller (SummonCoords) -- Missing arguments; aborting process");
		
		return;
	}
	
	NewClass = class<Actor>(DynamicLoadObject(TokenArray[0], class'Class'));
	
	SpawnLoc.x = float(TokenArray[1]);
	SpawnLoc.y = float(TokenArray[2]);
	SpawnLoc.z = float(TokenArray[3]);
	
	if(!FancySpawn(NewClass, iSummonRetryAttempts, SpawnLoc, rot(0, 0, 0)))
	{
		CM("Failed to spawn actor");
		
		return;
	}
}

exec function SetProp(string S, optional bool bSilent) // Emulates SetProp. Example: "SetProp Shrek Health 64" sets the health of Shrek to a value of 64
{
	local array<string> TokenArray;
	local Actor TargetActor;
	local string ActorTag, Variable, Value;
	local int i;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 3)
	{
		Warn("Master Controller (SetProp) -- Missing arguments; aborting process");
		
		return;
	}
	
	if(Caps(TokenArray[0]) == "CURRENTPLAYER")
	{
		ActorTagName = Pawn.Tag;
		ActorTag = string(Pawn.Tag);
	}
	else
	{
		ActorTag = TokenArray[0];
		SetPropertyText("ActorTagName", ActorTag); // This hack manually converts a tag to a string through a global variable, allowing it to be used below. Why UE2???
	}
	
	Variable = TokenArray[1];
	Value = TokenArray[2];
	
	if(TokenArray.Length > 3) // If further strings are found in the split strings provided, we assume it's all a single string and merge any further strings with the <Value>
	{
		for(i = 3; i < TokenArray.Length; i++)
		{
			Value = Value @ TokenArray[i];
		}
	}
	
	foreach AllActors(class'Actor', TargetActor, ActorTagName)
	{
		TargetActor.SetPropertyText(Variable, Value);
		
		if(!bSilent)
		{
			CM("Set Prop" @ ActorTag @ Variable @ "=" @ Value);
		}
	}
}

exec function string GetProp(string S, optional bool bSilent) // Just like SetProp, but will return with the value of the variable
{
	local array<string> TokenArray;
	local Actor TargetActor;
	local string ActorTag, Variable, Value;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 2)
	{
		Warn("Master Controller (GetProp) -- Missing arguments; aborting process");
		
		return "";
	}
	
	if(Caps(TokenArray[0]) == "CURRENTPLAYER")
	{
		ActorTagName = Pawn.Tag;
		ActorTag = string(Pawn.Tag);
	}
	else
	{
		ActorTag = TokenArray[0];
		SetPropertyText("ActorTagName", ActorTag); // This hack manually converts a tag to a string through a global variable, allowing it to be used below. Why UE2???
	}
	
	Variable = TokenArray[1];
	
	foreach AllActors(class'Actor', TargetActor, ActorTagName)
	{
		Value = TargetActor.GetPropertyText(Variable);
		
		if(!bSilent)
		{
			CM("Get Prop" @ ActorTag @ Variable @ "=" @ Value);
		}
	}
	
	return Value;
}

exec function name WhoAmI() // Tells you who you are playing as
{
	CMAndLog("I am currently:" @ string(Pawn.Name));
	
	return Pawn.Name;
}

exec function Rocket() // Takes away all movement input and propells in the direction you were last flying in
{
	GotoState('PlayerRocketing');
	
	CM("You feel like a rocket");
}

exec function Spider() // Converts your character into a spider
{
	GotoState('PlayerSpidering');
	
	CM("You feel like a spider");
}

exec function Driving() // Takes away all movement input and makes you run in the direction you were last walking in
{
	GotoState('PlayerDriving');
	
	CM("You feel like a desert bus");
}

exec function Announce(string Msg) // Acts like AdminSay, but that can have the display time and colors customized (making it practical for real maps)
{
	ClearProgressMessages();
	SetProgressTime(fAnnTime);
	SetProgressMessage(0, Msg, class'Canvas'.static.MakeColor(AnnColorR, AnnColorG, AnnColorB));
	
	CM("Announcing");
}

exec function AnnounceTime(float F) // Sets the length at which an announcement should be onscreen for
{
	fAnnTime = F;
	
	CM("Announcement settings changed: ( Announcement time =" @ string(fAnnTime) @ ")");
}

exec function AnnounceColor(string S) // Sets the color of the announcement text (Example: "AnnounceSettings 127 255 0" will make the text have a greenish color)
{
	local array<string> TokenArray;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 3)
	{
		Warn("Master Controller (AnnounceColor) -- Missing arguments; aborting process");
		
		return;
	}
	
	AnnColorR = float(TokenArray[0]);
	AnnColorG = float(TokenArray[1]);
	AnnColorB = float(TokenArray[2]);
	
	CM("Announcement settings changed: ( Announcement color (Red):" @ string(AnnColorR) @ "| Announcement color (Green):" @ string(AnnColorG) @ "| Announcement color (Blue):" @ string(AnnColorB) @ ")");
}

exec function TP(string S) // Teleports the player to the specified coordinates
{
	local array<string> TokenArray;
	local string X, Y, Z;
	local vector Loc;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 3)
	{
		Warn("Master Controller (TP) -- Missing arguments; aborting process");
		
		return;
	}
	
	X = TokenArray[0];
	Y = TokenArray[1];
	Z = TokenArray[2];
	
	Loc.X = float(X);
	Loc.Y = float(Y);
	Loc.Z = float(Z);
	
	OldTPLoc = Pawn.Location;
	
	if(!FancySetLocation(Pawn, Loc, iTPRetryAttempts))
	{
		CM("Failed to teleport to:" @ X @ Y @ Z);
		
		return;
	}
	
	bCanTPBack = true;
	
	CM("Teleporting to:" @ X @ Y @ Z);
}

exec function TPBack() // If the player has used the TP command, teleports them back to where they were originally
{
	if(!bCanTPBack)
	{
		return;
	}
	
	if(bTPBackOncePerTP)
	{
		bCanTPBack = false;
	}
	
	if(!FancySetLocation(Pawn, OldTPLoc, iTPRetryAttempts))
	{
		CM("Failed to teleport to:" @ string(OldTPLoc.X) @ string(OldTPLoc.Y) @ string(OldTPLoc.Z));
		
		return;
	}
	
	CM("Teleporting to:" @ string(OldTPLoc.X) @ string(OldTPLoc.Y) @ string(OldTPLoc.Z));
}

function bool FancySetLocation(Actor TargetActor, Vector NewLocation, int iSetLocationAttempts, optional bool bZOnly) // Sets the location of an actor. If the actor cannot move to the location, we iterate in all 6 possible directions to see if said adjustment allows it to successfully teleport
{
	local float R;
	local vector V, TV;
	
	V = NewLocation;
	
	if(iSetLocationAttempts < 1)
	{
		iSetLocationAttempts = 1;
	}
	
	if(TargetActor.SetLocation(V))
	{
		return true;
	}
	
	for(R = 2.5; R <= (float(iSetLocationAttempts) * 2.5); R += 2.5)
	{
		TV = V;
		TV.Z += R; // This is the only way to add to a single vector axis because UE2 is weird
		if(TargetActor.SetLocation(TV))
		{
			return true;
		}
		
		TV = V;
		TV.Z -= R;
		if(TargetActor.SetLocation(TV))
		{
			return true;
		}
		
		if(!bZOnly)
		{
			TV = V;
			TV.X += R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.X -= R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.Y += R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
			
			TV = V;
			TV.Y -= R;
			if(TargetActor.SetLocation(TV))
			{
				return true;
			}
		}
	}
	
	return false;
}

exec function WriteString(string S) // Logs the entire string
{
	CMAndLog(S);
}

exec function WriteStrings(string S) // Logs each word provided into a separate Log()
{
	local array<string> TokenArray;
	local int i;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 1)
	{
		Warn("Master Controller (WriteStrings) -- Missing arguments; aborting process");
		
		return;
	}
	
	for(i = 0; i < TokenArray.Length; i++)
	{
		CMAndLog(TokenArray[i]);
	}
}

exec function UpdateInv() // Updates the inventory, which is recommended to do when checking how many coins or potions a player has (not doing so may crash the game)
{
	AddCoins(0);
	AddPotions(0);
	
	Log("Updated inventory");
}

exec function SetBoth(int I) // Sets to both the coin total and the potion total
{
	SetCoins(I);
	SetPotions(I);
	
	CM("Set" @ string(I) @ "coins and potions to the player");
}

exec function AddBoth(int I) // Adds to both the coin total and the potion total
{
	AddCoins(I);
	AddPotions(I);
	
	CM("Added" @ string(I) @ "coins and potions to the player");
}

exec function BossCheat() // Sets the health of all 4 main boss types to 1
{
	local BanditBoss Boss;
	
	SetMinPibBossHealth();
	SetMinFGMBossHealth();
	SetMinFatKnightHealth();
	
	foreach DynamicActors(class'BanditBoss', Boss)
	{
		Boss.SetPropertyText("Health", "1");
	}
	
	CM("All main bosses are now at 1 HP");
}

exec function ChangeState(string S) // Changes the state of the player to the state specified. If <bool> is true, then the state is changed relative to the pawn (instead of the controller)
{
	local array<string> TokenArray;
	
	TokenArray = Split(S);
	
	if(TokenArray.Length < 1)
	{
		Warn("Master Controller (ChangeState) -- Missing arguments; aborting process");
		
		return;
	}
	
	SetPropertyText("NewState", TokenArray[0]); // This hack manually converts a string to a name through a global variable, allowing it to be used below. Why UE2???
	
	if(TokenArray.Length > 1)
	{
		if(bool(TokenArray[1]))
		{
			Pawn.GotoState(NewState);
		}
		else
		{
			GotoState(NewState);
		}
	}
	else
	{
		GotoState(NewState);
	}
	
	CM("Switched to state:" @ NewState);
}

exec function ChangePhysics(int I) // Changes the physics of the player to the physics mode specified. Converts a numerical value to a physics enumerator
{
	Pawn.SetPhysics(EPhysics(I));
	
	CM("Switched to physics:" @ string(Pawn.Physics));
}

exec function AntiAntiCheat() // Disables M.A.C. (Master's Anti-Cheat) permanently
{
	local MAntiCheat AC;
	
	foreach DynamicActors(class'MAntiCheat', AC)
	{
		AC.TickEnabled(false);
		AC.Destroy();
	}
	
	CM("M.A.C. (Master's Anti-Cheat) has been permanently disabled");
}

exec function bool WaterJump() // Makes the player jump out of the water
{
	if(Pawn.IsA('shpawn'))
	{
		if(Pawn.Physics == PHYS_WALKING && shpawn(Pawn).bInWater == true) // Returns true if the player is standing on a floor and is in water
		{
			Pawn.Falling();
			Pawn.PlayFalling();
			Pawn.SetPhysics(PHYS_FALLING);
			Pawn.Velocity.Z = Pawn.JumpZ;
			Pawn.bUpAndOut = true;
			
			CM("Water Jump");
			
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

exec function bool AirJump() // Executes an air jump if the player is falling (a time where you wouldn't otherwise be able to normally jump)
{
	if(CanAirJump()) // Prevents this command from working unless the player is not in water, is falling and can't currently double jump
	{
		ShHeroPawn(Pawn).DoDoubleJump(false);
		bNotifyApex = true;
		
		CM("Air Jump");
		
		return true;
	}
	else
	{
		return false;
	}
}

exec function bool AirJumpLimited() // Same as AirJump, but has a maximum amount of air jumps (tied to iAirJumpMax)
{
	if(CanAirJump()) // Prevents this command from working unless the player is not in water, is falling and can't currently double jump
	{
		if(iAirJumpCounter >= iAirJumpMax)
		{
			return false;
		}
		
		ShHeroPawn(Pawn).DoDoubleJump(false);
		bNotifyApex = true;
		
		iAirJumpCounter++;
		
		CM("Air Jump Limited");
		
		return true;
	}
	else
	{
		return false;
	}
}

function bool CanAirJump() // This function is used in the AirJump command. Returns true if the player is capable of double jump, is not in water and is falling (true if velocity Z is negative)
{
	if(Pawn.IsA('shpawn'))
	{
		return (Pawn.bCanDoubleJump && !shpawn(Pawn).bInWater && Pawn.Velocity.Z < 0.0);
	}
    else
	{
		return (Pawn.bCanDoubleJump && Pawn.Velocity.Z < 0.0);
	}
}

exec function Execute(string S, optional bool bIsSleeping) // Allows you to execute multiple console commands from within a single console command. Simply add the keyword "|" between each console command, just like when configurating binds. Example: "Execute Ghost | SetHealth 50" runs both the console command "Ghost" and "SetHealth 50"
{
	local MConsoleCommandDelegate CCD;
	local array<string> TokenArray, ConsoleCommands;
	local float F;
	local int i, iCurrentCC;
	
	TokenArray = Split(S);
	
	if(!bIsSleeping)
	{
		if(TokenArray.Length < 1)
		{
			Warn("Master Controller (Execute) -- Missing arguments; aborting process");
			
			return;
		}
	}
	else if(TokenArray.Length < 2)
	{
		Warn("Master Controller (SleepFor) -- Missing arguments; aborting process");
		
		return;
	}
	
	if(ExecuteLoopCheck(TokenArray))
	{
		Warn("Master Controller (Execute) -- Infinite loop found; aborting process");
		
		return;
	}
	
	if(bIsSleeping)
	{
		F = float(TokenArray[0]);
	}
	
	ConsoleCommands[0] = TokenArray[int(bIsSleeping)];
	
	for(i = 1 + int(bIsSleeping); i < TokenArray.Length; i++) // String merger
	{
		if(Caps(TokenArray[i]) == "|") // If the keyword "|" is used between the command, we queue another console command to run
		{
			iCurrentCC++;
			
			ConsoleCommands[iCurrentCC] = "";
			
			continue;
		}
		
		if(ConsoleCommands[iCurrentCC] != "") // Adding a second part to the console command
		{
			ConsoleCommands[iCurrentCC] = ConsoleCommands[iCurrentCC] @ TokenArray[i];
		}
		else // Starting a new console command
		{
			ConsoleCommands[iCurrentCC] = TokenArray[i];
		}
	}
	
	if(!bIsSleeping)
	{
		CM("Executing the following console commands:");
	}
	else
	{
		CM("Sleeping for" @ string(F) @ "seconds, then executing the following console commands:");
	}
	
	for(i = 0; i < ConsoleCommands.Length; i++)
	{
		CM(ConsoleCommands[i]);
	}
	
	CCD = Spawn(class'MConsoleCommandDelegate');
	
	if(bIsSleeping)
	{
		CCD.fSleepFor = F;
	}
	
	CCD.ConsoleCommandsToRun = ConsoleCommands;
	CCD.GotoState('ExecuteCommands');
}

function bool ExecuteLoopCheck(array<string> TokenArray) // Returns true if an infinite loop is about to be executed within Execute or SleepFor
{
	local bool bLoopFound;
	local int i;
	
	for(i = 0; i < TokenArray.Length; i++)
	{
		if(Caps(TokenArray[i]) == "EXECUTE" || Caps(TokenArray[i]) == "SLEEPFOR") // If this is true, an infinite loop was found
		{
			bLoopFound = true;
			
			break;
		}
	}
	
	return bLoopFound;
}

exec function SleepFor(string S) // The same as Execute but takes a time delay before working
{
	local array<string> TokenArray;
	
	TokenArray = Split(S);
	
	if(float(TokenArray[0]) < 0.0) // If true, this console command will act like Execute instead of SleepFor, as for this to be true, it would mean no delay was given
	{
		Execute(S);
	}
	else
	{
		Execute(S, true);
	}
}

exec function PlayASound(string S) // Plays a 2D sound. Example: "PlayASound Shrek.Faint" will play Shrek's faint sound
{
	local Sound SoundToPlay;
	local string MB;
	
	SoundToPlay = Sound(DynamicLoadObject(S, class'Sound'));
	
	MB = Pawn.GetPropertyText("MouthBone"); // Saves the mouth bone name
	Pawn.SetPropertyText("MouthBone", "");  // Disables the mouth bone so that the sound played in the next line of code doesn't move the player's mouth
	
	ClientPlaySound(SoundToPlay, true, fPlayASoundVolume); // Plays the sound
	
	Pawn.SetPropertyText("MouthBone", MB); // Loads the previously saved mouth bone so that the player's mouth moves
	
	CM("Playing sound:" @ string(SoundToPlay));
}

exec function PlayADialog(string S) // Plays a dialog from the player's mouth. Example: "PlayADialog pc_dnk_CarHijack_34" will play the voice line "Are we there yet?"
{
	if(Pawn.IsA('KWPawn'))
	{
		KWPawn(Pawn).DeliverLocalizedDialog(S, true, 0, "HPDialog",, true, 1.4, false);
		
		CM("Playing dialog:" @ S);
	}
	else
	{
		Warn("Master Controller (PlayADialog) -- Pawn isn't a KWPawn; aborting process");
	}
}

exec function PlayAMusic(string S) // Plays a song. Example: "PlayAMusic 1_Swamp" will play the Shrek's Swamp theme
{
	StopAllMusic(1.0); // Stops all other songs
	
	PlayMusic(S, 1.0); // Plays a song
	
	CM("Playing music:" @ S);
}

exec function RefreshJumpVars() // Refreshes all jump variables on the current player to match the default values and the current environment. This should be used when the gravity changes or when the variables need to be defaulted
{
	if(Pawn.IsA('KWPawn'))
	{
		KWPawn(Pawn).SetJumpVars();
		
		CM("Refreshed all jump variables");
	}
	else
	{
		Warn("Master Controller (RefreshJumpVars) -- Pawn isn't a KWPawn; aborting process");
	}
}

exec function SetGameState(string S) // Sets the GSTATE (or GameState) to the value provided. Due to an arbitrary "valid check" forced by KnowWonder that can't be bypassed, this command can only change to the 6 GameStates you see in the KnowWonder debug menu
{
	KWGame(Level.Game).SetGameState(S);
	
	CM("Set GameState to:" @ KWGame(Level.Game).CurrentGameState);
}

exec function string GetGameState() // Returns with the current GSTATE (or GameState) and prints the value in the KW debug log
{
	CM("GameState is currently:" @ KWGame(Level.Game).CurrentGameState);
	
	return KWGame(Level.Game).CurrentGameState;
}

exec function DropCarryingActor(string S) // Drops the currently held actor onto the ground. If <bool> is true, then the held actor is destroyed
{
	if(Pawn.IsA('KWPawn'))
	{
		if(bool(S))
		{
			KWPawn(Pawn).aHolding.Destroy();
		}
		
		KWPawn(Pawn).DropCarryingActor();
	}
}

exec function ConsoleKey(byte I) // Changes the current console key to whichever key matches the number provided. This change persists until Default.ini is refreshed
{
	ConsoleCommand("Set ini:Engine.Engine.Console ConsoleKey" @ string(I));
	
	CM("Rebound the console key to key:" @ ConsoleCommand("KeyName" @ string(I)));
}


// Command Aliases

exec function LogAIS() // LogScriptedSequences
{
	LogScriptedSequences();
}

exec function CE(name EventName) // CauseEvent
{
	CauseEvent(EventName);
}

exec function UCE(name EventName) // UnCauseEvent
{
	UnCauseEvent(EventName);
}

exec function SH(float F) // SetHealth
{
	SetHealth(F);
}

exec function SP(int I) // SetPotions
{
	SetPotions(I);
}

exec function SC(int I) // SetCoins
{
	SetCoins(I);
}

exec function SB(int I) // SetBoth
{
	SetPotions(I);
	SetCoins(I);
}

exec function AH(float F) // AddHealth
{
	AddHealth(F);
}

exec function AP(int I) // AddPotions
{
	AddPotions(I);
}

exec function AC(int I) // AddCoins
{
	AddCoins(I);
}

exec function AB(int I) // AddBoth
{
	AddPotions(I);
	AddCoins(I);
}

exec function BC() // BossCheat
{
	BossCheat();
}

exec function MV() // MGameVersion
{
	MGameVersion();
}

exec function FD(bool B) // FullDebug
{
	FullDebug(B);
}

exec function AAC() // AntiAntiCheat
{
	AntiAntiCheat();
}

// States -- Note: multiple known KnowWonder and UE2 mechanics may overwrite a state entirely

state PlayerCanWaterJump extends PlayerWalking // Allows the player to jump out of the water
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	exec function Jump(optional float f)
	{
		if(!WaterJump())
		{
			super.Jump(f);
		}
	}
	
	stop;
}

state PlayerCanAirJump extends PlayerWalking // Allows the player to jump while in the air with no restrictions
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	exec function Jump(optional float f)
	{
		if(!AirJump())
		{
			super.Jump(f);
		}
	}
	
	stop;
}

state PlayerCanAirJumpLimited extends PlayerWalking // The same as PlayerCanAirJump but the player can only air jump a limited amount of times. The default amount of air jumps is 1
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	exec function Jump(optional float f)
	{
		if(!AirJumpLimited())
		{
			super.Jump(f);
		}
	}
	
	function bool NotifyLanded(Vector HitNormal)
	{
		iAirJumpCounter = 0;
		
		return bUpdating;
	}
	
	function PlayerTick(float DeltaTime)
	{
		if(Pawn == none)
		{
			return;
		}
		
		if(Pawn.IsInState('MountFinish'))
		{
			iAirJumpCounter = 0;
		}
		
		global.PlayerTick(DeltaTime);
	}
	
	stop;
}

state PlayerCanWaterJumpAndAirJumpLimited extends PlayerWalking // PlayerCanWaterJump and PlayerCanAirJumpLimited combined
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	exec function Jump(optional float f)
	{
		if(!WaterJump())
		{
			super.Jump(f);
		}
		
		if(!AirJumpLimited())
		{
			super.Jump(f);
		}
	}
	
	function bool NotifyLanded(Vector HitNormal)
	{
		iAirJumpCounter = 0;
		
		return bUpdating;
	}
	
	function PlayerTick(float DeltaTime)
	{
		if(Pawn == none)
		{
			return;
		}
		
		if(Pawn.IsInState('MountFinish'))
		{
			iAirJumpCounter = 0;
		}
		
		global.PlayerTick(DeltaTime);
	}
	
	stop;
}

state PlayerAlwaysTripleJump extends PlayerWalking // The player will always be able to do a triple jump without the downward push afterward
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	event NotifyJumpApex()
	{
		return;
	}
	
	stop;
}

state PlayerCannotDoubleJump extends PlayerWalking // Blocks the usage of double jumping
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	function BeginState()
	{
		Pawn.bCanDoubleJump = false;
	}
	
	function EndState()
	{
		Pawn.bCanDoubleJump = Pawn.default.bCanDoubleJump;
	}
	
	stop;
}

state PlayerCannotPunch extends PlayerWalking // Blocks the usage of punching
{
	function Rotator GetRotationForPawnMove()
	{
		if(bUseCameraAxesForPawnMove)
		{
			return rCameraRot();
		}
		else
		{
			return Pawn.Rotation;
		}
	}
	
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		super.NotifyPhysicsVolumeChange(NewVolume);
		
		return false;
	}
	
	exec function Fire(optional float f)
	{
		super.Fire(f);
	}
	
	stop;
}


defaultproperties
{
	fTeleportDist=10000.0
	fAnnTime=1.0
	AnnColorR=255
	AnnColorG=255
	AnnColorB=255
	iAirJumpMax=1
	fPlayASoundVolume=0.4
	bModifyHealthSFX=true
	bModifyHealthKnockback=true
	iTPRetryAttempts=28
	iSummonRetryAttempts=75
	ModifyHealthHealSFX="items.pickup_HeroBar"
	ModifyHealthHurtSFX="Peasants.Peasant_punch01"
	ModifyHealthDeathCC="Suicide"
	MinHitWall=-1.0
	AcquisitionYawRate=20000
	PlayerReplicationInfoClass=class'PlayerReplicationInfo'
	bHidden=true
	bHiddenEd=true
	bAlwaysMouseLook=true
	bZeroRoll=true
	bDynamicNetSpeed=true
	AnnouncerVolume=4
	MaxResponseTime=0.70
	OrthoZoom=40000.0
	CameraDist=9.0
	DesiredFOV=85.0
	DefaultFOV=85.0
	FlashScale=(X=1.0,Y=1.0,Z=1.0),
	MaxTimeMargin=0.35
	ProgressTimeOut=8.0
	QuickSaveString="Quick Saving"
	NoPauseMessage="Game is not pauseable"
	ViewingFrom="Now viewing from"
	OwnCamera="Now viewing from own camera"
	LocalMessageClass=class'LocalMessage'
	EnemyTurnSpeed=45000
	SpectateSpeed=600.0
	DynamicPingThreshold=400.0
	bEnablePickupForceFeedback=true
	bEnableWeaponForceFeedback=true
	bEnableDamageForceFeedback=true
	bEnableGUIForceFeedback=true
	bForceFeedbackSupported=true
	FovAngle=85.0
	Handedness=1.0
	bIsPlayer=true
	bCanOpenDoors=true
	bCanDoSpecial=true
	NetPriority=3.0
	bTravel=true
	bRotateToDesired=true
	bUseBaseCam=true
	bMovePawn=true
	bUseCameraAxesForPawnMove=true
	bShouldRotate=true
	bArrowKeysYaw=true
	strGameMenu="KWGame.MainMenuPage"
	strGameMenuSave="KWGame.MainMenuPage"
	bBehindView=true
	bNotifyApex=true
	RotationRate=(Pitch=4096,Yaw=45000,Roll=3072),
	bPauseWithSpecial=false
	PotionMusicHandle=-1
	Save0Image="storybookanimTX.box_button"
	Save1Image="storybookanimTX.box_button"
	Save2Image="storybookanimTX.box_button"
	Save3Image="storybookanimTX.box_button"
	Save4Image="storybookanimTX.box_button"
	Save5Image="storybookanimTX.box_button"
	DefaultSelectCursorType=none
	CameraClass=class'ShCam'
	rSnapRotation=(Pitch=-1,Yaw=0,Roll=0),
	rSnapRotationSpeed=(Pitch=7,Yaw=0,Roll=0),
	bDoOpacityForCamera=true
	CheatClass=none
	InputClass=class'ShPlayerInput'
	IngameWantedPosterPopUpImage="SH_Menu.WantedPosters.Full_Want_Shrek"
	bFadeInWantedPoster=true
	minsfx=Sound'UI.page_turn'
	bFirstCoin=true
}