package fuse.state;

import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class Condition<T> extends Notifier<Bool>
{
	var notifiers:Array<Notifier<T>> = [];
	
	public function new() { }
	
	public function add(notifier:Notifier<T>, value:T, operation:String="=="):Void
	{
		notifiers.push( new ConditionItem<T>(notifier:notifier, value:value, operation:operation) );
		notifier.add(OnValueChange);
	}
	
	function OnValueChange() 
	{
		var pass:Bool = false;
		for (i in 0...notifiers.length) 
		{
			if (notifiers[i].pass) pass = true;
		}
		return pass;
	}
}

class ConditionItem<T>
{
	var notifier:Notifier<T>;
	var value:T;
	var operation:String;
	public var pass(get, null):Bool;
	
	public function new(notifier:Notifier<T>, value:T, operation:String="=="):Void
	{
		this.notifier = notifier;
		this.value = value;
		this.operation = operation;
	}
	
	function get_pass():Bool 
	{
		switch (operation) 
		{
			case "==":	if (notifier.value == value) return true;
			case "!=":	if (notifier.value != value) return true;
			case "<=":	if (notifier.value <= value) return true;
			case "<":	if (notifier.value < value) return true;
			case ">=":	if (notifier.value >= value) return true;
			case ">":	if (notifier.value > value) return true;
			default: return false;
		}
	}
}