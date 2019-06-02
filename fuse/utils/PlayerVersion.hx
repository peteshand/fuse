package fuse.utils;

import openfl.system.Capabilities;

/**
 * ...
 * @author P.J.Shand
 */
class PlayerVersion {
	public static var os:String;
	public static var major:Int;
	public static var minor:Int;
	public static var build:Int;
	public static var majorMinor:Float;

	static function __init__():Void {
		var versionNumber:String = Capabilities.version; // Get the whole version string
		var versionArray:Array<String> = versionNumber.split(","); // Split it up
		var length:Int = versionArray.length;
		var osPlusVersion:Array<String> = versionArray[0].split(" "); // The main version contains the OS (e.g. WIN), so we split that off as well.
		os = osPlusVersion[0];
		major = Std.parseInt(osPlusVersion[1]);
		minor = Std.parseInt(versionArray[1]);
		build = Std.parseInt(versionArray[2]);
		majorMinor = major + (minor / 10);
	}

	public function new() {}
}
