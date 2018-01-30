package fuse.info;

import openfl.system.Capabilities;

/**
 * ...
 * @author P.J.Shand
 */
class DeviceInfo
{
	static private var os:String;
	static private var manufacturer:String;
	
	static private var tabletScreenMinimumInches:Float = 6.2;
	static private var dpi:Float;
	static private var physicalScreenSize:Float;
	
	@:isVar public static var screenWidth(default, null):Float;
	@:isVar public static var screenHeight(default, null):Float;
	
	@:isVar public static var isMobile(default, null):Bool;
	@:isVar public static var isDesktop(default, null):Bool;
	@:isVar public static var isTablet(default, null):Bool;
	@:isVar public static var isPhone(default, null):Bool;
	@:isVar public static var isIOS(default, null):Bool;
	@:isVar public static var isAndroid(default, null):Bool;
	@:isVar public static var isCardboardCompatible(default, null):Bool; 
	
	static function __init__():Void
	{
		os = Capabilities.os.toLowerCase();
		manufacturer = Capabilities.manufacturer.toLowerCase();
		
		//TODO: test mac osx support
		if (manufacturer.indexOf("windows") != -1 || manufacturer.indexOf("osx") != -1 ) isMobile = false;
		else isMobile = true;
		
		isDesktop = !isMobile;
		
		screenWidth = Math.max( Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		screenHeight = Math.min( Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		dpi = Capabilities.screenDPI;
		
		var dPixel:Float = Math.sqrt( Math.pow(screenWidth, 2) + Math.pow(screenHeight, 2) );
		physicalScreenSize = dPixel / dpi; 
		
		if (isMobile)
		{
			//TODO: check if on ios manufacturer returns 'apple'
			if (manufacturer.indexOf("apple") != -1 ) isIOS = true;
			if (manufacturer.indexOf("android") != -1 ) isAndroid = true;
			
			if ((physicalScreenSize > tabletScreenMinimumInches)) isTablet = true;
			else isPhone = true;
			
			if (physicalScreenSize < 7) isCardboardCompatible = true;
			else isCardboardCompatible = false;
		}
	}
	
	public function new() 
	{
		
	}
	
}