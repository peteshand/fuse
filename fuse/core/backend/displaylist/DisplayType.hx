package fuse.core.backend.displaylist;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract DisplayType(Int) from Int to Int {
	
	var STAGE = 0;
	var SPRITE = 1;
	var DISPLAY_OBJECT = 2;
	var DISPLAY_OBJECT_CONTAINER = 3;
	var IMAGE = 4;
	var QUAD = 5;
	
}