package mantle.managers.state;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class Condition extends BaseNotifier<Bool>
{
	public var notifier:Notifier<Dynamic>;
	public var targetValue:Dynamic;
	public var operation:String;
	
	public function new(notifier:Notifier<Dynamic>, targetValue:Dynamic, operation:String="==") 
	{
		this.operation = operation;
		this.targetValue = targetValue;
		this.notifier = notifier;
		
		super();
		notifier.addWithPriority(Update, 1000);
		check();
	}
	
	function Update() 
	{
		check();
	}
	
	public inline function check(forceDispatch:Bool = false) 
	{
		this.value = getValue();
		if (forceDispatch) this.dispatch();
	}
	
	function getValue() 
	{
		switch (operation) 
		{
			case "==":
				return equalTo(notifier.value, targetValue);
			case "!=":
				return notEqualTo(notifier.value, targetValue);
			case "<=":
				return lessThanOrEqualTo(notifier.value, targetValue);
			case "<":
				return lessThan(notifier.value, targetValue);
			case ">=":
				return greaterThanOrEqualTo(notifier.value, targetValue);
			case ">":
				return greaterThan(notifier.value, targetValue);
			default:
		}
		
		return false;
	}
	
	function equalTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 == value2) return true;
		return false;
	}
	
	function notEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 != value2) return true;
		return false;
	}
	
	function lessThanOrEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 <= value2) return true;
		return false;
	}
	
	function lessThan(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 < value2) return true;
		return false;
	}
	
	function greaterThanOrEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 >= value2) return true;
		return false;
	}
	
	function greaterThan(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 > value2) return true;
		return false;
	}
}