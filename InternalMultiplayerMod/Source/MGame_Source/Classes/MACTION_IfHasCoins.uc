// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Acts as a coin shop condition
// Returns true if the current player has enough coins (the Price amount)


class MACTION_IfHasCoins extends ScriptedAction
	Config(MGame);


var(Action) int Price; // The amount of coins needed to return true


function ProceedToNextAction(ScriptedController C)
{
	C.ActionNum++;
	
	if(!IfHasCoins(C))
	{
		ProceedToSectionEnd(C);
	}
}

function bool IfHasCoins(ScriptedController C)
{
	local CoinCollection CC;
	
	KWGame(C.Level.Game).GetHeroController().ConsoleCommand("AddCoins 0");
	
	foreach C.DynamicActors(class'CoinCollection', CC)
	{
		if(CC.iNumItems >= Price) // Checks whether the current player has enough coins to purchase the item
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Checking if the player has at least" @ string(Price) @ "coins";
}


defaultproperties
{
	Price=64
	ActionString="If Has Coins"
}