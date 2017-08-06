package fuse.core.backend.layerCache.groups;
import fuse.utils.Notifier;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
class StaticLayerGroup
{
	public var active:Bool = false;
	public var index:Int;
	public var start:Int = -1;
	@:isVar public var end(get, set):Int;
	public var length:Int;
	public var textureId:Int;
	@:isVar public var state(get, set):Notifier<LayerGroupState>;
	
	public function new() { 
		state = new Notifier<LayerGroupState>();
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
	
	function get_state():Notifier<LayerGroupState> 
	{
		return state;
	}
	
	function set_state(value:Notifier<LayerGroupState>):Notifier<LayerGroupState> 
	{
		state = value;
		if (value == null) {
			trace("");	
		}
		return state;
	}
}