// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Makes any specified enemies run away


class MACTION_EnemyRunAway extends ScriptedAction
	Config(MGame);


var(Action) bool bBanditsRunAway;  // If true, causes all bandits to run away
var(Action) bool bPeasantsRunAway; // If true, causes all peasants to run away
var(Action) bool bElvesRunAway;    // If true, causes all elves to run away
var(Action) bool bKnightsRunAway;  // If true, causes all knights to run away
var(Action) bool bBatsFlyAway;     // If true, causes all bats to fly away


function bool InitActionFor(ScriptedController C)
{
	local Bandit B;
	local Peasant P;
	local Elf E;
	local Knight K;
	local MilkKnight MK;
	local MongoKnight MNK;
	local Bat BT;
	
	if(bBanditsRunAway)
	{
		foreach C.DynamicActors(class'Bandit', B)
		{
			CombatController(B.Controller).GotoState('ReturnHome');
		}
	}
	
	if(bPeasantsRunAway)
	{
		foreach C.DynamicActors(class'Peasant', P)
		{
			CombatController(P.Controller).GotoState('ReturnHome');
		}
	}
	
	if(bElvesRunAway)
	{
		foreach C.DynamicActors(class'Elf', E)
		{
			CombatController(E.Controller).GotoState('ReturnHome');
		}
	}
	
	if(bKnightsRunAway)
	{
		foreach C.DynamicActors(class'Knight', K)
		{
			CombatController(K.Controller).GotoState('ReturnHome');
		}
		
		foreach C.DynamicActors(class'MilkKnight', MK)
		{
			ShEnemyController(MK.Controller).GotoState('ReturnToSpawn');
		}
		
		foreach C.DynamicActors(class'MongoKnight', MNK)
		{
			ShEnemyController(MNK.Controller).GotoState('ReturnToSpawn');
		}
	}
	
	if(bBatsFlyAway)
	{
		foreach C.DynamicActors(class'Bat', BT)
		{
			BatController(BT.Controller).GotoState('FlyToHome');
		}
	}
	
	return false;
}

function string GetActionString()
{
	return ActionString @ "-- Making enemies run away";
}


defaultproperties
{
	bBanditsRunAway=true
	bPeasantsRunAway=true
	bElvesRunAway=true
	bKnightsRunAway=true
	bBatsFlyAway=true
	ActionString="Enemy Run Away"
}