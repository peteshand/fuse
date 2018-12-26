package mantle.time;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract TimeUnit(Int) from Int to Int {
	
	public var MILLISECONDS = 1;
	public var SECONDS = 1000;
	public var MINUTES = 60000;
	public var HOURS = 3600000;
	public var DAYS = 86400000;
}