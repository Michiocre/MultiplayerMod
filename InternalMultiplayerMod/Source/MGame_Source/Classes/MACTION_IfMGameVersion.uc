// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Checks what the current MGame version is
// Returns true if the MGame version is expected
// Game states must be case-sensitive (aside from caps)
// 
// Example: "v3.0.1" (use the custom console command MGameVersion to know what version you're using)


class MACTION_IfMGameVersion extends ScriptedAction
	Config(MGame);


var(Action) array<string> ExpectedMGameVersions; // Which MGame versions are expected


function ProceedToNextAction(ScriptedController C)
{
	local string MGameVersion;
	local int i;
	
	C.ActionNum++;
	
	MGameVersion = class'MVersion'.default.Version;
	
	for(i = 0; i < ExpectedMGameVersions.Length; i++)
	{
		if(Caps(ExpectedMGameVersions[i]) == Caps(MGameVersion)) // If true, the MGame version is expected
		{
			break;
		}
		
		if(i >= (ExpectedMGameVersions.Length - 1)) // If true, all expected MGame versions have been iterated through and none were what the current MGame version is
		{
			ProceedToSectionEnd(C);
		}
	}
}

function bool StartsSection()
{
	return true;
}

function string GetActionString()
{
	return ActionString @ "-- Checking if the current MGame version is expected";
}


defaultproperties
{
	ActionString="If MGame Version"
}