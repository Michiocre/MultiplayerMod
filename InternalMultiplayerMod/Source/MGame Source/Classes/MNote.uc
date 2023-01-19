// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// A better version of the Note actor that takes multiple lines
// Convenient for to-do lists built straight into the map's file


class MNote extends Note
	Config(MGame);


var() array<string> Notes; // All of the notes