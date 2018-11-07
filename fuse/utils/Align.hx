package fuse.utils;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract Align(Null<Float>) from Float to Float {
	
	public var LEFT:Float = 0;
	public var CENTER:Float = 0.5;
	public var RIGHT:Float = 1;
	public var TOP:Float = 0;
	public var BOTTOM:Float = 1;
}