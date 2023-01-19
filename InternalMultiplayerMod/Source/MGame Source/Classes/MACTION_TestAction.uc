// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Test


class MACTION_TestAction extends ScriptedAction
	Config(MGame);


var	Pawn ICP;
var	Pawn PHA;


function bool InitActionFor(ScriptedController C)
{
	GetPHA(C);
	SetPropertyText("ICP", C.Level.GetPropertyText("InventoryCarrierPawn"));
	
	Log(string(PHA));
	Log(string(ICP));
	
	Log(string(shpawn(ICP).GetInventoryCount('Coin')));
	PHA.Controller.ConsoleCommand("Ghost");
	
	return false;
}

function GetPHA(ScriptedController C)
{
	SetPropertyText("PHA", C.Level.GetPropertyText("PlayerHeroActor"));
}

function string GetActionString()
{
	return ActionString;
}


defaultproperties
{
	ActionString="Test"
}