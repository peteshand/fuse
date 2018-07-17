package robotlegs.extensions.impl.model.config2;

/**
 * ...
 * @author P.J.Shand
 */
@:enum abstract Locations(String) from String to String {
	
	public var LOCATION_REMOTE:String = "remote";
	public var LOCATION_LOCAL:String = "local";
	public var LOCATION_SEED:String = "seed";
	
	#if html5
	public var LOCATION_EMBEDDED:String = "embedded";
	#end
}