package mantle.util.app;
import js.Browser;

/**
 * ...
 * @author Thomas Byrne
 */
class BrowserPlatform
{
	static var IOS_TEST = ~/iPad|iPhone|iPod/;
	static var AND_TEST = ~/Android/;
	static var WIN_TEST = ~/Windows/;
	static var MAC_TEST = ~/Macintosh/;
	
	static var CHROME_TEST = ~/(?:Chrome|crios)\/([\d]*)\.([\d]*)/i;
	static var SAFARI_TEST = ~/Safari\/([\d]*)\.([\d]*)/;
	static var EDGE_TEST = ~/(?:Trident.*rv:([\d]*)\.([\d]*))|(?:Edge\/([\d]*)\.([\d]*))/;
	static var FIREFOX_TEST = ~/Firefox\/([\d]*)\.([\d]*)/;
	
	
	static var _inited:Bool = false;
	
	
	static var _isIOS:Bool = false;
	static var _isAndroid:Bool = false;
	static var _isWindows:Bool = false;
	static var _isMac:Bool = false;
	
	static var _isSafari:Bool = false;
	static var _isChrome:Bool = false;
	static var _isEdge:Bool = false;
	static var _isFirefox:Bool = false;
	static var _isOtherBrowser:Bool = false;
	static var _isNativeBrowser:Bool = false;
	
	static var _browserVersionMaj:Int;
	static var _browserVersionMin:Int;


	static public function init() 
	{
		if (_inited) return;
		
		_inited = true;
		
		var userAgent = Browser.navigator.userAgent;
		
		if (IOS_TEST.match(userAgent)){
			_isIOS = true;
		}else if (AND_TEST.match(userAgent)){
			_isAndroid = true;
		}else if (MAC_TEST.match(userAgent)){
			_isMac = true;
		}else if (WIN_TEST.match(userAgent)){
			_isWindows = true;
		}
		
		if (EDGE_TEST.match(userAgent)){
			_isEdge = true;
			_isNativeBrowser = _isWindows;
			populateBrowserVersion(EDGE_TEST);
			
		}else if (CHROME_TEST.match(userAgent)){
			_isChrome = true;
			_isNativeBrowser = _isAndroid;
			populateBrowserVersion(CHROME_TEST);
			
		}else if (SAFARI_TEST.match(userAgent)){
			_isSafari = true;
			_isNativeBrowser = _isMac || _isIOS;
			populateBrowserVersion(SAFARI_TEST);
			
		}else if (FIREFOX_TEST.match(userAgent)){
			_isFirefox = true;
			populateBrowserVersion(FIREFOX_TEST);
			
		}else{
			_isOtherBrowser = true;
		}
		
		var msg = "";
		msg += ("UA: " + userAgent) + "\n\n";
		
		msg += ("iOS: "+_isIOS) + "\n";
		msg += ("And: "+_isAndroid) + "\n";
		msg += ("Win: "+_isWindows) + "\n";
		msg += ("Mac: " + _isMac) + "\n\n";
		
		msg += ("Safari: "+_isSafari) + "\n";
		msg += ("Chrome: "+_isChrome) + "\n";
		msg += ("Edge: "+_isEdge) + "\n";
		msg += ("Firefox: " + _isFirefox) + "\n\n";
		
		msg += ("vMaj: "+_browserVersionMaj) + "\n";
		msg += ("vMin: "+_browserVersionMin);
		
		//Browser.alert(msg);
	}
	
	static private function populateBrowserVersion(regEx:EReg) 
	{
		_browserVersionMaj = Std.parseInt(regEx.matched(1));
		_browserVersionMin = Std.parseInt(regEx.matched(2));
	}
	
	
	public static function isMobile():Bool 
	{
		init();
		return _isAndroid || _isIOS;
	}
	public static function isIOS():Bool 
	{
		init();
		return _isIOS;
	}
	public static function isAndroid():Bool 
	{
		init();
		return _isAndroid;
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
	
	
	public static function isSafari():Bool 
	{
		init();
		return _isSafari;
	}
	public static function isChrome():Bool 
	{
		init();
		return _isChrome;
	}
	public static function isEdge():Bool 
	{
		init();
		return _isEdge;
	}
	public static function isFirefox():Bool 
	{
		init();
		return _isFirefox;
	}
	public static function isOtherBrowser():Bool 
	{
		init();
		return _isOtherBrowser;
	}
	public static function isNativeBrowser():Bool 
	{
		init();
		return _isNativeBrowser;
	}
	
	
	public static function browserVersionMaj():Int 
	{
		init();
		return _browserVersionMaj;
	}
	public static function browserVersionMin():Int 
	{
		init();
		return _browserVersionMin;
	}
	
}