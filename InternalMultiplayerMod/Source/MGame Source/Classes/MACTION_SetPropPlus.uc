// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Sets a variable to a specific value on a specific actor... or does virtually anything related to this
// Do be wary that if you don't know what you're doing that you likely shouldn't use this action
// Also, this action is very, VERY complex and not that intuitive (maybe I can make it better in the future?)
// There is an extreme amount of customization this action has; read below to learn more
//
// Main Features:
// - Set Property (or random)
// - Add/Multiply Property (or random)
// - Transfer Property
// - Set State, Collision, Collision Size, DrawScale, DrawScale 3D, Static Mesh, Draw Type, Location, Rotation or Physics
// - Save or Load global data (via TransferProp)
//
// All features can be heavily customized and most options will work with each other
// 
// Features that are outside the scope of this action:
// - Array data types (however, you can typically get/set the first entry in an array)
// - Taking a string with vector or rotator data from a TransferProp and setting the location (or rotation) of another actor with that data (however, you can still apply this to other vector or rotator values; just not location and rotation)
// 
// Keywords:
// SetPropActions[i].<ActorTag> or SetPropActions[i].ActorProps.TransferProp.<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_SetPropPlus extends ScriptedAction
	Config(MGlobalData);


enum ESetPropType
{
	ST_Default, 		 // SetProp Default (should be used for all general SetProp uses)
	ST_SetState, 		 // SetProp Set State
	ST_SetCollision, 	 // SetProp Set Collision Flags
	ST_SetCollisionSize, // SetProp Set Collision Size
	ST_SetDrawScale, 	 // SetProp Set DrawScale
	ST_SetDrawScale3D, 	 // SetProp Set DrawScale 3D
	ST_SetStaticMesh, 	 // SetProp Set Static Mesh
	ST_SetDrawType, 	 // SetProp Set Draw Type
	ST_SetLocation, 	 // SetProp Set Location
	ST_SetRotation, 	 // SetProp Set Rotation
	ST_SetLocAndRot, 	 // SetProp Set Location and Rotation
	ST_SetPhysics 		 // SetProp Set Physics
};

enum ELogicType // All types of logic to be applied when setting the property
{
	LT_SetProp, 	// SetProp Type (sets a variable to a value)
	LT_SetPropRand, // SetProp Random Type (same as above, but the value is within a random range)
	LT_AddProp, 	// AddProp (adds a variable to a value)
	LT_AddPropRand, // AddProp Random Type (same as above, but the value is within a random range)
	LT_TransferProp // TransferProp Type (transfers a value from a variable from a certain actor, then applies that data to the variable on another actor with the obtained value)
};

enum EVarPull // If using TransferProp and bTransferProp_PullSpecificVar = true, which individual variable should be transferred
{
	VP_All, 	  // Var Pull All
	VP_Loc_X, 	  // Var Pull Location X
	VP_Loc_Y, 	  // Var Pull Location Y
	VP_Loc_Z, 	  // Var Pull Location Z
	VP_Rot_Pitch, // Var Pull Rotation Pitch
	VP_Rot_Yaw,   // Var Pull Rotation Yaw
	VP_Rot_Roll   // Var Pull Rotation Roll
};

struct LocAndRotStruct // If SetLocation or SetRotation is being used as a SetProp type
{
	var() vector SetLocation;  // What location to set
	var() rotator SetRotation; // What rotation to set
};

struct SetCollisionStruct // If SetCollision is being used as a SetProp type
{
	var() bool bNewCollideActors; // What value to assign to bCollideActors
	var() bool bNewBlockActors;   // What value to assign to bBlockActors
	var() bool bNewBlockPlayers;  // What value to assign to bBlockPlayers
};

struct SetCollisionSizeStruct // If SetCollisionSize is being used as a SetProp type
{
	var() float NewCollisionRadius; // What value to assign to CollisionRadius
	var() float NewCollisionHeight; // What value to assign to CollisionHeight
};

