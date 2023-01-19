// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Manages the current camera settings
// Simply enable any of the variables below for them to apply to the current camera settings
// Has the ability to randomize nearly everything individually
// Most settings can be defaulted by enabling bDefaultAllApplications and then enabling which variables you want defaulted
// See variables comments below (not in structs this time as they wouldn't be helpful)
// 
// Important notice: some variables require specific scenarios in order to apply
// Minor notice: An application of fLookAtDistance currently requires that the current player is using a MasterController


class MACTION_ManageCameraSettings extends ScriptedAction
	Config(MGame);


struct CamChangesStruct // Which variables should be changed
{
	var() bool bDefaultAllApplications;	// If true, any features below that are activated will be defaulted instead of being set to a specific value
	var() bool bApply_rCamRotation;
	var() bool bApply_rCamRotationStep;
	var() bool bApply_fMinPitch;
	var() bool bApply_fMaxPitch;
	var() bool bApply_fMoveTightness;
	var() bool bApply_fMoveBackTightness;
	var() bool bApply_fRotTightness;
	var() bool bApply_fRotSpeed;
	var() bool bApply_fLookAtDistance;
	var() bool bApply_FOVSettings;
	var() bool bApply_vLookAtOffset;
	var() bool bApply_fLookAtOffsetX;
	var() bool bApply_fLookAtOffsetY;
	var() bool bApply_fLookAtOffsetZ;
	var() bool bApply_fLookAtHeight;
	var() bool bApply_fMoveSpeed;
	var() bool bApply_fMaxMouseDeltaX;
	var() bool bApply_fMaxMouseDeltaY;
	var() bool bApply_bGotoLastCameraMode;
	var() bool bApply_bAutoLevelCamera;
	var() bool bApply_bCameraControlsRotation;
	var() bool bApply_fDesiredCamDistFromWall;
	var() bool bApply_fCameraRollModifier;
	var() bool bApply_bDoWorldCollisionCheck;
};

struct RandomizeStruct // Which variables should be randomized
{
	var() bool bRand_rCamRotation;
	var() bool bRand_rCamRotationStep;
	var() bool bRand_fMinPitch;
	var() bool bRand_fMaxPitch;
	var() bool bRand_fMoveTightness;
	var() bool bRand_fMoveBackTightness;
	var() bool bRand_fRotTightness;
	var() bool bRand_fRotSpeed;
	var() bool bRand_fLookAtDistance;
	var() bool bRand_vLookAtOffset;
	var() bool bRand_fLookAtOffsetX;
	var() bool bRand_fLookAtOffsetY;
	var() bool bRand_fLookAtOffsetZ;
	var() bool bRand_fLookAtHeight;
	var() bool bRand_fMoveSpeed;
	var() bool bRand_fMaxMouseDeltaX;
	var() bool bRand_fMaxMouseDeltaY;
	var() bool bRand_fDesiredCamDistFromWall;
	var() bool bRand_fCameraRollModifier;
};

struct SetFOVStruct // The new FOV settings to apply
{
	var() float fFOV;						   // What new FOV to change to
	var() float fTime;						   // How long in seconds this FOV change should take
	var() BaseCam.enumMoveType TransitionType; // What kind of transition type should be used
};

struct RandRangeStruct // If using randomness
{
	var() string Min; // The minimum random value
	var() string Max; // The maximum random value
};

struct RandRangesStruct // The random ranges to use when using randomness
{
	var() RandRangeStruct Rand_rCamRotation[3];
	var() RandRangeStruct Rand_rCamRotationStep[3];
	var() RandRangeStruct Rand_fMinPitch;
	var() RandRangeStruct Rand_fMaxPitch;
	var() RandRangeStruct Rand_fMoveTightness[3];
	var() RandRangeStruct Rand_fMoveBackTightness;
	var() RandRangeStruct Rand_fRotTightness;
	var() RandRangeStruct Rand_fRotSpeed;
	var() RandRangeStruct Rand_fLookAtDistance;
	var() RandRangeStruct Rand_vLookAtOffset[3];
	var() RandRangeStruct Rand_fLookAtOffsetX;
	var() RandRangeStruct Rand_fLookAtOffsetY;
	var() RandRangeStruct Rand_fLookAtOffsetZ;
	var() RandRangeStruct Rand_fLookAtHeight;
	var() RandRangeStruct Rand_fMoveSpeed;
	var() RandRangeStruct Rand_fMaxMouseDeltaX;
	var() RandRangeStruct Rand_fMaxMouseDeltaY;
	var() RandRangeStruct Rand_fDesiredCamDistFromWall;
	var() RandRangeStruct Rand_fCameraRollModifier;
};

