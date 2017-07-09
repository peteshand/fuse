package kea2.worker.thread.layerCache.groups;
import kea2.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class StaticLayerGroup
{
	public var active:Bool = false;
	public var index:Int;
	public var start:Int = -1;
	@:isVar public var end(get, set):Int;
	public var length:Int;
	public var textureId:Int;
	@:isVar public var state(get, set):Notifier<StaticGroupState>;
	
	public function new() { 
		state = new Notifier<StaticGroupState>();
	}
	
	public function toString():String
	{
		return "index = " + index + " state = " + state + " active = " + active + " textureId = " + textureId + " length = " + length + " start = " + start + " end = " + end;
	}
	
	inline function get_end():Int 
	{
		return end;
	}
	
	inline function set_end(value:Int):Int 
	{
		end = value;
		length = 1 + (end - start);
		return end;
	}
	
	function get_state():Notifier<StaticGroupState> 
	{
		return state;
	}
	
	function set_state(value:Notifier<StaticGroupState>):Notifier<StaticGroupState> 
	{
		state = value;
		if (value == null) {
			trace("");	
		}
		return state;
	}
}

@:enum abstract StaticGroupState(String) to String {
	
	public var ALREADY_ADDED = "alreadyAdded";
	public var MOVING = "moving";
	public var DRAW_TO_LAYER = "drawToLayer";
	//public var ADD_TO_LAYER = "addToLayer";
	
}