package mantle.delay;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract TimeUnit(Int) from Int to Int from UInt to UInt {
	
	public var MILLISECONDS = 0;
	public var SECONDS = 1;
	public var MINUTES = 2;
	public var HOURS = 3;
	public var DAYS = 4;
}