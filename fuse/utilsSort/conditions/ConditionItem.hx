package fuse.utilsSort.conditions;
import fuse.utils.Notifier;

import fuse.signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class ConditionItem 
{
	var notifier:Notifier<Dynamic>;
	var operation:String;
	var value:Dynamic;
	
	public var pass(get, null):Bool;
	public var change = new Signal0();
	
	public function new(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="==") 
	{
		this.notifier = notifier;
		this.value = value;
		this.operation = operation;
		
		notifier.add(change.dispatch);
	}
	
	public function get_pass():Bool 
	{
		switch (operation) 
		{
			case "==":
				if (notifier.value != value) return false;
			case "!=":
				if (notifier.value == value) return false;
			case "<=":
				if (notifier.value > value) return false;
			case "<":
				if (notifier.value >= value) return false;
			case ">=":
				if (notifier.value < value) return false;
			case ">":
				if (notifier.value <= value) return false;
			default:
		}
		
		return true;
	}
}