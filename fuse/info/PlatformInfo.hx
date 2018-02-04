package fuse.info;
import openfl.system.Capabilities;

/**
 * ...
 * @author P.J.Shand
 */
class PlatformInfo
{
	static private var os:String;
	static private var manufacturer:String;
	public static var platform:Platform;
	
	static function __init__():Void
	{
		os = Capabilities.os.toLowerCase();
		trace("os = " + os);
		//manufacturer = Capabilities.manufacturer.toLowerCase();
		//trace("manufacturer = " + manufacturer);
		
		if (os.indexOf("windows") != -1) {
			platform = Platform.WINDOWS;
		}
		else if (os.indexOf("osx") != -1) {
			platform = Platform.MAC;
		}
	}
	
}

@:enum abstract Platform(String) from String to String
{
	public static inline var WINDOWS:String = "windows";
	public static inline var MAC:String = "mac";
	public static inline var LINUX:String = "linux";
	public static inline var ANDROID:String = "android";
	public static inline var IOS:String = "ios";
}