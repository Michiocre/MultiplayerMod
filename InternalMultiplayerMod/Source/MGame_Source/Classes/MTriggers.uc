// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Categorizes all of the Master Triggers in the Trigger dropdown list, seen when going through the actor's dropdown list


class MTriggers extends Trigger
	Config(MGame);


enum ETellOtherTrigger {
  TOT_TurnOn,
  TOT_TurnOff
};
var(Trigger) bool bTriggerByDirection;
var(Trigger) bool bActivateOnUntouchInsteadOfTouch;
var(Trigger) bool bTT_CP_EventMustMatchTag;
var(Trigger) ETellOtherTrigger TellOtherTrigger;
var(Events) array<name> MultiEvents;
var(Events) bool bOneAtATime;
var(Events) bool bLoop;
var(Events) int NextEventIndex;
enum ELumosType {
  Lumos_None,
  Lumos_Appear,
  Lumos_Disappear
};
enum EMountAction {
  MA_AutoFinishMount,
  MA_AbleFinishMount,
  MA_UnAbleFinishMount,
  MA_StepUpOnlyMount
};
enum EMaterialType {
  MTYPE_None,
  MTYPE_Stone,
  MTYPE_Rug,
  MTYPE_Wood,
  MTYPE_Cave,
  MTYPE_Cloud,
  MTYPE_Wet,
  MTYPE_Grass,
  MTYPE_Metal,
  MTYPE_Dirt,
  MTYPE_Hay,
  MTYPE_Leaf,
  MTYPE_Snow,
  MTYPE_Sand,
  MTYPE_Quicksand,
  MTYPE_Mud,
  MTYPE_WetCanJump
};
enum ECollideType {
  CT_Cylinder,
  CT_Box
};
var(Actor) ELumosType LumosType;
var(Advanced) EMountAction MountAction;
var(Advanced) EMaterialType MaterialType;
var(Lighting) bool bNoShadows;
var(Advanced) bool bHideOnDetailDrop;
var(Display) int AlphaSortLayer;
var(Display) float LODBiasSW;
var(Display) float CullDistanceSW;
var(Advanced) bool bDontBatch;
var(Sound) float TransientSoundPitch;
var(Collision) const float CollisionWidth;
var(Collision) ECollideType CollideType;
var(Movement) bool bSmoothDesiredRot;
var(Movement) Rotator RotationalAcceleration;
var(Movement) float fRotationalTightness;
var(Collision) bool bAlignBottom;
var(Collision) bool bAlignBottomAlways;
var(Actor) string Label;
var(Editing) bool bPauseWithSpecial;
var(Collision) bool bBlocksCamera;
var(Display) bool bUseSkinColorMod;
var(Display) Color SkinColorModifier;
var(Animation) float fDefaultAnimRate;
var(Animation) float fDefaultTweenTime;
var(Animation) int DefaultAnimChannel;
var(Reaction) Class<Projectile> vulnerableToClass;
var(Targeting) float SizeModifier;
var(Targeting) Vector CentreOffset;
var(Targeting) float GestureDistance;
var(Targeting) bool bGestureFaceHorizOnly;
var(Targeting) bool bMustClickToTarget;
var(GameState) array<string> ExcludeFromGameStates;
var(Opacity) bool bChangeOpacityForCamera;
var(Opacity) float DesiredOpacityForCamera;
var(Opacity) float SpeedOpacityForCamera;
var(Opacity) float CurrentOpacityForCamera;


function PostBeginPlay()
{
	super.PostBeginPlay();
	
	self.SetPropertyText("bDoActionWhenTriggered", "True");
}


defaultproperties
{
	Texture=Texture'Engine.S_Trigger'
	bInitiallyActive=true
	ReTriggerDelay=0.01
	TriggerTime=-1.0
	bLightingVisibility=true
	bUseDynamicLights=true
	bAcceptsProjectors=true
	bReplicateMovement=true
	RemoteRole=ROLE_DumbProxy
	Role=ROLE_Authority
	NetUpdateFrequency=100.0
	NetPriority=1.0
	LODBias=1.0
	LODBiasSW=1.0
	DrawScale=1.0
	DrawScale3D=(X=1.0,Y=1.0,Z=1.0),
	MaxLights=4
	ScaleGlow=1.0
	Style=STY_Normal
	bMovable=true
	SoundRadius=64.0
	SoundVolume=128
	SoundPitch=64
	TransientSoundVolume=0.30
	TransientSoundRadius=300.0
	TransientSoundPitch=1.0
	bBlockZeroExtentTraces=true
	bBlockNonZeroExtentTraces=true
	bJustTeleported=true
	RotationalAcceleration=(Pitch=200000,Yaw=200000,Roll=200000),
	fRotationalTightness=5.0
	Mass=100.0
	MessageClass=class'LocalMessage'
	bAlignBottom=true
	bPauseWithSpecial=true
	SkinColorModifier=(R=128,G=128,B=128,A=255),
	fDefaultAnimRate=1.0
	SizeModifier=1.0
	CentreOffset=(X=0.0,Y=0.0,Z=10.0),
	GestureDistance=1.0
	DesiredOpacityForCamera=0.50
	SpeedOpacityForCamera=1.0
	CurrentOpacityForCamera=1.0
}