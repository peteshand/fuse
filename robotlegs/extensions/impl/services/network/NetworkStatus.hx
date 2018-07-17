package robotlegs.extensions.impl.services.network;

import mantle.notifier.Notifier;
import mantle.delay.Delay;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import robotlegs.extensions.impl.utils.net.ListenerUtil;

/**
 * ...
 * @author P.J.Shand
 */
class NetworkStatus 
{
	public static var connected = new Notifier<Bool>(null);
	static var loader:URLLoader;
	static var request:URLRequest;
	
	public static function __init__()
	{
		request = new URLRequest("http://google.com");
		loader = new URLLoader();
		ListenerUtil.configureListeners(loader, OnSucess, OnFail);
		CheckConnection();
	}
	
	public function new() { }
	
	static function CheckConnection() 
	{
		loader.load(request);
	}
	
	static function OnSucess() 
	{
		Delay.byFrames(60, CheckConnection);
		NetworkStatus.connected.value = true;
	}
	
	static function OnFail() 
	{
		Delay.byFrames(60, CheckConnection);
		NetworkStatus.connected.value = false;
	}
}