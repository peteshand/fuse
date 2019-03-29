package robotlegs.extensions.impl.services.timeout;

import robotlegs.bender.extensions.config.IConfigModel;
import robotlegs.extensions.impl.model.activity.ActivityModel;
import robotlegs.extensions.impl.model.timeout.TimeoutModel;
import org.swiftsuspenders.utils.DescribedType;
/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class TimeoutService implements DescribedType 
{
	@inject public var activityModel:ActivityModel;
	@inject public var timeoutModel:TimeoutModel;
	@inject public var configModel:IConfigModel;
	
	private var callbacks = new Array<Void -> Void>();
	@:isVar var timeoutValue(get, set):Bool = true;
	
	private var _running:Bool = false;
	private var running(get, null):Bool;
	
	public function new()
	{
		
	}
	
	public function start():Void
	{
		_running = true;
		activityModel.inactiveTime.add(OnInactiveTimeChange);
		activityModel.animationTime.add(OnInactiveTimeChange);
		timeoutModel.change.add(OnTimedOutChange);
		OnTimedOutChange();
	}
	
	public function stop():Void
	{
		_running = false;
		activityModel.inactiveTime.remove(OnInactiveTimeChange);
		activityModel.animationTime.add(OnInactiveTimeChange);
		timeoutModel.change.remove(OnTimedOutChange);
	}
	
	function OnTimedOutChange() 
	{
		if (timeoutModel.value){
			for (i in 0...callbacks.length) 
			{
				callbacks[i]();
			}
		}
	}
	
	public function add(callback:Void -> Void) 
	{
		for (i in 0...callbacks.length) 
		{
			if (callbacks[i] == callback) return;
		}
		callbacks.push(callback);
	}
	
	public function remove(callback:Void -> Void) 
	{
		var i:Int = callbacks.length - 1;
		while (i >= 0) 
		{
			if (callbacks[i] == callback) {
				callbacks.splice(i, 1);
			}
			i--;
		}
	}
	
	function OnInactiveTimeChange() 
	{
		if (activityModel.inactiveTime.value < configModel.timeout || activityModel.animationTime.value < configModel.timeout)
			timeoutValue = false;
		else
			timeoutValue = true;
	}
	
	function get_timeoutValue():Bool 
	{
		return timeoutValue;
	}
	
	function set_timeoutValue(v:Bool):Bool 
	{
		if (timeoutValue == v) return v;
		timeoutValue = timeoutModel._value = v;
		timeoutModel.change.dispatch();
		return timeoutValue;
	}
	
	function get_running():Bool 
	{
		return _running;
	}
	
}