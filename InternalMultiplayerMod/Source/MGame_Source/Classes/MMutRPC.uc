// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// MMutRPC = Master's Replace PlayerController Mutator
// 
// A mutator that is capable of replacing ANY PlayerController in ANY map, including stock maps and bonus levels
// Simply open any map like you normally would, but add "?Mutator=MGame.MMutRPC" to the end of it
// Here's a console command to activate this mutator: "Open Book_FrontEnd?Mutator=MGame.MMutRPC"
// 
// This mutator uses a hacky method of doing this, which causes the beginning
// of every level to have to reload. After this occurs, no more reloading is
// required and you can now play the level with the new player controller.
// 
// If you want to force-add your own custom controller into any map, simply extend
// this mutator and change the default property of <NewController> to equal your
// own custom controller. At that point, you just simply change the mutator to
// the name of your mutator you just made.
// 
// 
// Pros of using this mutator:
// - Can easily add your own code into any map without modifying the map via a custom PlayerController instead of a custom actor
// - Easier custom game rule creations that are related directly with the current player
// - Can easily obtain the current player's controller and their pawn via calling PC and HP in your mutator's code
// - Don't have to make the framework for the mutator as you can easily extend this one
// 
// Cons of using this mutator:
// - A save-load will always occur at the beginning of every map, which can be a bit off-putting
// - The health bar no longer flashes when updating (unknown cause for bug)


class MMutRPC extends Mutator
	Config(MGame);


var class<SHHeroController> NewController; // What the PlayerController's class should be changed to
var KWHeroController PC;				   // PlayerController
var KWHeroController TPC;				   // Temporary PlayerController
var Pawn HP;							   // Hero Pawn
var KWCutController KWCC;				   // Temporary KWCutController
var array<KWCutController> KWCCs;		   // Temporary KWCutControllers (an array/collection made)
var bool bSaveTimerUsed;				   // If true, a SaveTimer was used at the beginning of the level (and we need to redo the SaveTimer)
var bool bIntroCutscenePlayed;			   // If true, an intro cutscene is playing (and doing a save-load during this will break the game)
var int i;								   // Temporary int
var int iAntiSoftlock;					   // A counter for how many times a KWCutController has been running without the cutscene being cinematic (this directly prevents the PlayerController replacement from occurring safely)


event PostBeginPlay()
{
	super.PostBeginPlay();
	
	Log("MGAME" @ class'MVersion'.default.Version @ "-- This level is running Master's RPC mutator, made by Master_64");
}

event PostLoadGame(bool bLoadFromSaveGame)
{
	local SaveTimer ST;
	local MCBGDelegate MCBGD;
	
	if(bLoadFromSaveGame && TPC != none) // If this is true, that means we've just done the save-load required for replacing the PlayerController
	{
		TPC.Destroy(); // Destroys the old PlayerController as it's now obsolete
		
		if(bSaveTimerUsed) // If a SaveTimer was used at the beginning of the level, we spawn in a new one to get a more accurate level start
		{
			ST = Spawn(class'SaveTimer');
			ST.timetowait = 1.33; // This is normally 1.0 seconds, but for some reason, it isn't accurate unless it's at 1.33 seconds
		}
	}
	
	if(Left(Level.GetLocalURL(), 15) == "Beanstalk_bonus") // If the current level is a KnowWonder beanstalk world, then this returns true
	{
		MCBGD = Spawn(class'MCBGDelegate'); // Doing a save-load breaks a beanstalk world's mechanics entirely. Doing this re-syncs the timer and total amount of coins in the level, which normally gets broken
	}
	
	PC = KWGame(Level.Game).GetHeroController();
	GetHeroPawn();
}

function GetHeroPawn() // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", Level.GetPropertyText("PlayerHeroActor"));
}

