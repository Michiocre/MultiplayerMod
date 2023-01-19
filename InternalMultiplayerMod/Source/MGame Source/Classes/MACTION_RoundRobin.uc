// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Emulates a physical RoundRobin actor
// In addition to the default RoundRobin, you can customize how many times it will loop


class MACTION_RoundRobin extends ScriptedAction
	Config(MGame);


enum ERoundType
{
	RT_Once,  // A round robin that only works for a single loop
	RT_Loop,  // A round robin that loops indefinitely
	RT_Loop_X // A round robin that loops X amount of times
};

var(Action) MACTION_RoundRobin.ERoundType RoundRobinType; // Which RoundRobin type should be used for this action
var(Action) array<int> ActionNums;						  // The array of all ActionNums that can be gone to (in order). Think of this as GotoAction, where it will pick to Goto a certain action
var(Action) int EndActionNum; 							  // Which action to go to once the round robin is complete (if the type of RoundRobinType is not loop)
var(Action) int LoopIterations; 						  // If the type is Loop X, how many times should we loop before the loop ends
var int CurrentActionNum; 								  // The current action number we're on (also known as the counter, since this is a RoundRobin)
var int LoopCount;										  // How many loops have occurred

function ProceedToNextAction(ScriptedController C)
{
	CurrentActionNum++;
	
	switch(RoundRobinType)
	{
		case RT_Once:
			if(CurrentActionNum < ActionNums.Length)
			{
				C.ActionNum = ActionNums[CurrentActionNum];
			}
			else
			{
				C.ActionNum = EndActionNum;
			}
			
			break;
		case RT_Loop:
			if((1 + CurrentActionNum) > ActionNums.Length)
			{
				CurrentActionNum = 0;
			}
			
			C.ActionNum = ActionNums[CurrentActionNum];
			
			break;
		case RT_Loop_X:
			if((1 + CurrentActionNum) > ActionNums.Length && LoopCount <= LoopIterations)
			{
				CurrentActionNum = 0;
				LoopCount++;
			}
			
			if(LoopCount > LoopIterations)
			{
				C.ActionNum = EndActionNum;
			}
			else
			{
				C.ActionNum = ActionNums[CurrentActionNum];
			}
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed RoundRobinType; going to EndActionNum");
			
			C.ActionNum = EndActionNum;
			
			break;
	}
}

function string GetActionString()
{
	switch(RoundRobinType)
	{
		case RT_Once:
			return ActionString @ "-- Once";
			
			break;
		case RT_Loop:
			return ActionString @ "-- Loop";
			
			break;
		case RT_Loop_X:
			return ActionString @ "-- Loop X amount of times";
			
			break;
		default:
			Warn(ActionString @ "-- Default case triggered due to malformed RoundRobinType; aborting process");
			
			return ActionString @ "-- RoundRobinType is malformed; cannot report with debug info";
			
			break;
	}
}


defaultproperties
{
	CurrentActionNum=-1 // This needs to be -1 from the start so that this represents the actual ActionNum (since the first ActionNum is always 0)
	LoopIterations=1
	ActionString="Round Robin"
}