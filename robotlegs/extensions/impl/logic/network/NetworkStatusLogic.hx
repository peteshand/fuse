package robotlegs.extensions.impl.logic.network;

import delay.Delay;
import flash.net.URLLoader;
import flash.net.URLRequest;
import robotlegs.extensions.impl.model.network.NetworkStatusModel;
import robotlegs.extensions.impl.utils.net.ListenerUtil;
import org.swiftsuspenders.utils.DescribedType;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class NetworkStatusLogic implements DescribedType {
	@inject public var networkStatusModel:NetworkStatusModel;

	var loader:URLLoader;
	var request:URLRequest;

	public function new() {}

	public function start():Void {
		request = new URLRequest("http://google.com");
		loader = new URLLoader();
		ListenerUtil.configureListeners(loader, OnSucess, OnFail);
		CheckConnection();
	}

	function CheckConnection() {
		loader.load(request);
	}

	function OnSucess() {
		Delay.byFrames(60, CheckConnection);
		networkStatusModel.connected.value = true;
	}

	function OnFail() {
		Delay.byFrames(60, CheckConnection);
		networkStatusModel.connected.value = false;
	}
}
