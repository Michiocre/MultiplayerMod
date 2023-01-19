// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// The purpose of this actor is to globally save data across levels and game restarts
// This actor is used from within other actions, such as MACTION_SetGlobalData
// Do not make this placeable or force this actor to be physically in the map, as it's completely pointless
// 
// Important notice: always treat saved vectors and rotators as strings in other actions, as they're technically strings due to engine limitations
// 
// The expected format for all provided values (somewhat strict)
// Bool: "True", "False", "1", "0"
// Int: "64"
// Float: "64.0"
// String: "String"
// Vector: "(X=16.0,Y=32.0,Z=64.0)"
// Rotator: "(Roll=16,Pitch=32,Yaw=64)"


class MGlobalData extends Actor
	Notplaceable
	Config(MGlobalData);


enum EManageType
{
	MT_SaveData, // Save data
	MT_LoadData  // Load data
};

enum EDataType
{
	DT_Bool,   // Data is a Bool
	DT_Int,	   // Data is an Int
	DT_Float,  // Data is a Float
	DT_String, // Data is a String
	DT_Vector, // Data is a Vector
	DT_Rotator // Data is a Rotator
};

var config array<int> bGlobal;
var config array<int> iGlobal;
var config array<float> fGlobal;
var config array<string> sGlobal;
var config array<string> vGlobal;
var config array<string> rGlobal;
var config array<int> invGlobal;


static function SaveGlobalData(EDataType DataType, int Slot, string Value, bool bGetCurrentGameSlot) // Saves all types of global data
{
	Slot = Clamp(Abs(Slot), 0, 9998);
	
	if(bGetCurrentGameSlot)
	{
		Slot = class'ShFEGUIPage'.default.GameSlot;
	}
	
	switch(DataType)
	{
		case DT_Bool:
			class'MGlobalData'.default.bGlobal[Slot] = int(bool(Value));
			
			break;
		case DT_Int:
			class'MGlobalData'.default.iGlobal[Slot] = int(Value);
			
			break;
		case DT_Float:
			class'MGlobalData'.default.fGlobal[Slot] = float(Value);
			
			break;
		case DT_String:
			class'MGlobalData'.default.sGlobal[Slot] = Value;
			
			break;
		case DT_Vector:
			class'MGlobalData'.default.vGlobal[Slot] = Value;
			
			break;
		case DT_Rotator:
			class'MGlobalData'.default.rGlobal[Slot] = Value;
			
			break;
		default:
			Warn("MGlobalData -- Default case triggered due to malformed DataType; aborting process");
			
			break;
	}
	
	class'MGlobalData'.static.staticSaveConfig();
}

static function string LoadGlobalData(EDataType DataType, int Slot, bool bGetCurrentGameSlot) // Loads all types of global data
{
	Slot = Clamp(Abs(Slot), 0, 9998);
	
	if(bGetCurrentGameSlot)
	{
		Slot = class'ShFEGUIPage'.default.GameSlot;
	}
	
	switch(DataType)
	{
		case DT_Bool:
			return string(class'MGlobalData'.default.bGlobal[Slot]);
			
			break;
		case DT_Int:
			return string(class'MGlobalData'.default.iGlobal[Slot]);
			
			break;
		case DT_Float:
			return string(class'MGlobalData'.default.fGlobal[Slot]);
			
			break;
		case DT_String:
			return class'MGlobalData'.default.sGlobal[Slot];
			
			break;
		case DT_Vector:
			return class'MGlobalData'.default.vGlobal[Slot];
			
			break;
		case DT_Rotator:
			return class'MGlobalData'.default.rGlobal[Slot];
			
			break;
		default:
			Warn("MGlobalData -- Default case triggered due to malformed DataType; aborting process");
			
			break;
	}
}

static function SaveInvGlobalData(int Slot, array<int> Values, bool bGetCurrentGameSlot) // Saves an inventory's data (coin total and all potion totals)
{
	local int i;
	
	Slot = Clamp(Abs(Slot), 0, 9998);
	
	if(Values.Length != 10)
	{
		Warn("MGlobalData -- Missing arguments for saving inventory; aborting process");
		
		return;
	}
	
	if(bGetCurrentGameSlot)
	{
		Slot = class'ShFEGUIPage'.default.GameSlot;
	}
	
	for(i = 0; i < 10; i++)
	{
		class'MGlobalData'.default.invGlobal[((Slot * 10) + i)] = Values[i];
	}
	
	class'MGlobalData'.static.staticSaveConfig();
}

static function array<int> LoadInvGlobalData(int Slot, bool bGetCurrentGameSlot) // Loads an inventory's data (coin total and all potion totals)
{
	local array<int> ReturnInts;
	local int i;
	
	Slot = Clamp(Abs(Slot), 0, 9998);
	
	if(bGetCurrentGameSlot)
	{
		Slot = class'ShFEGUIPage'.default.GameSlot;
	}
	
	for(i = 0; i < 10; i++)
	{
		ReturnInts[i] = class'MGlobalData'.default.invGlobal[((Slot * 10) + i)];
	}
	
	return ReturnInts;
}

static function ResetGlobalData() // Takes all saved data and completely erases all of it
{
	// Creates new empty arrays
	local array<int> iErase;
	local array<float> fErase;
	local array<string> sErase;
	
	// Makes all arrays equal the empty arrays (therefore resetting them)
	class'MGlobalData'.default.bGlobal = iErase;
	class'MGlobalData'.default.iGlobal = iErase;
	class'MGlobalData'.default.fGlobal = fErase;
	class'MGlobalData'.default.sGlobal = sErase;
	class'MGlobalData'.default.vGlobal = sErase;
	class'MGlobalData'.default.rGlobal = sErase;
	class'MGlobalData'.default.invGlobal = iErase;
	
	// Applies the change
	class'MGlobalData'.static.staticSaveConfig();
}