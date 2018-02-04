package fuse.filesystem;

/**
 * ...
 * @author P.J.Shand
 */

@:enum abstract PermissionStatus(String) from String to String
{
	public static inline var DENIED:String = "denied";
	public static inline var GRANTED:String = "granted";
	public static inline var UNKNOWN:String = "unknown";
}