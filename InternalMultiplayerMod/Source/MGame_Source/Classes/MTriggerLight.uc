// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A light that can be toggled on and off through the use of events
// This code is ported directly from Shrek 2's Gameplay.u (KnowWonder's code)


class MTriggerLight extends Light
	Config(MGame);


var() float ChangeTime;
var() bool bInitiallyOn;
var() bool bDelayFullOn;
var() float RemainOnTime;
var float InitialBrightness;
var float Alpha;
var float direction;
var Actor SavedTrigger;
var float poundTime;


simulated function BeginPlay()
{
	InitialBrightness = LightBrightness;
	
	if(bInitiallyOn)
	{
		Alpha = 1;
		direction = 1;
	}
	else
	{
		Alpha = 0;
		direction = -1;
	}
	
	SetDrawType(DT_None);
}

function Tick(float DeltaTime)
{
	Alpha += ((direction * DeltaTime) / ChangeTime);
	
	if(Alpha > 1)
	{
		Alpha = 1;
		Disable('Tick');
		
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
	}
	else
	{
		if(Alpha < 0)
		{
			Alpha = 0;
			Disable('Tick');
			
			if(SavedTrigger != none)
			{
				SavedTrigger.EndEvent();
			}
		}
	}
	
	if(!bDelayFullOn)
	{
		LightBrightness = Alpha * InitialBrightness;
	}
	else
	{
		if(((direction > float(0)) && Alpha != float(1)) || Alpha == float(0))
		{
			LightBrightness = 0;
		}
		else
		{
			LightBrightness = InitialBrightness;
		}
	}
}

state() TriggerTurnsOn
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		direction = 1;
		Enable('Tick');
	}
	
	stop;
}

state() TriggerTurnsOff
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		direction = -1;
		Enable('Tick');
	}
	
	stop;
}

state() TriggerToggle
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		direction *= float(-1);
		Enable('Tick');
	}
	
	stop;
}

state() TriggerControl
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		
		if(bInitiallyOn)
		{
			direction = -1;
		}
		else
		{
			direction = 1;
		}
		
		Enable('Tick');
	}

	function UnTrigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		
		if(bInitiallyOn)
		{
			direction = 1;
		}
		else
		{
			direction = -1;
		}
		
		Enable('Tick');
	}
	
	stop;
}

state() TriggerPound
{
	function Timer()
	{
		if(poundTime >= RemainOnTime)
		{
			Disable('Timer');
		}
		
		poundTime += ChangeTime;
		direction *= float(-1);
		SetTimer(ChangeTime, false);
	}

	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(SavedTrigger != none)
		{
			SavedTrigger.EndEvent();
		}
		
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		direction = 1;
		poundTime = ChangeTime;
		SetTimer(ChangeTime, false);
		Enable('Timer');
		Enable('Tick');
	}
	
	stop;
}


defaultproperties
{
	bStatic=false
	bHidden=false
	bDynamicLight=true
	RemoteRole=ROLE_SimulatedProxy
	InitialState=TriggerToggle
	bMovable=true
	DrawType=DT_Sprite
	bLightingVisibility=true
	bUseDynamicLights=true
	bAcceptsProjectors=true
	bReplicateMovement=true
	Role=ROLE_Authority
	NetUpdateFrequency=100.0
	NetPriority=1.0
	LODBias=1.0
	DrawScale3D=(X=1.0,Y=1.0,Z=1.0),
	MaxLights=4
	ScaleGlow=1.0
	Style=STY_Normal
	SoundRadius=64.0
	SoundVolume=128
	SoundPitch=64
	TransientSoundVolume=0.30
	TransientSoundRadius=300.0
	bBlockZeroExtentTraces=true
	bBlockNonZeroExtentTraces=true
	bJustTeleported=true
	Mass=100.0
	MessageClass=class'LocalMessage'
	Texture=Texture'KWLight'
}