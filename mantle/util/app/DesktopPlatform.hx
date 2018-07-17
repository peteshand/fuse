package mantle.util.app;

#if openfl
import openfl.system.Capabilities;
#elseif flash
import flash.system.Capabilities;
#end


/**
 * ...
 * @author Thomas Byrne
 */
class DesktopPlatform
{
	static var _inited:Bool;
	static var _isWindows:Bool;
	static var _isMac:Bool;
	static var _is64Bit:Bool;


	static public function init() 
	{
		if (_inited) return;
		
		_inited = true;
		
		#if sys
		var os = Sys.systemName();
		_isWindows = (os.indexOf("Win") != -1);
		_isMac = (os.indexOf("Mac") != -1);
		
		_is64Bit = _isMac;
		
		#else
		
		_is64Bit = Capabilities.supports64BitProcesses;
		
		var os = Capabilities.os;
		_isWindows = (os.indexOf("Win")!=-1);
		_isMac = (os.indexOf("Mac") != -1);
		#end
	}
	
	
	public static function isWindows():Bool 
	{
		init();
		return _isWindows;
	}
	
	public static function isMac():Bool 
	{
		init();
		return _isMac;
	}
	
	public static function is64Bit():Bool 
	{
		init();
		return _is64Bit;
	}
	
	public static function isMobile():Bool 
	{
		return false;
	}
}