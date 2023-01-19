// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Sets a variable to a specific value on a specific actor
// If you're looking for extreme customization, use the action MACTION_SetPropPlus instead
// 
// Keywords:
// SetPropActions[i].<ActorTag> or SetPropActions[i].ActorProps.TransferProp.<GetActorTag> -- CurrentPlayer -- Targets the current player


class MACTION_SetProp extends ScriptedAction
	Config(MGlobalData);


enum ELogicType // All types of logic to be applied when setting the property
{
	LT_SetProp, 	// SetProp Type (sets a variable to a value)
	LT_SetPropRand, // SetProp Random Type (same as above, but the value is within a random range)
	LT_AddProp, 	// AddProp (adds a variable to a value)
	LT_AddPropRand, // AddProp Random Type (same as above, but the value is within a random range)
	LT_TransferProp // TransferProp Type (transfers a value from a variable from a certain actor, then applies that data to the variable on another actor with the obtained value)
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
	var() MACTION_SetProp.ERandType RandType; // What data type is going to be used during this randomization
	var() RandStruct MinMaxValues; 			  // What random min-max values to use
};

struct TransferPropStruct // If using TransferProp
{
	var() class<Actor> GetActorClass; // What actor's class to get
	var() name GetActorTag; 		  // What actor's tag to get
	var() string GetVariable; 		  // What actor's variable to get
};

struct OptionalVarsStruct
{
	var() RandVarStruct RandomVars;		   // All variables that are used when using a Rand variant of a SetProp
	var() TransferPropStruct TransferProp; // The Gets required for a TransferProp to work
	var() bool bControllerContext;		   // Should the SetProp use the actor's variables or the controller's variables (controller variables are only available on pawns that have controllers)
	var() bool bAddProp_MultiplyInstead;   // Should we multiply instead (if using AddProp type)
};

struct SetPropStruct
{
	var() MACTION_SetProp.ELogicType LogicType;	// What logic should be applied when setting the property
	var() class<Actor> ActorClass;				// What actor class should be located
	var() name ActorTag;						// What actor tag should be located
	var() string Variable;						// What variable on the located actor should be changed (LogicType can override this with its own variables)
	var() string Value;							// What value on the located actor should be changed (LogicType can override this with its own variables)
	var() OptionalVarsStruct ActorProps;		// What optional variables should be used (should the LogicType need it)
};

var(Action) array<SetPropStruct> SetPropActions; // The list of actions that should be gone through
var(Action) bool bPickRandom;					 // If true, picks a random action to execute
var Pawn HP;									 // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local Actor TargetActor, TargetActor2;
	local bool b1;
	local int i, i1, i2, i3, RandInt;
	local float f1, f2, RandFloat;
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
					if(TempActorClass2 == none)
					{
						Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
						
						break;
					}
					
					foreach C.AllActors(TempActorClass2, TargetActor2, TempActorTag2)
					{
						if(!SetPropActions[i].ActorProps.bControllerContext)
						{
							TargetActor.SetPropertyText(SetPropActions[i].Variable, TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
						}
						else
						{
							Pawn(TargetActor).Controller.SetPropertyText(SetPropActions[i].Variable, TargetActor2.GetPropertyText(SetPropActions[i].ActorProps.TransferProp.GetVariable));
						}
					}
					
					break;
				default:
					Warn(ActionString @ "-- Default case triggered due to malformed LogicType; aborting process");
					
					break;
			}
			
			break;
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
	ActionString="Set Prop"
}