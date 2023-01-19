// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A timer that starts upon spawning into a level
// This is helpful for when you need to run a local timer or when you need the total amount of time a level has been running for


class MTimer extends MKeypoint
	Config(MGame);


#exec TEXTURE IMPORT NAME=MTimer FILE=Textures\MTimer.tga FLAGS=2


var() float TimerEndTime; 	// What time the timer should end at. Has an accuracy of within a tenth of a seconds
var float TimeElapsed; 		// How much time has passed since the map has loaded. Has an accuracy of within the tenths of seconds
var() name TimerEndEvent; 	// What event should be fired to upon the timer ending
var() bool bUnlimitedTimer; // If true, will act as an actor containing the level's in-game timer and will not fire to the event provided. IfGetProp and TransferProp can get the value of this actor


auto state StartTimer
{
	function Timer() // Gets fired to every 0.1 seconds as determined by SetTimer()
	{
		TimeElapsed += 0.1; // Adds 0.1 to <TimeElapsed>
		
		if(!bUnlimitedTimer && TimeElapsed >= TimerEndTime) // Checks if the time that has elapsed has surpassed <TimerEndTime>. If <bUnlimitedTimer> is true, this check will be disregarded
		{
			SetTimer(0, false); 												   // Stops the timer
			TriggerEvent(TimerEndEvent, none, none);							   // Triggers the event <TimerEndEvent>
			Log("MTimer -- Executing event. Time elapsed:" @ string(TimeElapsed)); // 
			self.Destroy();														   // Destroys the actor
		}
	}
	
Begin:
	SetTimer(0.1, true); // Starts the timer that ticks every 0.1 seconds
	
	stop;
}


defaultproperties
{
	TimerEndTime=30
	bStatic=false
	Texture=Texture'MTimer'
}