package mantle.managers.state;

import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class SceneCondition extends Condition
{
	var wildcard:Bool;
	var wildcardValue:String;
	var wildcardLength:Int;
	
	public function new(notifier:Notifier<Dynamic>, targetValue:String, operation:String="==") 
	{
		super(notifier, targetValue, operation);
		wildcardLength = targetValue.indexOf("*");
		if (wildcardLength > 0) {
			wildcard = true;
			wildcardValue = targetValue.substr(0, wildcardLength);
		}
	}
	
	override function equalTo(value1:Dynamic, value2:Dynamic) 
	{
		if (wildcard) {
			var s1:String = untyped value1;
			var s2:String = s1.substr(0, wildcardLength);
			if (s2 == wildcardValue) return true;
			else return false;
		}
		else {
			if (value1 == value2) return true;
			return false;
		}
		
	}
}