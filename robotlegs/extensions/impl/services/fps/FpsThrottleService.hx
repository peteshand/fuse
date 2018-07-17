package robotlegs.extensions.impl.services.fps;

import mantle.notifier.Notifier;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.extensions.api.model.config.IConfigModel;
import robotlegs.extensions.impl.model.activity.ActivityModel;
import robotlegs.extensions.impl.model.fps.FPSThrottleModel;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
@:rtti
class FpsThrottleService
{
	@inject public var contextView:ContextView;
	@inject public var activityModel:ActivityModel;
	@inject public var fpsThrottleModel:FPSThrottleModel;
	@inject public var configModel:IConfigModel;
	
	@:isVar private var throttleActive(get, set):Bool = false;
	
	private var _running:Bool = false;
	private var running(get, null):Bool = false;
	
	private var registeredItems = new Array<Dynamic>();
	
	public function new() 
	{
		
	}
	
	public function start():Void
	{
		_running = true;
		activityModel.inactiveTime.add(OnInactiveTimeChange);
		OnInactiveTimeChange();
	}
	
	public function stop():Void
	{
		_running = false;
		activityModel.inactiveTime.remove(OnInactiveTimeChange);
		
	}
	
	public function register(item:Dynamic) 
	{
		for (i in 0...registeredItems.length) 
		{
			if (registeredItems[i] == item) return;
		}
		registeredItems.push(item);
	}
	
	public function unregister(item:Dynamic) 
	{
		var i:Int = registeredItems.length - 1;
		while (i >= 0) 
		{
			if (registeredItems[i] == item) {
				registeredItems.splice(i, 1);
			}
			i--;
		}
	}
	
	function OnFPSTimedOutChange() 
	{
		if (fpsThrottleModel.throttling && this.running && registeredItems.length == 0) {
			contextView.view.stage.frameRate = configModel.throttleFPS;
		}
		else {
			contextView.view.stage.frameRate = configModel.activeFPS;
		}
	}
	
	function OnInactiveTimeChange() 
	{
		if (activityModel.inactiveTime.value < configModel.throttleTimeout || activityModel.animationTime.value < configModel.throttleTimeout)
			throttleActive = false;
		else 
			throttleActive = true;
	}
	
	function get_throttleActive():Bool 
	{
		return throttleActive;
	}
	
	function set_throttleActive(value:Bool):Bool 
	{
		if (throttleActive == value) return value;
		fpsThrottleModel._throttling = throttleActive = value;
		OnFPSTimedOutChange();
		return throttleActive;
	}
	
	function get_running():Bool 
	{
		return _running;
	}
}