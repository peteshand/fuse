package mantle.util.app;

/**
 * ...
 * @author Thomas Byrne
 */
#if html5
typedef RealPlatform = BrowserPlatform;
#else
typedef RealPlatform = DesktopPlatform;
#end

class Platform
{
	public static function isWindows():Bool 
	{
		return RealPlatform.isWindows();
	}
	
	public static function isMac():Bool 
	{
		return RealPlatform.isMac();
	}
	
	public static function isMobile():Bool 
	{
		return RealPlatform.isMobile();
	}
	
	public static function is64Bit():Bool 
	{
		#if html5
			return false;
		#else
			return RealPlatform.is64Bit();
		#end
	}
}