struct AllCamChangesStruct
{
	var() CamChangesStruct CamChangesToApply;
	var() RandomizeStruct CamRands;
	var() RandRangesStruct CamRandRanges;
};

var(Action) AllCamChangesStruct CamChanges;			 // What camera changes should be applied (which variables are going to be changed, which are randomized and which are defaulted)
var(Action) rotator rCamRotation;					 // The current camera rotation
var(Action) rotator rCamRotationStep;				 // The camera rotation step values
var(Action) float fMinPitch;						 // How low the camera can pitch
var(Action) float fMaxPitch;						 // How high the camera can pitch
var(Action) vector fMoveTightness;					 // How tight is the camera movement
var(Action) float fMoveBackTightness;				 // How tight is the camera movement when it moves back (happens when a wall behind the camera moves back or stops colliding)
var(Action) float fRotTightness;					 // How tight is the camera rotation
var(Action) float fRotSpeed;						 // How fast does the camera rotate
var(Action) float fLookAtDistance;					 // How far should the current player be from the camera
var(Action) bool bLookAtDistance_NoSmoothTransition; // If true, removes the transition when applying the variable fLookAtDistance
var(Action) SetFOVStruct FOVSettings;				 // What FOV to change to (a simplified version of SetFOV)
var(Action) vector vLookAtOffset;					 // The camera offset (X,Y,Z)
var(Action) float fLookAtOffsetX;					 // The camera offset (X)
var(Action) float fLookAtOffsetY;					 // The camera offset (Y)
var(Action) float fLookAtOffsetZ;					 // The camera offset (Z)
var(Action) float fLookAtHeight;					 // How high should the camera look (relative to the current player)
var(Action) float fMoveSpeed;						 // How fast should the camera move on its own
var(Action) float fMaxMouseDeltaX;					 // The maximum amount of camera movement allowed at once on the X axis
var(Action) float fMaxMouseDeltaY;					 // The maximum amount of camera movement allowed at once on the Y axis
var(Action) bool bGotoLastCameraMode;				 // If true, goes to the last camera mode
var(Action) bool bAutoLevelCamera;					 // If true, auto levels the camera
var(Action) float fAutoLevelCameraRotationPitch;	 // The pitch that auto leveling should level to
var(Action) bool bCameraControlsRotation;			 // If true, allows the camera to control the camera's rotation. This is used in HP3 when Harry slides down the ice slides
var(Action) float fDesiredCamDistFromWall;			 // How far the camera should be from anything it collides with (higher values decrease the ability to clip the camera through walls)
var(Action) float fCameraRollModifier;				 // The multiplier for the camera's ability to roll
var(Action) bool bDoWorldCollisionCheck;			 // If true, the camera collides with the world
var Pawn HP;										 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local KWHeroController PC;
	local vector TempVector;
	local rotator TempRotator;
	local float f1;
	
	PC = KWGame(C.Level.Game).GetHeroController();
	GetHeroPawn(C);
	
	if(PC == none)
	{
		Warn(ActionString @ "-- Hero controller could not be found; aborting process");
		
		return false;
	}
	
	if(PC.Camera == none)
	{
		Warn(ActionString @ "-- Hero controller's camera could not be found; aborting process");
		
		return false;
	}
	
	if(HP == none)
	{
		Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
		
		return false;
	}
	
	if(CamChanges.CamChangesToApply.bApply_rCamRotation)
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			PC.Camera.SetRot(Rot(0, 0, 0));
		}
		else if(CamChanges.CamRands.bRand_rCamRotation)
		{
			TempRotator = Rot(0, 0, 0);
			TempRotator.Pitch = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotation[0].Min), float(CamChanges.CamRandRanges.Rand_rCamRotation[0].Max)));
			TempRotator.Yaw = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotation[1].Min), float(CamChanges.CamRandRanges.Rand_rCamRotation[1].Max)));
			TempRotator.Roll = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotation[2].Min), float(CamChanges.CamRandRanges.Rand_rCamRotation[2].Max)));
			
			PC.Camera.SetRot(TempRotator);
		}
		else
		{
			PC.Camera.SetRot(rCamRotation);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_rCamRotationStep)
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			PC.Camera.SetRotStep(Rot(0, 0, 0));
		}
		else if(CamChanges.CamRands.bRand_rCamRotationStep)
		{
			TempRotator = Rot(0, 0, 0);
			TempRotator.Pitch = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotationStep[0].Min), float(CamChanges.CamRandRanges.Rand_rCamRotationStep[0].Max)));
			TempRotator.Yaw = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotationStep[1].Min), float(CamChanges.CamRandRanges.Rand_rCamRotationStep[1].Max)));
			TempRotator.Roll = int(RandRange(float(CamChanges.CamRandRanges.Rand_rCamRotationStep[2].Min), float(CamChanges.CamRandRanges.Rand_rCamRotationStep[2].Max)));
			
			PC.Camera.SetRotStep(TempRotator);
		}
		else
		{
			PC.Camera.SetRotStep(rCamRotationStep);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMinPitch && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMinPitch = KWPawn(HP).default.CameraSetStandard.fMinPitch;
			PC.Camera.SetMinPitch(KWPawn(HP).default.CameraSetStandard.fMinPitch);
		}
		else if(CamChanges.CamRands.bRand_fMinPitch)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fMinPitch.Min), float(CamChanges.CamRandRanges.Rand_fMinPitch.Max));
			KWPawn(HP).CameraSetStandard.fMinPitch = f1;
			PC.Camera.SetMinPitch(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMinPitch = fMinPitch;
			PC.Camera.SetMinPitch(fMinPitch);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMaxPitch && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMaxPitch = KWPawn(HP).default.CameraSetStandard.fMaxPitch;
			PC.Camera.SetMaxPitch(KWPawn(HP).default.CameraSetStandard.fMaxPitch);
		}
		else if(CamChanges.CamRands.bRand_fMaxPitch)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fMaxPitch.Min), float(CamChanges.CamRandRanges.Rand_fMaxPitch.Max));
			KWPawn(HP).CameraSetStandard.fMaxPitch = f1;
			PC.Camera.SetMaxPitch(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMaxPitch = fMaxPitch;
			PC.Camera.SetMaxPitch(fMaxPitch);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMoveTightness && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMoveTightness = KWPawn(HP).default.CameraSetStandard.fMoveTightness;
			PC.Camera.SetMoveTightness(KWPawn(HP).default.CameraSetStandard.fMoveTightness);
		}
		else if(CamChanges.CamRands.bRand_fMoveTightness)
		{
			TempVector = Vect(0, 0, 0);
			TempVector.X = RandRange(float(CamChanges.CamRandRanges.Rand_fMoveTightness[0].Min), float(CamChanges.CamRandRanges.Rand_fMoveTightness[0].Max));
			TempVector.Y = RandRange(float(CamChanges.CamRandRanges.Rand_fMoveTightness[1].Min), float(CamChanges.CamRandRanges.Rand_fMoveTightness[1].Max));
			TempVector.Z = RandRange(float(CamChanges.CamRandRanges.Rand_fMoveTightness[2].Min), float(CamChanges.CamRandRanges.Rand_fMoveTightness[2].Max));
			
			KWPawn(HP).CameraSetStandard.fMoveTightness = TempVector;
			PC.Camera.SetMoveTightness(TempVector);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMoveTightness = fMoveTightness;
			PC.Camera.SetMoveTightness(fMoveTightness);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMoveBackTightness)
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			PC.Camera.SetMoveBackTightness(4.0);
		}
		else if(CamChanges.CamRands.bRand_fMoveBackTightness)
		{
			PC.Camera.SetMoveBackTightness(RandRange(float(CamChanges.CamRandRanges.Rand_fMoveBackTightness.Min), float(CamChanges.CamRandRanges.Rand_fMoveBackTightness.Max)));
		}
		else
		{
			PC.Camera.SetMoveBackTightness(fMoveBackTightness);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fRotTightness && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fRotTightness = KWPawn(HP).default.CameraSetStandard.fRotTightness;
			PC.Camera.SetRotTightness(KWPawn(HP).default.CameraSetStandard.fRotTightness);
		}
		else if(CamChanges.CamRands.bRand_fRotTightness)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fRotTightness.Min), float(CamChanges.CamRandRanges.Rand_fRotTightness.Max));
			KWPawn(HP).CameraSetStandard.fRotTightness = f1;
			PC.Camera.SetRotTightness(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fRotTightness = fRotTightness;
			PC.Camera.SetRotTightness(fRotTightness);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fRotSpeed && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fRotSpeed = KWPawn(HP).default.CameraSetStandard.fRotSpeed;
			PC.Camera.SetRotSpeed(KWPawn(HP).default.CameraSetStandard.fRotSpeed);
		}
		else if(CamChanges.CamRands.bRand_fRotSpeed)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fRotSpeed.Min), float(CamChanges.CamRandRanges.Rand_fRotSpeed.Max));
			KWPawn(HP).CameraSetStandard.fRotSpeed = f1;
			PC.Camera.SetRotSpeed(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fRotSpeed = fRotSpeed;
			PC.Camera.SetRotSpeed(fRotSpeed);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fLookAtDistance && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fLookAtDistance = KWPawn(HP).default.CameraSetStandard.fLookAtDistance;
			PC.ConsoleCommand("SetCameraDist" @ string(KWPawn(HP).default.CameraSetStandard.fLookAtDistance) @ string(bLookAtDistance_NoSmoothTransition));
		}
		else if(CamChanges.CamRands.bRand_fLookAtDistance)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fLookAtDistance.Min), float(CamChanges.CamRandRanges.Rand_fLookAtDistance.Max));
			KWPawn(HP).CameraSetStandard.fLookAtDistance = f1;
			PC.ConsoleCommand("SetCameraDist" @ string(f1) @ string(bLookAtDistance_NoSmoothTransition));
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fLookAtDistance = fLookAtDistance;
			PC.ConsoleCommand("SetCameraDist" @ string(fLookAtDistance) @ string(bLookAtDistance_NoSmoothTransition));
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_FOVSettings)
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			PC.Camera.SetFOV(PC.default.DefaultFOV, FOVSettings.fTime, FOVSettings.TransitionType);
		}
		else
		{
			PC.Camera.SetFOV(FOVSettings.fFOV, FOVSettings.fTime, FOVSettings.TransitionType);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_vLookAtOffset && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset = KWPawn(HP).default.CameraSetStandard.vLookAtOffset;
			PC.Camera.SetOffset(KWPawn(HP).default.CameraSetStandard.vLookAtOffset);
		}
		else if(CamChanges.CamRands.bRand_vLookAtOffset)
		{
			TempVector = Vect(0, 0, 0);
			TempVector.X = RandRange(float(CamChanges.CamRandRanges.Rand_vLookAtOffset[0].Min), float(CamChanges.CamRandRanges.Rand_vLookAtOffset[0].Max));
			TempVector.Y = RandRange(float(CamChanges.CamRandRanges.Rand_vLookAtOffset[1].Min), float(CamChanges.CamRandRanges.Rand_vLookAtOffset[1].Max));
			TempVector.Z = RandRange(float(CamChanges.CamRandRanges.Rand_vLookAtOffset[2].Min), float(CamChanges.CamRandRanges.Rand_vLookAtOffset[2].Max));
			
			KWPawn(HP).CameraSetStandard.vLookAtOffset = TempVector;
			PC.Camera.SetOffset(TempVector);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset = vLookAtOffset;
			PC.Camera.SetOffset(vLookAtOffset);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fLookAtOffsetX && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.X = KWPawn(HP).default.CameraSetStandard.vLookAtOffset.X;
			PC.Camera.SetXOffset(KWPawn(HP).default.CameraSetStandard.vLookAtOffset.X);
		}
		else if(CamChanges.CamRands.bRand_fLookAtOffsetX)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fLookAtOffsetX.Min), float(CamChanges.CamRandRanges.Rand_fLookAtOffsetX.Max));
			KWPawn(HP).CameraSetStandard.vLookAtOffset.X = f1;
			PC.Camera.SetXOffset(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.X = fLookAtOffsetX;
			PC.Camera.SetXOffset(fLookAtOffsetX);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fLookAtOffsetY && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Y = KWPawn(HP).default.CameraSetStandard.vLookAtOffset.Y;
			PC.Camera.SetYOffset(KWPawn(HP).default.CameraSetStandard.vLookAtOffset.Y);
		}
		else if(CamChanges.CamRands.bRand_fLookAtOffsetY)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fLookAtOffsetY.Min), float(CamChanges.CamRandRanges.Rand_fLookAtOffsetY.Max));
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Y = f1;
			PC.Camera.SetYOffset(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Y = fLookAtOffsetY;
			PC.Camera.SetYOffset(fLookAtOffsetY);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fLookAtOffsetZ && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Z = KWPawn(HP).default.CameraSetStandard.vLookAtOffset.Z;
			PC.Camera.SetZOffset(KWPawn(HP).default.CameraSetStandard.vLookAtOffset.Z);
		}
		else if(CamChanges.CamRands.bRand_fLookAtOffsetZ)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fLookAtOffsetZ.Min), float(CamChanges.CamRandRanges.Rand_fLookAtOffsetZ.Max));
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Z = f1;
			PC.Camera.SetZOffset(f1);
		}
		else
		{
			KWPawn(HP).CameraSetStandard.vLookAtOffset.Z = fLookAtOffsetZ;
			PC.Camera.SetZOffset(fLookAtOffsetZ);
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fLookAtHeight && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fLookAtHeight = KWPawn(HP).default.CameraSetStandard.fLookAtHeight;
		}
		else if(CamChanges.CamRands.bRand_fLookAtHeight)
		{
			KWPawn(HP).CameraSetStandard.fLookAtHeight = RandRange(float(CamChanges.CamRandRanges.Rand_fLookAtHeight.Min), float(CamChanges.CamRandRanges.Rand_fLookAtHeight.Max));
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fLookAtHeight = fLookAtHeight;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMoveSpeed && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMoveSpeed = KWPawn(HP).default.CameraSetStandard.fMoveSpeed;
		}
		else if(CamChanges.CamRands.bRand_fMoveSpeed)
		{
			KWPawn(HP).CameraSetStandard.fMoveSpeed = RandRange(float(CamChanges.CamRandRanges.Rand_fMoveSpeed.Min), float(CamChanges.CamRandRanges.Rand_fMoveSpeed.Max));
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMoveSpeed = fMoveSpeed;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMaxMouseDeltaX && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaX = KWPawn(HP).default.CameraSetStandard.fMaxMouseDeltaX;
		}
		else if(CamChanges.CamRands.bRand_fMaxMouseDeltaX)
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaX = RandRange(float(CamChanges.CamRandRanges.Rand_fMaxMouseDeltaX.Min), float(CamChanges.CamRandRanges.Rand_fMaxMouseDeltaX.Max));
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaX = fMaxMouseDeltaX;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fMaxMouseDeltaY && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaY = KWPawn(HP).default.CameraSetStandard.fMaxMouseDeltaY;
		}
		else if(CamChanges.CamRands.bRand_fMaxMouseDeltaY)
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaY = RandRange(float(CamChanges.CamRandRanges.Rand_fMaxMouseDeltaY.Min), float(CamChanges.CamRandRanges.Rand_fMaxMouseDeltaY.Max));
		}
		else
		{
			KWPawn(HP).CameraSetStandard.fMaxMouseDeltaY = fMaxMouseDeltaY;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_bGotoLastCameraMode && bGotoLastCameraMode)
	{
		PC.Camera.GotoLastCameraMode();
	}
	
	if(CamChanges.CamChangesToApply.bApply_bAutoLevelCamera && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).CameraSnapRotationPitch = KWPawn(HP).default.CameraSnapRotationPitch;
			KWPawn(HP).CameraNoSnapRotation = KWPawn(HP).default.CameraNoSnapRotation;
		}
		else
		{
			KWPawn(HP).CameraSnapRotationPitch = fAutoLevelCameraRotationPitch;
			KWPawn(HP).CameraNoSnapRotation = !bAutoLevelCamera;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_bCameraControlsRotation && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).bControlsCameraRot = KWPawn(HP).default.bControlsCameraRot;
		}
		else
		{
			KWPawn(HP).bControlsCameraRot = bCameraControlsRotation;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fDesiredCamDistFromWall && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).fDesiredCamDistFromWall = KWPawn(HP).default.fDesiredCamDistFromWall;
			PC.Camera.fDesiredCamDistFromWall = KWPawn(HP).default.fDesiredCamDistFromWall;
		}
		else if(CamChanges.CamRands.bRand_fDesiredCamDistFromWall)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fDesiredCamDistFromWall.Min), float(CamChanges.CamRandRanges.Rand_fDesiredCamDistFromWall.Max));
			KWPawn(HP).fDesiredCamDistFromWall = f1;
			PC.Camera.fDesiredCamDistFromWall = f1;
		}
		else
		{
			KWPawn(HP).fDesiredCamDistFromWall = fDesiredCamDistFromWall;
			PC.Camera.fDesiredCamDistFromWall = fDesiredCamDistFromWall;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_fCameraRollModifier && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).fCameraRollModifier = KWPawn(HP).default.fCameraRollModifier;
			PC.Camera.fCameraRollModifier = KWPawn(HP).default.fCameraRollModifier;
		}
		else if(CamChanges.CamRands.bRand_fCameraRollModifier)
		{
			f1 = RandRange(float(CamChanges.CamRandRanges.Rand_fCameraRollModifier.Min), float(CamChanges.CamRandRanges.Rand_fCameraRollModifier.Max));
			KWPawn(HP).fCameraRollModifier = f1;
			PC.Camera.fCameraRollModifier = f1;
		}
		else
		{
			KWPawn(HP).fCameraRollModifier = fCameraRollModifier;
			PC.Camera.fCameraRollModifier = fCameraRollModifier;
		}
	}
	
	if(CamChanges.CamChangesToApply.bApply_bDoWorldCollisionCheck && HP.IsA('KWPawn'))
	{
		if(CamChanges.CamChangesToApply.bDefaultAllApplications)
		{
			KWPawn(HP).bDoWorldCollisionCheck = KWPawn(HP).default.bDoWorldCollisionCheck;
			PC.Camera.bDoWorldCollisionCheck = KWPawn(HP).default.bDoWorldCollisionCheck;
		}
		else
		{
			KWPawn(HP).bDoWorldCollisionCheck = bDoWorldCollisionCheck;
			PC.Camera.bDoWorldCollisionCheck = bDoWorldCollisionCheck;
		}
	}
	
	return false;
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	return ActionString @ "-- Applying" @ string(int(CamChanges.CamChangesToApply.bApply_rCamRotation) + int(CamChanges.CamChangesToApply.bApply_rCamRotationStep) + int(CamChanges.CamChangesToApply.bApply_fMinPitch) + int(CamChanges.CamChangesToApply.bApply_fMaxPitch) + int(CamChanges.CamChangesToApply.bApply_fMoveTightness) + int(CamChanges.CamChangesToApply.bApply_fMoveBackTightness) + int(CamChanges.CamChangesToApply.bApply_fRotTightness) + int(CamChanges.CamChangesToApply.bApply_fRotSpeed) + int(CamChanges.CamChangesToApply.bApply_fLookAtDistance) + int(CamChanges.CamChangesToApply.bApply_FOVSettings) + int(CamChanges.CamChangesToApply.bApply_vLookAtOffset) + int(CamChanges.CamChangesToApply.bApply_fLookAtOffsetX) + int(CamChanges.CamChangesToApply.bApply_fLookAtOffsetY) + int(CamChanges.CamChangesToApply.bApply_fLookAtOffsetZ) + int(CamChanges.CamChangesToApply.bApply_fLookAtHeight) + int(CamChanges.CamChangesToApply.bApply_fMoveSpeed) + int(CamChanges.CamChangesToApply.bApply_fMaxMouseDeltaX) + int(CamChanges.CamChangesToApply.bApply_fMaxMouseDeltaY) + int(CamChanges.CamChangesToApply.bApply_bGotoLastCameraMode) + int(CamChanges.CamChangesToApply.bApply_bAutoLevelCamera) + int(CamChanges.CamChangesToApply.bApply_bCameraControlsRotation) + int(CamChanges.CamChangesToApply.bApply_fDesiredCamDistFromWall) + int(CamChanges.CamChangesToApply.bApply_fCameraRollModifier) + int(CamChanges.CamChangesToApply.bApply_bDoWorldCollisionCheck)) @ "camera changes";
}


defaultproperties
{
	ActionString="Manage Camera Settings"
	fMinPitch=-10000.0
	fMaxPitch=10000.0
	fMoveTightness=(X=25.0,Y=40.0,Z=40.0)
	fMoveBackTightness=4.0
	fRotTightness=8.0
	fRotSpeed=8.0
	fLookAtDistance=170.0
	FOVSettings=(fFOV=85.0,fTime=1.0,TransitionType=MOVE_TYPE_EASE_FROM_AND_TO)
	vLookAtOffset=(X=-25.0,Y=0.0,Z=65.0)
	fLookAtOffsetX=-25.0
	fLookAtOffsetY=0.0
	fLookAtOffsetZ=65.0
	fLookAtHeight=50.0
	fMoveSpeed=0.0
	fMaxMouseDeltaX=190.0
	fMaxMouseDeltaY=65.0
	bGotoLastCameraMode=true
	bAutoLevelCamera=true
	fAutoLevelCameraRotationPitch=-3500.0
	bCameraControlsRotation=true
	fDesiredCamDistFromWall=15.0
	fCameraRollModifier=1.0
	bDoWorldCollisionCheck=true
}