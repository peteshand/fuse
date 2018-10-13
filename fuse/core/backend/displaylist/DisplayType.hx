package fuse.core.backend.displaylist;

/**
 * ...
 * @author P.J.Shand
 */

@:enum abstract DisplayType(Int) from Int to Int {
	
	public var STAGE:Int = 0;
	public var SPRITE:Int = 1;
	public var DISPLAY_OBJECT:Int = 2;
	public var DISPLAY_OBJECT_CONTAINER:Int = 3;
	public var IMAGE:Int = 4;
	public var MOVIECLIP:Int = 5;
	public var QUAD:Int = 6;
}