struct RandStruct // If using a SetProp type that uses randomness
{
	var() string Min; // The minimum random value
	var() string Max; // The maximum random value
};

enum ERandType // If using a SetProp type that uses randomness
{
	RT_BOOL, // Random Bool
	RT_INT,  // Random Int
	RT_FLOAT // Random Float
};

struct RandVarStruct // If using a SetProp type that uses randomness
{
	var() MACTION_SetPropPlus.ERandType RandType; // What data type is going to be used during this randomization
	var() RandStruct MinMaxValues;				  // What random min-max values to use
};

struct TransferPropStruct // If using TransferProp
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct OptionalVarsStruct
{
	var() RandVarStruct RandomVars; 								 // All variables that are used when using a Rand variant of a SetProp
	var() TransferPropStruct TransferProp; 							 // The Gets required for a TransferProp to work
	var() name PlayerState; 										 // What state will be set
	var() bool bControllerContext; 									 // Should the SetProp use the actor's variables or the controller's variables (controller variables are only available on pawns that have controllers)
	var() SetCollisionStruct SetCollision; 							 // What collision flags to set
	var() SetCollisionSizeStruct SetCollisionSize;					 // What collision size to set
	var() float SetDrawScale; 										 // What DrawScale to set
	var() vector SetDrawScale3D; 									 // What ScaleScale3D to set
	var() StaticMesh SetStaticMesh; 								 // What static mesh to set
	var() Actor.EDrawType SetDrawType; 								 // What draw type to set
	var() LocAndRotStruct SetLocAndRot;								 // What location, rotation, or both to set
	var() Actor.EPhysics SetPhysics; 								 // What physics to set
	var() bool bAddProp_MultiplyInstead; 							 // Should we multiply instead (if using AddProp type)
	var() bool bTransferProp_Save; 									 // Should TransferProp do a save or load of global data
	var() bool bTransferProp_GetCurrentGameSlot;					 // If true, gets the current game slot to save/load to
	var() bool bTransferProp_PullSpecificVar;						 // Should a specific variable be pulled from a variable when transferring? This is specifically for the pawn's location vector and rotator and assigning an individual value to a float or int
	var() bool bTransferProp_SetLocOrRotFromOneValue;				 // Depending on the PullSpecificVar, will target said variable and set it
	var() MACTION_SetPropPlus.EVarPull TransferProp_PullSpecificVar; // What specific variable from a variable should be pulled? Example: Pulling variable 2 from a vector would return with its Y value and assign it
	var() MGlobalData.EManageType TransferProp_ManageDataType;		 // What kind of data transfer should be done
	var() MGlobalData.EDataType TransferProp_DataType;				 // What kind of data is going to be transferred
	var() int TransferProp_SaveSlot;								 // What slot should the data be transferred to or from
};

struct SetPropStruct
{
	var() MACTION_SetPropPlus.ELogicType LogicType;		// What logic should be applied when setting the property
	var() MACTION_SetPropPlus.ESetPropType SetPropType;	// What type of setting should be done when setting the property
	var() class<Actor> ActorClass; 						// What actor class should be located
	var() name ActorTag; 								// What actor tag should be located
	var() string Variable; 								// What variable on the located actor should be changed (LogicType and SetPropType can override this with its own variables)
	var() string Value; 								// What value on the located actor should be changed (LogicType and SetPropType can override this with its own variables)
	var() OptionalVarsStruct ActorProps;				// What optional variables should be used (should the LogicType and SetPropType need it)
};

