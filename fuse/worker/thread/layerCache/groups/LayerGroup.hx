package fuse.worker.thread.layerCache.groups;
import fuse.worker.thread.display.WorkerDisplay;
import fuse.utils.Notifier;
import fuse.worker.thread.display.WorkerDisplay.StaticDef;

/**
 * ...
 * @author P.J.Shand
 */
class LayerGroup
{
	public var isStatic:Int;
	public var active:Bool;
	public var staticIndex:Int;
	public var start:Int = -1;
	@:isVar public var end(get, set):Int;
	public var length:Int;
	public var textureId:Int;
	@:isVar public var state:Notifier<LayerGroupState>;
	//public var staticDef:StaticDef;
	public var index:Int;
	
	public function new() { 
		state = new Notifier<LayerGroupState>();
		
	}
	
	public function toString():String
	{
		return "staticIndex = " + staticIndex + " isStatic = " + isStatic + " state = " + state + " active = " + active + " textureId = " + textureId + " length = " + length + " start = " + start + " end = " + end;
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
}

@:enum abstract LayerGroupState(String) to String {
	
	public var ALREADY_ADDED = "alreadyAdded";
	public var MOVING = "moving";
	public var DRAW_TO_LAYER = "drawToLayer";
	//public var ADD_TO_LAYER = "addToLayer";
	
}