// *****************************************************
// * Master's Editor Utility Pack (MGame) by Master_64 *
// *		  Copyrighted (c) Master_64, 2022		   *
// *   May be modified but not without proper credit!  *
// *	 https://master-64.itch.io/shrek-2-pc-mgame    *
// *****************************************************
// 
// For the users who borderline need to write a manual inside the map's file, here you go
// Convenient for big guides or for detailed information built straight into the map's file
// Can have a title, a table of contents (which allows you to mark which index corresponds to what section) and sections


class MNoteExtra extends MNote
	Config(MGame);


struct ChaptersStruct
{
	var() array<string> Notes; // All of the notes
};

struct TableOfContentsStruct
{
	var() string NoteSectionTitle; // The section title
	var() int NoteIndex;		   // The note index that corresponds with the section title
};

var(MNote) string NoteTitle;								 // The title of this entire note
var(MNote) array<TableOfContentsStruct> NoteTableOfContents; // The table of contents (for locating sections)
var(MNote) array<ChaptersStruct> NoteChapters;				 // The chapters (contains all the notes)