var(Action) array<SetPropStruct> SetPropActions; // The list of actions that should be gone through
var(Action) bool bPickRandom;					 // If true, picks a random action to execute
var Pawn HP;									 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor, TargetActor2;
	local string sValue;
	local bool b1, b2, b3;
	local int i, i1, i2, i3, RandInt, RandInt1, RandInt2, RandInt3;
	local float f1, f2, RandFloat, RandFloat1, RandFloat2;
	local vector v1;
	local rotator r1, r2;
	local class<Actor> TempActorClass1, TempActorClass2;
	local name TempActorTag1, TempActorTag2;
	
	for(i = 0; i < SetPropActions.Length; i++) // Executes a SetProp action and continues going through the list until the list is finished
	{
		if(bPickRandom)
		{
			i = Rand(SetPropActions.Length);
		}
		
		if(SetPropActions[i].ActorTag == 'CurrentPlayer')
		{
			GetHeroPawn(C);
			
			if(HP == none)
			{
				Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
				
				return false;
			}
			
			TempActorClass1 = HP.Class;
			TempActorTag1 = HP.Tag;
		}
		else
		{
			TempActorClass1 = SetPropActions[i].ActorClass;
			TempActorTag1 = SetPropActions[i].ActorTag;
		}
		
		if(SetPropActions[i].ActorProps.TransferProp.GetActorTag == 'CurrentPlayer')
		{
			GetHeroPawn(C);
			
			if(HP == none)
			{
				Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
				
				return false;
			}
			
			TempActorClass2 = HP.Class;
			TempActorTag2 = HP.Tag;
		}
		else
		{
			TempActorClass2 = SetPropActions[i].ActorProps.TransferProp.GetActorClass;
			TempActorTag2 = SetPropActions[i].ActorProps.TransferProp.GetActorTag;
		}
		
		if(TempActorClass1 == none && TempActorClass2 != none)
		{
			TempActorClass1 = TempActorClass2;
			TempActorTag1 = TempActorTag2;
		}
		
		if(TempActorClass1 == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
			
			continue;
		}
		
		foreach C.AllActors(TempActorClass1, TargetActor, TempActorTag1)
		{
			switch(SetPropActions[i].SetPropType)
			{
				case ST_Default:
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							if(!SetPropActions[i].ActorProps.bControllerContext)
							{
								TargetActor.SetPropertyText(SetPropActions[i].Variable, SetPropActions[i].Value);
							}
							else
							{
								Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, SetPropActions[i].Value);
							}
							
							break;
						case LT_SetPropRand:
							i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
							i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
							f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
							f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
							i3 = i2 - i1;
							
							switch(SetPropActions[i].ActorProps.RandomVars.RandType)
							{
								case RT_BOOL:
									RandInt = (Rand(i3) + i1);
									
									b1 = bool(RandInt);
									
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										TargetActor.SetPropertyText(SetPropActions[i].Variable, string(b1));
									}
									else
									{
										Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(b1));
									}
									
									break;
								case RT_INT:
									RandInt = (Rand(i3) + i1);
									
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										TargetActor.SetPropertyText(SetPropActions[i].Variable, string(RandInt));
									}
									else
									{
										Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(RandInt));
									}
									
									break;
								case RT_FLOAT:
									RandFloat = RandRange(f1, f2);
									
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										TargetActor.SetPropertyText(SetPropActions[i].Variable, string(RandFloat));
									}
									else
									{
										Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(RandFloat));
									}
									
									break;
								default:
									Warn(ActionString @ "-- Default case triggered due to malformed RandType; aborting process");
									
									break;
							}
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								if(!SetPropActions[i].ActorProps.bControllerContext)
								{
									TargetActor.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + float(SetPropActions[i].Value)));
								}
								else
								{
									Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + float(SetPropActions[i].Value)));
								}
							}
							else
							{
								if(!SetPropActions[i].ActorProps.bControllerContext)
								{
									TargetActor.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * float(SetPropActions[i].Value)));
								}
								else
								{
									Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * float(SetPropActions[i].Value)));
								}
							}
							
							break;
						case LT_AddPropRand:
							i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
							i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
							f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
							f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
							i3 = i2 - i1;
							
							switch(SetPropActions[i].ActorProps.RandomVars.RandType)
							{
								case RT_BOOL:
									RandInt = (Rand(i3) + i1);
									
									b1 = bool(RandInt);
									
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										TargetActor.SetPropertyText(SetPropActions[i].Variable, string(b1));
									}
									else
									{
										Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(b1));
									}
									
									break;
								case RT_INT:	
									RandInt = (Rand(i3) + i1);
									
									if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
									{
										if(!SetPropActions[i].ActorProps.bControllerContext)
										{
											TargetActor.SetPropertyText(SetPropActions[i].Variable, string(int(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + RandInt));
										}
										else
										{
											Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(int(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + RandInt));
										}
									}
									else
									{
										if(!SetPropActions[i].ActorProps.bControllerContext)
										{
											TargetActor.SetPropertyText(SetPropActions[i].Variable, string(int(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * RandInt));
										}
										else
										{
											Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(int(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * RandInt));
										}
									}
									
									break;
								case RT_FLOAT:
									RandFloat = RandRange(f1, f2);
									
									if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
									{
										if(!SetPropActions[i].ActorProps.bControllerContext)
										{
											TargetActor.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + RandFloat));
										}
										else
										{
											Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) + RandFloat));
										}
									}
									else
									{
										if(!SetPropActions[i].ActorProps.bControllerContext)
										{
											TargetActor.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * RandFloat));
										}
										else
										{
											Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(float(TargetActor.GetPropertyText(SetPropActions[i].Variable)) * RandFloat));
										}
									}
									
									break;
								default:
									Warn(ActionString @ "-- Default case triggered due to malformed RandType; aborting process");
									
									break;
							}
							
							break;
						case LT_TransferProp:
							if(SetPropActions[i].ActorProps.TransferProp_ManageDataType == MT_LoadData)
							{
								if(!SetPropActions[i].ActorProps.bControllerContext)
								{
									TargetActor.SetPropertyText(SetPropActions[i].Variable, class'MGlobalData'.static.LoadGlobalData(SetPropActions[i].ActorProps.TransferProp_DataType, SetPropActions[i].ActorProps.TransferProp_SaveSlot, SetPropActions[i].ActorProps.bTransferProp_GetCurrentGameSlot));
								}
								else
								{
									Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, class'MGlobalData'.static.LoadGlobalData(SetPropActions[i].ActorProps.TransferProp_DataType, SetPropActions[i].ActorProps.TransferProp_SaveSlot, SetPropActions[i].ActorProps.bTransferProp_GetCurrentGameSlot));
								}
								
								break;
							}
							else if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								if(!SetPropActions[i].ActorProps.bTransferProp_Save)
								{
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										switch(SetPropActions[i].ActorProps.TransferProp_PullSpecificVar)
										{
											case VP_All:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
												
												break;
											case VP_Loc_X:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.X));
												
												break;
											case VP_Loc_Y:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.Y));
												
												break;
											case VP_Loc_Z:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.Z));
												
												break;
											case VP_Rot_Pitch:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Pitch));
												
												break;
											case VP_Rot_Yaw:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Yaw));
												
												break;
											case VP_Rot_Roll:
												TargetActor.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Roll));
												
												break;
											default:
												Warn(ActionString @ "-- Default case triggered due to malformed TransferProp_PullSpecificVar; aborting process");
												
												break;
										}
									}
									else
									{
										switch(SetPropActions[i].ActorProps.TransferProp_PullSpecificVar)
										{
											case VP_All:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
												
												break;
											case VP_Loc_X:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.X));
												
												break;
											case VP_Loc_Y:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.Y));
												
												break;
											case VP_Loc_Z:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Location.Z));
												
												break;
											case VP_Rot_Pitch:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Pitch));
												
												break;
											case VP_Rot_Yaw:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Yaw));
												
												break;
											case VP_Rot_Roll:
												Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, string(TargetActor2.Rotation.Roll));
												
												break;
											default:
												Warn(ActionString @ "-- Default case triggered due to malformed TransferProp_PullSpecificVar; aborting process");
												
												break;
										}
									}
								}
								else if(SetPropActions[i].ActorProps.TransferProp_ManageDataType == MT_SaveData)
								{
									if(!SetPropActions[i].ActorProps.bControllerContext)
									{
										sValue = TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable);
									}
									else
									{
										sValue = Pawn(TargetActor2).Controller.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable);
									}
									
									class'MGlobalData'.static.SaveGlobalData(SetPropActions[i].ActorProps.TransferProp_DataType, SetPropActions[i].ActorProps.TransferProp_SaveSlot, sValue, SetPropActions[i].ActorProps.bTransferProp_GetCurrentGameSlot);
								}
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetState:
					switch(SetPropActions[i].LogicType)
					{
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								if(!SetPropActions[i].ActorProps.bControllerContext)
								{
									TargetActor.GotoState(TargetActor2.GetStateName());
								}
								else
								{
									Pawn(TargetActor).Controller.GotoState(TargetActor2.GetStateName());
								}
							}
							
							break;
						default:
							if(!SetPropActions[i].ActorProps.bControllerContext)
							{
								TargetActor.GotoState(SetPropActions[i].ActorProps.PlayerState);
							}
							else
							{
								Pawn(TargetActor).Controller.GotoState(SetPropActions[i].ActorProps.PlayerState);
							}
							
							break;
					}
					
					break;
				case ST_SetCollision:
					i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
					i3 = i2 - i1;
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetCollision(SetPropActions[i].ActorProps.SetCollision.bNewCollideActors, SetPropActions[i].ActorProps.SetCollision.bNewBlockActors, SetPropActions[i].ActorProps.SetCollision.bNewBlockPlayers);
							
							break;
						case LT_SetPropRand:
							RandInt1 = (Rand(i3) + i1);
							RandInt2 = (Rand(i3) + i1);
							RandInt3 = (Rand(i3) + i1);
							
							b1 = bool(RandInt1);
							b2 = bool(RandInt2);
							b3 = bool(RandInt3);
							
							TargetActor.SetCollision(b1, b2, b3);
							
							break;
						case LT_AddProp:
							TargetActor.SetCollision(SetPropActions[i].ActorProps.SetCollision.bNewCollideActors, SetPropActions[i].ActorProps.SetCollision.bNewBlockActors, SetPropActions[i].ActorProps.SetCollision.bNewBlockPlayers);
							
							break;
						case LT_AddPropRand:
							RandInt1 = (Rand(i3) + i1);
							RandInt2 = (Rand(i3) + i1);
							RandInt3 = (Rand(i3) + i1);
							
							b1 = bool(RandInt1);
							b2 = bool(RandInt2);
							b3 = bool(RandInt3);
							
							TargetActor.SetCollision(b1, b2, b3);
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetCollision(TargetActor2.bCollideActors, TargetActor2.bBlockActors, TargetActor2.bBlockPlayers);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetCollisionSize:
					f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetCollisionSize(SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionRadius, SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionHeight);
							
							break;
						case LT_SetPropRand:
							RandFloat1 = RandRange(f1, f2);
							RandFloat2 = RandRange(f1, f2);
							
							TargetActor.SetCollisionSize(RandFloat1, RandFloat2);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetCollisionSize(TargetActor.CollisionRadius + SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionRadius, TargetActor.CollisionHeight + SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionHeight);
							}
							else
							{
								TargetActor.SetCollisionSize(TargetActor.CollisionRadius * SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionRadius, TargetActor.CollisionHeight * SetPropActions[i].ActorProps.SetCollisionSize.NewCollisionHeight);
							}
							
							break;
						case LT_AddPropRand:
							RandFloat1 = RandRange(f1, f2);
							RandFloat2 = RandRange(f1, f2);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetCollisionSize(TargetActor.CollisionRadius + RandFloat1, TargetActor.CollisionHeight + RandFloat2);
							}
							else
							{
								TargetActor.SetCollisionSize(TargetActor.CollisionRadius * RandFloat1, TargetActor.CollisionHeight * RandFloat2);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetCollisionSize(TargetActor2.CollisionRadius, TargetActor2.CollisionHeight);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetDrawScale:
					f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetDrawScale(SetPropActions[i].ActorProps.SetDrawScale);
							
							break;
						case LT_SetPropRand:
							RandFloat = RandRange(f1, f2);
							
							TargetActor.SetDrawScale(RandFloat);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawScale(TargetActor.DrawScale + SetPropActions[i].ActorProps.SetDrawScale);
							}
							else
							{
								TargetActor.SetDrawScale(TargetActor.DrawScale * SetPropActions[i].ActorProps.SetDrawScale);
							}
							
							break;
						case LT_AddPropRand:
							RandFloat = RandRange(f1, f2);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawScale(TargetActor.DrawScale + RandFloat);
							}
							else
							{
								TargetActor.SetDrawScale(TargetActor.DrawScale * RandFloat);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetDrawScale(TargetActor2.DrawScale);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetDrawScale3D:
					f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetDrawScale3D(SetPropActions[i].ActorProps.SetDrawScale3D);
							
							break;
						case LT_SetPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							TargetActor.SetDrawScale3D(v1);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawScale3D(TargetActor.DrawScale3D + SetPropActions[i].ActorProps.SetDrawScale3D);
							}
							else
							{
								TargetActor.SetDrawScale3D(TargetActor.DrawScale3D * SetPropActions[i].ActorProps.SetDrawScale3D);
							}
							
							break;
						case LT_AddPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawScale3D(TargetActor.DrawScale3D + v1);
							}
							else
							{
								TargetActor.SetDrawScale3D(TargetActor.DrawScale3D * v1);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetDrawScale3D(TargetActor2.DrawScale3D);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetStaticMesh:
					switch(SetPropActions[i].LogicType)
					{
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetStaticMesh(TargetActor2.StaticMesh);
							}
							
							break;
						default:
							TargetActor.SetStaticMesh(SetPropActions[i].ActorProps.SetStaticMesh);
							
							break;
					}
					
					break;
				case ST_SetDrawType:
					i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
					i3 = i2 - i1;
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetDrawType(SetPropActions[i].ActorProps.SetDrawType);
							
							break;
						case LT_SetPropRand:
							RandInt = (Rand(i3) + i1);
							
							TargetActor.SetDrawType(EDrawType(RandInt));
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawType(EDrawType(int(SetPropActions[i].Variable) + int(TargetActor.DrawType)));
							}
							else
							{
								TargetActor.SetDrawType(EDrawType(int(SetPropActions[i].Variable) * int(TargetActor.DrawType)));
							}
							
							break;
						case LT_AddPropRand:
							RandInt = (Rand(i3) + i1);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetDrawType(EDrawType(RandInt + int(TargetActor.DrawType)));
							}
							else
							{
								TargetActor.SetDrawType(EDrawType(RandInt * int(TargetActor.DrawType)));
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetDrawType(TargetActor2.DrawType);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetLocation:
					f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetLocation(SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
							
							break;
						case LT_SetPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							TargetActor.SetLocation(v1);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetLocation(TargetActor.Location + SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
							}
							else
							{
								TargetActor.SetLocation(TargetActor.Location * SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
							}
							
							break;
						case LT_AddPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetLocation(TargetActor.Location + v1);
							}
							else
							{
								TargetActor.SetLocation(TargetActor.Location * v1);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								if(!SetPropActions[i].ActorProps.bTransferProp_SetLocOrRotFromOneValue)
								{
									TargetActor.SetLocation(TargetActor2.Location);
								}
								else
								{
									v1 = TargetActor.Location;
									f1 = float(TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
									
									switch(SetPropActions[i].ActorProps.TransferProp_PullSpecificVar)
									{
										case VP_All:
											TargetActor.SetLocation(TargetActor2.Location);
											
											break;
										case VP_Loc_X:
											v1.x = f1;
											TargetActor.SetLocation(v1);
											
											break;
										case VP_Loc_Y:
											v1.y = f1;
											TargetActor.SetLocation(v1);
											
											break;
										case VP_Loc_Z:
											v1.z = f1;
											TargetActor.SetLocation(v1);
											
											break;
										default:
											Warn(ActionString @ "-- Default case triggered due to trying to assign a rotation on a location; aborting process");
											
											break;
									}
								}
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetRotation:
					i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
					i3 = i2 - i1;
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetRotation(SetPropActions[i].ActorProps.SetLocAndRot.SetRotation);
							
							break;
						case LT_SetPropRand:
							r1.Pitch = (Rand(i3) + i1);
							r1.Yaw = (Rand(i3) + i1);
							r1.Roll = (Rand(i3) + i1);
							
							TargetActor.SetRotation(r1);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetRotation(TargetActor.Rotation + SetPropActions[i].ActorProps.SetLocAndRot.SetRotation);
							}
							else
							{
								r1.Pitch = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Pitch * TargetActor.Rotation.Pitch;
								r1.Yaw = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Yaw * TargetActor.Rotation.Yaw;
								r1.Roll = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Roll * TargetActor.Rotation.Roll;
								
								TargetActor.SetRotation(r1);
							}
							
							break;
						case LT_AddPropRand:
							r1.Pitch = (Rand(i3) + i1);
							r1.Yaw = (Rand(i3) + i1);
							r1.Roll = (Rand(i3) + i1);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetRotation(TargetActor.Rotation + r1);
							}
							else
							{
								r2.Pitch = r1.Pitch * TargetActor.Rotation.Pitch;
								r2.Yaw = r1.Yaw * TargetActor.Rotation.Yaw;
								r2.Roll = r1.Roll * TargetActor.Rotation.Roll;
								
								TargetActor.SetRotation(r2);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								if(!SetPropActions[i].ActorProps.bTransferProp_SetLocOrRotFromOneValue)
								{
									TargetActor.SetRotation(TargetActor2.Rotation);
								}
								else
								{
									r1 = TargetActor.Rotation;
									i1 = int(TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
									
									switch(SetPropActions[i].ActorProps.TransferProp_PullSpecificVar)
									{
										case VP_All:
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Rot_Pitch:
											r1.Pitch = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Rot_Yaw:
											r1.Yaw = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Rot_Roll:
											r1.Roll = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										default:
											Warn(ActionString @ "-- Default case triggered due to trying to assign a location on a rotation; aborting process");
											
											break;
									}
								}
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetLocAndRot:
					i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
					f1 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					f2 = float(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max);
					i3 = i2 - i1;
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetLocation(SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
							TargetActor.SetRotation(SetPropActions[i].ActorProps.SetLocAndRot.SetRotation);
							
							break;
						case LT_SetPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							r1.Pitch = (Rand(i3) + i1);
							r1.Yaw = (Rand(i3) + i1);
							r1.Roll = (Rand(i3) + i1);
							
							TargetActor.SetLocation(v1);
							TargetActor.SetRotation(r1);
							
							break;
						case LT_AddProp:
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetLocation(TargetActor.Location + SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
								TargetActor.SetRotation(TargetActor.Rotation + SetPropActions[i].ActorProps.SetLocAndRot.SetRotation);
							}
							else
							{
								TargetActor.SetLocation(TargetActor.Location * SetPropActions[i].ActorProps.SetLocAndRot.SetLocation);
								
								r1.Pitch = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Pitch * TargetActor.Rotation.Pitch;
								r1.Yaw = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Yaw * TargetActor.Rotation.Yaw;
								r1.Roll = SetPropActions[i].ActorProps.SetLocAndRot.SetRotation.Roll * TargetActor.Rotation.Roll;
								
								TargetActor.SetRotation(r1);
							}
							
							break;
						case LT_AddPropRand:
							v1.x = RandRange(f1, f2);
							v1.y = RandRange(f1, f2);
							v1.z = RandRange(f1, f2);
							
							r1.Pitch = (Rand(i3) + i1);
							r1.Yaw = (Rand(i3) + i1);
							r1.Roll = (Rand(i3) + i1);
							
							if(!SetPropActions[i].ActorProps.bAddProp_MultiplyInstead)
							{
								TargetActor.SetLocation(TargetActor.Location + v1);
								TargetActor.SetRotation(TargetActor.Rotation + r1);
							}
							else
							{
								TargetActor.SetLocation(TargetActor.Location * v1);
								
								r2.Pitch = r1.Pitch * TargetActor.Rotation.Pitch;
								r2.Yaw = r1.Yaw * TargetActor.Rotation.Yaw;
								r2.Roll = r1.Roll * TargetActor.Rotation.Roll;
								
								TargetActor.SetRotation(r2);
							}
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								if(!SetPropActions[i].ActorProps.bTransferProp_SetLocOrRotFromOneValue)
								{
									TargetActor.SetLocation(TargetActor2.Location);
									TargetActor.SetRotation(TargetActor2.Rotation);
								}
								else
								{
									v1 = TargetActor.Location;
									f1 = float(TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
									
									r1 = TargetActor.Rotation;
									i1 = int(TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
									
									switch(SetPropActions[i].ActorProps.TransferProp_PullSpecificVar)
									{
										case VP_All:
											TargetActor.SetLocation(TargetActor2.Location);
											
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Loc_X:
											v1.x = f1;
											TargetActor.SetLocation(v1);
											
											r1.Pitch = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Loc_Y:
											v1.y = f1;
											TargetActor.SetLocation(v1);
											
											r1.Yaw = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										case VP_Loc_Z:
											v1.z = f1;
											TargetActor.SetLocation(v1);
											
											r1.Roll = i1;
											TargetActor.SetRotation(TargetActor2.Rotation);
											
											break;
										default:
											Warn(ActionString @ "-- Default case triggered due to trying to assign a rotation on a location; aborting process");
											
											break;
									}
								}
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				case ST_SetPhysics:
					i1 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Min);
					i2 = int(SetPropActions[i].ActorProps.RandomVars.MinMaxValues.Max) + 1;
					i3 = i2 - i1;
					
					switch(SetPropActions[i].LogicType)
					{
						case LT_SetProp:
							TargetActor.SetPhysics(SetPropActions[i].ActorProps.SetPhysics);
							
							break;
						case LT_SetPropRand:
							RandInt = (Rand(i3) + i1);
							
							TargetActor.SetPhysics(EPhysics(RandInt));
							
							break;
						case LT_AddProp:
							TargetActor.SetPhysics(EPhysics(int(SetPropActions[i].Variable) + int(TargetActor.Physics)));
							
							break;
						case LT_AddPropRand:
							RandInt = (Rand(i3) + i1);
							
							TargetActor.SetPhysics(EPhysics(RandInt + int(TargetActor.Physics)));
							
							break;
						case LT_TransferProp:
							if(TempActorClass2 == none)
							{
								Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
								
								break;
							}
							
							foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
							{
								TargetActor.SetPhysics(TargetActor2.Physics);
							}
							
							break;
						default:
							Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
							
							break;
					}
					
					break;
				default:
					Warn(ActionString @ "-- Default case triggered due to malformed SetPropType; exiting process");
					
					break;
			}
		}
		
		if(bPickRandom)
		{
			break;
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
	if(!bPickRandom)
	{
		return ActionString @ "-- Executing" @ string(SetPropActions.Length) @ "actions";
	}
	else
	{
		return ActionString @ "-- Executing a random action";
	}
}


defaultproperties
{
	ActionString="Set Prop Plus"
}