function GiveNewController() // Gives/replaces the current PlayerController with an entirely new one
{
	local SaveTimer ST;
	local BaseCam TC;
	local HUD TH;
	
	foreach DynamicActors(class'SaveTimer', ST) // Gets rid of any SaveTimers that may exist in the map and remembers a SaveTimer was used for the next time the level is reloaded
	{
		ST.Destroy();
		
		bSaveTimerUsed = true;
	}
	
	// All code below this is part of the hack I (Master_64) devised that replaces the current PlayerController even though this is normally impossible
	
	TPC = PC;						  // Saves the old PlayerController before hacking everything
	TH = TPC.myHUD;					  // Saves the old HUD reference before hacking everything
	TPC.UnPossess();				  // Unpossesses the now old PlayerController, causing both the current player's pawn and the current player's PlayerController to lose their object references
	PC = Spawn(NewController);		  // Creates a new controller
	PC.Possess(HP);					  // Possesses the original current player with the new controller
	PC.myHUD = TH;					  // Obtains the HUD that was originally used within the old PlayerController (if this isn't done, the HUD will be broken)
	PC.SwitchToPawn(KWPawn(HP), 0.0); // Officially tells the game that we're playing as the current player (without this, the current player will believe he isn't currently controlled)
	
	foreach DynamicActors(class'BaseCam', TC) // Creating a new controller creates a new camera as well. The old camera still exists on the old PlayerController, so this deletes that
	{
		if(TC != PC.Camera)
		{
			TC.Destroy();
		}
	}
	
	TPC.ConsoleCommand("SaveGame 9998"); // Saves all of the changes we just made
	TPC.ConsoleCommand("LoadGame 9998"); // Loads all of the changes. Doing this properly connects the new controller we just made to the original current player (because somehow KnowWonder's backend code makes this work), allowing us to now play the game
}

auto state GetReferences // Gets a PlayerController reference and a Pawn via Tick(). We can't get it through PostBeginPlay() since this actor runs its code earlier than the PlayerController is made
{
	function Tick(float DeltaTime)
	{
		PC = KWGame(Level.Game).GetHeroController();
		GetHeroPawn();
		
		if(PC != none && HP != none && PC.myHUD != none) // Once this is true, we have all of the required references
		{
			GotoState('WaitForIntro');
		}
	}
	
Begin:
	stop;
}

state WaitForIntro // Waits until the time is right to execute the replace PlayerController hack
{
	function FadeViewToBlack() // Fades the view to black
	{
		local FadeViewDelegate Fader;
		
		Fader = Spawn(class'FadeViewDelegate');
		Fader.Init(1.0, 0.0, 0.0, 0.0, 0.0, MOVE_TYPE_LINEAR, false);
	}
	
Begin:
	Sleep(0.01); // Waits a tick
	
	while(SHHeroController(PC).TimeAfterLoading == 0.0) // This value will be 0.0 until the player fully loads into the map
	{
		Sleep(0.01); // Waits a tick for each time the condition above is true
	}
	
	Sleep(0.01); // Waits a tick after the player has fully loaded into the map
	
	while(KWHud(PC.myHUD).CutTextController.bCutSceneInProgress) // If any cinematic cutscenes are playing, wait until that's done
	{
		bIntroCutscenePlayed = true;
		
		Sleep(0.01); // Waits a tick for each time the condition above is true
	}
	
	if(bIntroCutscenePlayed) // If a cinematic intro cutscene just finished playing, then we need to wait on all KWCutControllers to finish finishing up the cutscene in the background
	{
		foreach DynamicActors(class'KWCutController', KWCC) // Gets a collection of all KWCutControllers currently active
		{
			KWCCs[KWCCs.Length] = KWCC;
		}
		
		for(i = 0; i < KWCCs.Length; i++) // Runs through all KWCutControllers and waits until they are deleted
		{
			while(KWCCs[i] != none)
			{
				Sleep(0.01); // Waits a tick for each time the condition above is true
				
				if(!KWHud(PC.myHUD).CutTextController.bCutSceneInProgress) // If for some reason a KWCutController is still doing background work (which shouldn't normally occur), we add 1 to the anti-softlock counter
				{
					iAntiSoftlock++;
				}
				
				if(iAntiSoftlock >= 100) // When the anti-softlock counter reaches 100 (or in other words a full second has passed with nothing happening), then we stop waiting on this thread
				{
					break;
				}
			}
			
			iAntiSoftlock = 0; // Resets the anti-softlock counter for each iteration we run on each KWCutController
		}
	}
	
	FadeViewToBlack(); // Fades the view to black
	
	Sleep(0.01); // Waits a tick
	
	GiveNewController(); // Gives/replaces the current PlayerController with an entirely new one
	
	GotoState(''); // Exits all state code
	
	stop;
}

defaultproperties
{
	NewController=class'MasterController'
}