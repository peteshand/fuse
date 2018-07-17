package robotlegs.extensions.impl.logic.network;

import mantle.delay.Delay;
import flash.net.URLLoader;
import flash.net.URLRequest;
import robotlegs.extensions.impl.model.network.NetworkStatusModel;
import robotlegs.extensions.impl.utils.net.ListenerUtil;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class NetworkStatusLogic
{
	@inject public var networkStatusModel:NetworkStatusModel;
	var loader:URLLoader;
	var request:URLRequest;

	public function new() 
	{
		
	}
	
	public function start():Void
	{
		request = new URLRequest("http://google.com");
		loader = new URLLoader();
		ListenerUtil.configureListeners(loader, OnSucess, OnFail);
		CheckConnection();
	}
	
	function CheckConnection() 
	{
		loader.load(request);
	}
	
	function OnSucess() 
	{
		Delay.byFrames(60, CheckConnection);
		networkStatusModel.connected.value = true;
	}
	
	function OnFail() 
	{
		Delay.byFrames(60, CheckConnection);
		networkStatusModel.connected.value = false;
	}
	
}