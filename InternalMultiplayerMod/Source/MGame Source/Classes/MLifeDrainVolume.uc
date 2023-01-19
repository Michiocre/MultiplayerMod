// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Drains the main player's health over a period of
// time while the player remains inside the volume


class MLifeDrainVolume extends Volume
	Config(MGame);


var() float fDamageRate;   // How often to hurt the player in seconds
var() float fHurtAmount;   // How much to hurt the player each time
var() bool bHealInstead;   // If true, heals the player instead of hurting the player
var() bool bTakeKnockback; // If true, the player will take knockback on each damage
var Actor Player;		   // A temporary reference for the player's actor
var	Pawn ICP;			   // A temporary inventory carrier pawn reference


event Touch(Actor Other)
{
	if(KWHeroController(Pawn(Other).Controller) == KWGame(Level.Game).GetHeroController())
	{
		Player = Other;
		
		SetTimer(fDamageRate, true);
	}
}

event Untouch(Actor Other)
{
	if(KWHeroController(Pawn(Other).Controller) == KWGame(Level.Game).GetHeroController())
	{
		Player = none;
		
		SetTimer(0.0, false);
	}
}

event Timer()
{
	local PlayerController PC;
	
	PC = KWGame(Level.Game).GetHeroController();
	
	if(Player == none)
	{
		return;
	}
	
	if(!bHealInstead)
	{ 
		Player.SetPropertyText("Health", string(float(Player.GetPropertyText("Health")) - fHurtAmount));
	}
	else
	{
		SetPropertyText("ICP", Level.GetPropertyText("InventoryCarrierPawn"));
		
		if(ICP != none && ICP.IsA('KWPawn'))
		{
			Player.SetPropertyText("Health", string(FClamp(float(Player.GetPropertyText("Health")) + fHurtAmount, 0.0, 100.0 * (KWPawn(ICP).GetInventoryCount('Shamrock') + 1))));
		}
		else
		{
			Player.SetPropertyText("Health", string(FClamp(float(Player.GetPropertyText("Health")) + fHurtAmount, 0.0, 100.0)));
		}
	}
	
	if(Player.IsA('SHHeroPawn'))
	{
		if(bTakeKnockback && !(float(ShHeroPawn(Player).GetPropertyText("Health")) <= 0.0) && ShHeroPawn(Player).IsInState('StateIdle'))
		{
			SHHeroPawn(Player).GoToStateKnock(false);
		}
		
		if(float(Player.GetPropertyText("Health")) <= 0.0 && (!ShHeroPawn(Player).AmInvunerable && !PC.bGodMode))
		{
			Player = none;
			PC.ConsoleCommand("Suicide");
		}
	}
}

defaultproperties
{
	fDamageRate=0.1
	fHurtAmount=2.0
	bStatic=false
}