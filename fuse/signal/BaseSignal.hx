package fuse.signal;

import fuse.core.assembler.layers.sort.CustomSort;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class BaseSignal<CallbackType>
{
	@:isVar public var numListeners(default, null):Int;
	
	var items = new GcoArray<SignalItem<CallbackType>>();
	var nonRepeatCount:Int = 0;
	var prioritySetCount:Int = 0;
	var sortRequired:Bool = false;
	var customSort = new CustomSort<SignalItem<CallbackType>>();
	
	public function new() 
	{
		
	}
	
	public function add(callback:CallbackType, ?repeat:Bool=true, ?priority:Int=0):Void
	{
		remove(callback);
		items.push(new SignalItem<CallbackType>(callback, repeat, priority));
		if (!repeat) nonRepeatCount++;
		if (priority != 0) {
			prioritySetCount++;
			sortRequired = true;
		}
		numListeners = items.length;
	}
	
	public function remove(callback:CallbackType):Void
	{
		var i:Int = items.length - 1;
		while (i >= 0) 
		{
			if (items[i].callback == callback) {
				if (!items[i].repeat) nonRepeatCount--;
				if (items[i].priority != 0) prioritySetCount--;
				
				items.splice(i, 1);
			}
			i--;
		}
		numListeners = items.length;
	}
	
	public function removeAll():Void
	{
		items.clear();
		nonRepeatCount = 0;
		prioritySetCount = 0;
		numListeners = items.length;
		sortRequired = false;
	}
	
	function sort():Void
	{
		if (prioritySetCount <= 0 || !sortRequired) {
			prioritySetCount = 0;
			return;
		}
		trace("TODO: sort by priority");
		customSort.sort(items, "priority", SortType.DESCENDING);
		sortRequired = false;
	}
	
	function autoRemove():Void
	{
		if (nonRepeatCount <= 0) {
			nonRepeatCount = 0;
			return;
		}
		var i:Int = items.length - 1;
		while (i >= 0) 
		{
			if (!items[i].repeat) {
				items.splice(i, 1);
			}
			i--;
		}
		nonRepeatCount = 0;
	}
	
	public function dispose():Void
	{
		removeAll();
		items.dispose();
	}
}

class SignalItem<CallbackType>
{
	public var callback:CallbackType;
	public var repeat:Bool;
	public var priority:Int;
	
	public function new(callback:CallbackType, repeat:Bool, priority:Int) 
	{
		this.callback = callback;
		this.repeat = repeat;
		this.priority = priority;
	}
}