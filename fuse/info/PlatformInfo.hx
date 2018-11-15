package fuse.info;
import openfl.system.Capabilities;

#if electron
	import js.node.Os;
#end
/**
 * ...
 * @author P.J.Shand
 */
class PlatformInfo
{
	static private var os:String;
	static private var manufacturer:String;

	@:isVar public static var platform(get, null):Platform;
	static function get_platform():Platform
	{
		if (platform == null){
			#if electron
				os = Os.platform();
				trace("1 os = " + os);
				if (os.indexOf("darwin") != -1) platform = Platform.MAC;
				else if (os.indexOf("win") != -1) platform = Platform.WINDOWS;
			#else
				os = Capabilities.os.toLowerCase();
				trace("2 os = " + os);
				if (os.indexOf("windows") != -1) platform = Platform.WINDOWS;
				else if (os.indexOf("osx") != -1) platform = Platform.MAC;
			#end
		}
		trace("platform = " + platform);
		return platform;
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