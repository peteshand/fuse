package mantle.managers.state;

import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class Condition extends Notifier<Bool>
{
	public var notifier:Notifier<Dynamic>;
	public var operation:String;
	public var subProp:String;
	var targetIsFunction:Bool;
	var testValue(get, null):Dynamic;
	
	public var targetValue(get, null):Dynamic;
	var _targetValue:Dynamic;
	var _targetFunction:Void -> Dynamic;

	public function new(notifier:Notifier<Dynamic>, _targetValue:Dynamic, operation:String="==", subProp:String=null) 
	{
		this.operation = operation;
		
		targetIsFunction = Reflect.isFunction(_targetValue);
		if (targetIsFunction) _targetFunction = _targetValue;
		else this._targetValue = _targetValue;

		this.notifier = notifier;
		this.subProp = subProp;

		super();
		notifier.add(() -> {
			check();
		}, 1000);
		check();
	}

	public function get_targetValue():Dynamic
	{
		if (targetIsFunction) return _targetFunction();
		else return _targetValue;
	}
	
	public inline function check(forceDispatch:Bool = false) 
	{
		this.value = getValue();
		if (forceDispatch) this.dispatch();
	}

	function get_testValue()
	{
		if (subProp == null) return notifier.value;
		else {
			var split:Array<String> = subProp.split(".");
			if (subProp.indexOf(".") == -1) split = [subProp];
			
			var value:Dynamic = notifier.value;
			while (split.length > 0 && value != null){
				var prop:String = split.shift();
				value = Reflect.getProperty(value, prop);
			}
			
			return value;
		}
	}
	
	function getValue() 
	{
		switch (operation) 
		{
			case "==":
				return equalTo(testValue, targetValue);
			case "!=":
				return notEqualTo(testValue, targetValue);
			case "<=":
				return lessThanOrEqualTo(testValue, targetValue);
			case "<":
				return lessThan(testValue, targetValue);
			case ">=":
				return greaterThanOrEqualTo(testValue, targetValue);
			case ">":
				return greaterThan(testValue, targetValue);
			default:
		}
		
		return false;
	}
	
	function equalTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 == value2) return true;
		return false;
	}
	
	inline function notEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 != value2) return true;
		return false;
	}
	
	inline function lessThanOrEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 <= value2) return true;
		return false;
	}
	
	inline function lessThan(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 < value2) return true;
		return false;
	}
	
	inline function greaterThanOrEqualTo(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 >= value2) return true;
		return false;
	}
	
	inline function greaterThan(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 > value2) return true;
		return false;
	}

	override function toString():String
	{
		return "[Condition] " + testValue + " " + operation + " " + targetValue + " | " + value + " | " + (targetValue == targetValue);
	}
}