// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Contains 5 DevKit patches that can be injected into any map
// Simply enable which patches you want to enable and they will 
// be automatically injected into the map on each map load
// Do NOT include 2 or more of this actor in the same map
// 
// 
// List of patches available:
// - Potion Pushing (pressure volumes with a specific tag will push potions)
// - Shimmyable Meshes (static meshes with a specific tag can be shimmyed)
// - Fog Enforcement (ZoneInfo's can use occluding fog)
// - Steed Double Jump Fix (Steed's double jump is now fixed)
// - PIB Factory Fall Damage (makes PIB take the same amount of fall damage seen in factory)


class MDevKitPatcher extends MKeypoint
	Config(MGame);


struct FogStruct
{
	var() name ZoneInfoTag; 	  // What ZoneInfo's tag to get
	var() Color DistanceFogColor; // What color should the fog be
	var() float DistanceFogStart; // Where should the fog start
	var() float DistanceFogEnd;	  // Where should the fog end
};

struct PatchStruct
{
	var() bool bPressureVolumesWithTagPushPotions; // If true, makes pressure volumes with the tag <PressureVolumeTag> actually push potion bottles
	var() bool bMeshesWithTagBecomeShimmyable;	   // If true, makes all static meshes with the tag <ShimmyPipeTag> shimmyable
	var() bool bEnforceFogForZoneInfo;			   // If true, adds occluding fog to a ZoneInfo
	var() bool bFixSteedsDoubleJump;			   // If true, fixes Steed's double jump height being broken
	var() bool bMakePIBTakeFactoryFallDamage;	   // If true, makes PIB's fall damage the same as in factory
};

var() PatchStruct PatchesToApply;  // Which patches to inject
var() name PressureVolumeTag;	   // The tag of each pressure volume to affect
var() name ShimmyPipeTag;		   // The tag of each shimmy pipe to affect
var() array<FogStruct> FogActions; // Which fog options to use per ZoneInfo


event PostBeginPlay()
{
	local MDevKitPatcher DK;
	local PressureVolume PV;
	local StaticMeshActor SM;
	local ZoneInfo ZI;
	local Steed S;
	local PIB P;
	local int i, iAppliedCount;
	
	super.PostBeginPlay();
	
	foreach DynamicActors(class'MDevKitPatcher', DK) // A check to make sure no more than 2 MDevKitPatcher exist in the current level
	{
		i++;
		
		if(i > 1)
		{
			Warn("MDevKitPatcher -- Deleting a duplicate MDevKitPatcher");
			
			self.Destroy();
			
			return;
		}
	}
	
	if(PatchesToApply.bPressureVolumesWithTagPushPotions) // Potion Pushing
	{
		foreach AllActors(class'PressureVolume', PV, PressureVolumeTag)
		{
			PV.SetPropertyText("bAffectAllActors", "True");
			
			iAppliedCount++;
		}
	}
	
	if(PatchesToApply.bMeshesWithTagBecomeShimmyable) // Shimmyable Meshes
	{
		foreach AllActors(class'StaticMeshActor', SM, ShimmyPipeTag)
		{
			SM.bIsMountable = true;
			SM.SetPropertyText("MountAction", "MA_UnAbleFinishMount");
			
			iAppliedCount++;
		}
	}
	
	if(PatchesToApply.bEnforceFogForZoneInfo) // Fog Enforcement
	{
		for(i = 0; i < FogActions.Length; i++)
		{
			foreach AllActors(class'ZoneInfo', ZI, FogActions[i].ZoneInfoTag)
			{
				ZI.bDistanceFog = true;
				ZI.DistanceFogColor = FogActions[i].DistanceFogColor;
				ZI.DistanceFogStart = FogActions[i].DistanceFogStart;
				ZI.DistanceFogEnd = FogActions[i].DistanceFogEnd;
				
				iAppliedCount++;
			}
		}
	}
	
	if(PatchesToApply.bFixSteedsDoubleJump) // Steed Double Jump Fix
	{
		foreach DynamicActors(class'Steed', S)
		{
			S.fDoubleJumpHeight = 128.0;
			S.SetJumpVars();
			
			iAppliedCount++;
		}
	}
	
	if(PatchesToApply.bMakePIBTakeFactoryFallDamage) // PIB Factory Fall Damage
	{
		foreach DynamicActors(class'PIB', P)
		{
			P.DeathIfFallDistance = 1000.0;
			
			iAppliedCount++;
		}
	}
	
	if(iAppliedCount > 0)
	{
		Log("MGAME" @ class'MVersion'.default.Version @ "-- This level has been patched with the DevKit Patcher, made by Master_64 --" @ string(iAppliedCount) @ "patches applied");
	}
	
	self.Destroy();
}


defaultproperties
{
	PressureVolumeTag=PressureVolume
	ShimmyPipeTag=StaticMeshActorShimmy
	bStatic=false
}