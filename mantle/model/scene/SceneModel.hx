package mantle.model.scene;

import mantle.managers.transition.Transition;
import mantle.notifier.Notifier;
import robotlegs.extensions.impl.model.activity.ActivityModel;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class SceneModel extends BaseNotifier<String>
{
	@inject public var activityModel:ActivityModel;
	static public var instance:SceneModel;
	
	var updateHistory:Bool = true;
	//var _uri:String = "";
	var _history = new Array<String>();
	var queueValue:String;
	var queuedUpdateHistory:Bool = true;
	
	public var queueURI:Bool = true;
	public var goBackUri:String;
	
	public var uri(get, set):String;
	public var uriWithoutHistory(null, set):String;
	public var previousUri(get, null):String;
	
	public function new() {
		super("");
	}
	
	private function get_uri():String 
	{
		return this.value;
	}
	
	private function set_uri(value:String):String 
	{
		return this.value = value;
	}
	
	override private function set_value(v:Null<String>):Null<String> 
	{
		if (_value == v && requireChange) return v;
		if (_value != null && _unsetHandlers != null) {
			for(handler in _unsetHandlers) handler(_value);
		}
		
		if (queueURI && Transition.globalTransitioning.value) {
			queue(v, updateHistory);
		}
		else {
			goBackUri = null;
			_value = v;
			if (_value != null && _setHandlers != null) {
				for(handler in _setHandlers) handler(_value);
			}
			if (updateHistory) _history.push(v);
			activityModel.animating();
			this.dispatch();
		}
		return v;
	}
	
	public function setUriWithoutUpdate(value:String):Void 
	{
		goBackUri = _value;
		_value = value;
		_history.push(_value);
	}
	
	private function set_uriWithoutHistory(value:String):String 
	{
		updateHistory = false;
		this.uri = value;
		updateHistory = true;
		return value;
	}
	
	private function queue(value:String, updateHistory:Bool):Void 
	{
		queuedUpdateHistory = updateHistory;
		queueValue = value;
		Transition.globalTransitioning.removeAll();
		Transition.globalTransitioning.addOnce(OnTransitionChange);
	}
	
	private function OnTransitionChange():Void 
	{
		if (Transition.globalTransitioning.value == false) {
			updateHistory = queuedUpdateHistory;
			value = queueValue;
			updateHistory = false;
		}
	}
	
	public function goBack(backNum:Int=1):Void 
	{
		if (_history.length < backNum) {
			return;
		}
		
		goBackUri = _value;
		for (i in 0...backNum) 
		{
			_history.pop();
		}
		
		value = _history[_history.length - 1];
	}
	
	private function get_previousUri():String 
	{
		if (_history.length > 1)
			return _history[_history.length - 2];
		else
			return "";
	}
}