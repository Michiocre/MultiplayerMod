// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Makes a pawn start or stop following another pawn
// 
// Keywords:
// FollowActions[i].<LeaderFollowTag> -- CurrentPlayer -- Targets the current player


class MACTION_FollowPawn extends ScriptedAction
	Config(MGame);


struct FollowStruct
{
	var() class<KWPawn> LeaderClass;   // The class of the pawn who will be followed
	var() name LeaderFollowTag;		   // The tag of the pawn who will be followed
	var() class<KWPawn> FollowerClass; // The class of the pawn who will be following
	var() name FollowerTag;			   // The tag of the pawn who will be following
	var() bool bStopFollowing;		   // If true, makes the follower located stop following any pawns its currently following
};

var(Action) array<FollowStruct> FollowActions; // The list of actions that should be gone through
var(Action)	bool bPickRandom;				   // If true, will pick a random action to execute
var Pawn HP;								   // A temporary hero pawn reference


function bool InitActionFor(ScriptedController C)
{
	local int i;
	
	if(!bPickRandom)
	{
		for(i = 0; i < FollowActions.Length; i++)
		{
			FollowPawn(C, i);
		}
	}
	else
	{
		FollowPawn(C, Rand(FollowActions.Length));
	}
	
	return false;
}

function FollowPawn(ScriptedController C, int Index)
{
	local KWPawn KWP, TargetPawn1, TargetPawn2;
	local class<KWPawn> TempPawnClass;
	local name TempPawnTag;
	
	if(!FollowActions[Index].bStopFollowing)
	{
		if(FollowActions[Index].LeaderFollowTag == 'CurrentPlayer')
		{
			GetHeroPawn(C);
			
			if(HP == none)
			{
				Warn(ActionString @ "-- Hero pawn could not be found; aborting process");
				
				return;
			}
			
			if(!HP.IsA('KWPawn'))
			{
				Warn(ActionString @ "-- Hero pawn is not a KWPawn; aborting process");
				
				return;
			}
			
			KWP = KWPawn(HP);
			
			TempPawnClass = KWP.Class;
			TempPawnTag = KWP.Tag;
		}
		else
		{
			TempPawnClass = FollowActions[Index].FollowerClass;
			TempPawnTag = FollowActions[Index].FollowerTag;
		}
		
		if(TempPawnClass == none || FollowActions[Index].FollowerClass == none)
		{
			Warn(ActionString @ "-- An actor class assignment is missing; skipping action");
			
			return;
		}
		
		foreach C.DynamicActors(TempPawnClass, TargetPawn1, TempPawnTag)
		{
			break;
		}
		
		foreach C.DynamicActors(FollowActions[Index].FollowerClass, TargetPawn2, FollowActions[Index].FollowerTag)
		{
			break;
		}
		
		TargetPawn1.AddTrailingChar(TargetPawn2); // Adds a new follower for the leader
	}
	else
	{
		foreach C.DynamicActors(FollowActions[Index].FollowerClass, TargetPawn2, FollowActions[Index].FollowerTag)
		{
			break;
		}
		
		TargetPawn2.KWAIController.StopTrailingLeadChar(true); // Makes the follower stop following anyone its following currently
	}
}

function GetHeroPawn(ScriptedController C) // Gets/refreshes the hero pawn
{
	SetPropertyText("HP", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	if(!bPickRandom)
	{
		return ActionString @ "-- Executing" @ string(FollowActions.Length) @ "actions";
	}
	else
	{
		return ActionString @ "-- Executing random action";
	}
}


defaultproperties
{
	ActionString="Follow Pawn"
}