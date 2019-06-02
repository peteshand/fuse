package fuse.display;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract BlendMode(UInt) from Int to Int {
	public var NORMAL = 0;
	public var NONE = 1;
	public var ADD = 2;
	public var MULTIPLY = 3;
	public var SCREEN = 4;
	public var ERASE = 5;
	public var MASK = 6;
	public var BELOW = 7;
	public var ALPHA = 8;
	public var HARDLIGHT = 9;
	public var NEGATIVE = 10;
	public var SHADOW = 11;
}
