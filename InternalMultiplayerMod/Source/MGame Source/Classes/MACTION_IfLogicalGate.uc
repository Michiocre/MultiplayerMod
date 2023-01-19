// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Use 1 of the 8 common logic gates as a condition
// Takes 2 inputs, both being a TriggeredCondition
// Returns true if the logic gate type returns true


class MACTION_IfLogicalGate extends ScriptedAction
	Config(MGame);


enum ELogicType
{
	LT_Buffer, // Buffer Gate
	LT_NOT,    // NOT Gate
	LT_AND,    // AND Gate
	LT_OR, 	   // OR Gate
	LT_NAND,   // NAND Gate
	LT_NOR,    // NOR Gate
	LT_XOR,    // XOR Gate
	LT_XNOR    // XNOR Gate
};

var(Action) MACTION_IfLogicalGate.ELogicType LogicGateType; // Which logic gate type should be used for this condition
var(Action) name TriggeredConditionTags[2]; 				// Which two condition tags should the code search for? If using a buffer gate or a NOT gate, the second tag will be ignored


function ProceedToNextAction(ScriptedController C)
{
	local TriggeredCondition T;
	local int i, TriggeredConditionTagStates[2];
	local bool b1, b2;
	
	C.ActionNum++;
	
	for(i = 0; i < 2; i++) // Executes this block of code twice. Each time this block of code is run, we get the state of bEnabled for each of the two TriggeredCondition's and write it to <TriggeredConditionTagStates>
	{
		foreach C.DynamicActors(class'TriggeredCondition', T, TriggeredConditionTags[i])
		{
			TriggeredConditionTagStates[i] = int(T.bEnabled); // Converting this Bool to an Int since UE2 doesn't allow booleans in arrays (Why UE2?)
		}
	}
	
	// Simplifying these two boolean calls majorly (for readability)
	b1 = bool(TriggeredConditionTagStates[0]);
	b2 = bool(TriggeredConditionTagStates[1]);
	
	switch(LogicGateType)
	{
		case LT_Buffer:
			if(b1)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_NOT:
			if(!b1)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_AND:
			if(b1 && b2)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_OR:
			if(b1 || b2)
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_NAND:
			if(!(b1 && b2))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_NOR:
			if(!(b1 || b2))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_XOR:
			if(!(b1 && b2) && (b1 || b2))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		case LT_XNOR:
			if(!(!(b1 && b2) && (b1 || b2)))
			{
				break;
			}
			else
			{
				ProceedToSectionEnd(C);
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed LogicGateType; returning with false");
			
			ProceedToSectionEnd(C);
			
			break;
	}
}

function string GetActionString()
{
	switch(LogicGateType)
	{
		case LT_Buffer:
			return ActionString @ "-- Buffer Gate";
			
			break;
		case LT_NOT:
			return ActionString @ "-- NOT Gate";
			
			break;
		case LT_AND:
			return ActionString @ "-- AND Gate";
			
			break;
		case LT_OR:
			return ActionString @ "-- OR Gate";
			
			break;
		case LT_NAND:
			return ActionString @ "-- NAND Gate";
			
			break;
		case LT_NOR:
			return ActionString @ "-- NOR Gate";
			
			break;
		case LT_XOR:
			return ActionString @ "-- XOR Gate";
			
			break;
		case LT_XNOR:
			return ActionString @ "-- XNOR Gate";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed LogicGateType; returning with false");
			
			return ActionString @ "-- LogicGateType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	ActionString="If Logical Gate"
}