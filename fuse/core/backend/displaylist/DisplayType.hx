package fuse.core.backend.displaylist;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract DisplayType(Int) from Int to Int {
	
	var STAGE = 0;
	var SPRITE = 1;
	var DISPLAY_OBJECT = 2;
	var IMAGE = 3;
	var QUAD = 4;
	
}