package fuse.utilsSort.conditions;

import fuse.utilsSort.UID;
import fuse.utils.Notifier;
import fuse.utilsSort.conditions.ConditionItem;
import fuse.signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class ConditionManager 
{
	private var conditionObjects = new Map<String, ConditionItem>();
	private var _pass:Bool = true;
	
	public var onActive = new Signal0();
	public var onInactive = new Signal0();
	
	public var pass(get, set):Bool; 
	
	public function new() 
	{
		
	}
	
	public function add(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="=="):Void 
	{
		conditionItem(notifier, value, operation);
		check();
	}
	
	public function remove(notifier:Notifier<Dynamic>):Void 
	{
		var id:String = UID.instanceID(notifier);
		if (conditionObjects.exists(id)) {
			conditionObjects.remove(id);
		}
	}
	
	private function conditionItem(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="=="):ConditionItem 
	{
		var id:String = UID.instanceID(notifier);
		var conditionItem = conditionObjects.get(id);
		if (conditionItem == null) {
			conditionItem = new ConditionItem(notifier, value, operation);
			notifier.add(check);
			conditionObjects.set(id, conditionItem);
		}
		return conditionItem;
	}
	
	public function check():Void
	{
		for (key in conditionObjects.keys())
		{
			var item = conditionObjects[key];
			if (item.pass == false) {
				this.pass = false;
				return;
			}
		}
		this.pass = true;
	}
	
	private function get_pass():Bool 
	{
		return _pass;
	}
	
	private function set_pass(value:Bool):Bool 
	{
		if (_pass == value) return value;
		_pass = value;
		
		if (_pass) {
			onActive.dispatch();
		}
		else {
			onInactive.dispatch();
		}
		return value;
	}
}