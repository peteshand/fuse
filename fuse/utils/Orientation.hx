package fuse.utils;

@:enum abstract Orientation(Int) from Int to Int {
	public var LANDSCAPE:Int = 0;
	public var PORTRAIT_FLIPPED:Int = 90;
	public var LANDSCAPE_FLIPPED:Int = 180;
	public var PORTRAIT:Int = 270;
}
