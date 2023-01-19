// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// Stores local data inside of itself
// This actor should be used in conjunction with MACTION_SetProp (TransferProp) to save and load local data


class MData extends MKeypoint
	Config(MGame);


#exec TEXTURE IMPORT NAME=MData FILE=Textures\MData.tga FLAGS=2


var() bool b1;
var() bool b2;
var() int i1;
var() int i2;
var() float f1;
var() float f2;
var() string s1;
var() string s2;


defaultproperties
{
	Texture=Texture'MData'
}