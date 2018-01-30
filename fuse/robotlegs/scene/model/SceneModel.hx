package fuse.robotlegs.scene.model;

import fuse.utils.Notifier;
import fuse.utilsSort.transition.Transition;
//import robotlegs.bender.extensions.imag.impl.model.activity.ActivityModel;
/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class SceneModel extends Notifier<String>
{
	//@inject public var activityModel:ActivityModel;
	static var _instance:SceneModel;
	static public var instance(get, null):SceneModel;
	
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
		super();
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
		
		if (queueURI && Transition.globalTransitioning.value) {
			queue(v, updateHistory);
		}
		else {
			goBackUri = null;
			_value = v;
			
			if (updateHistory) _history.push(v);
			//activityModel.animating();
			dispatch();
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
		trace("backNum = " + backNum);
		trace("_history.length = " + _history.length);
		if (_history.length < backNum) {
			return;
		}
		
		goBackUri = _value;
		trace(_history);
		for (i in 0...backNum) 
		{
			_history.pop();
		}
		
		trace(_history);
		uriWithoutHistory = _history[_history.length - 1];
	}
	
	private function get_previousUri():String 
	{
		if (_history.length > 1)
			return _history[_history.length - 2];
		else
			return "";
	}
	
	static function get_instance():SceneModel 
	{
		if (_instance == null) _instance = new SceneModel();
		return _instance;
	}
}