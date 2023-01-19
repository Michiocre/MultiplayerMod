// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Categorizes all of the Master Keypoints in the Keypoints dropdown list, seen when going through the actor's dropdown list


class MKeypoint extends Keypoint
	Config(MGame);


defaultproperties
{
	DrawType=DT_Sprite
	bLightingVisibility=true
	bUseDynamicLights=true
	bAcceptsProjectors=true
	bReplicateMovement=true
	RemoteRole=ROLE_DumbProxy
	Role=ROLE_Authority
	NetUpdateFrequency=100.0
	NetPriority=1.0
	LODBias=1.0
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
	bBlockZeroExtentTraces=true
	bBlockNonZeroExtentTraces=true
	bJustTeleported=true
	Mass=100.0
	MessageClass=class'LocalMessage'
}