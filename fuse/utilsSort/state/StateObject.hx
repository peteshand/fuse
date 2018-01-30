package fuse.utilsSort.state;

import fuse.utilsSort.conditions.ConditionItem;
/**
 * ...
 * @author P.J.Shand
 */
class StateObject 
{
	public var mask:Bool = false;
	public var uri:String;
	public var ignore:Bool = false;
	public var wildcard:Bool = false;
	public var conditions = new Array<ConditionItem>();
	
	#if swc @:protected #end
	private var _conditionsPass:Bool = true;
	
	#if swc @:extern #end
	public var conditionsPass(get, null):Bool;
	
	public function new(uri:String) 
	{
		if (uri.indexOf("*") == -1 || uri == "*") this.uri = uri;
		else {
			wildcard = true;
			this.uri = uri.split("*")[0];
		}
	}
	
	public function addCondition(condition:ConditionItem):Void 
	{
		conditions.push(condition);
	}
	
	public function removeCondition(condition:ConditionItem):Void 
	{
		for (i in 0...conditions.length) 
		{
			if (conditions[i] == condition) conditions.splice(i, 1);
		}
	}
	
	#if swc @:getter(conditionsPass) #end
	public function get_conditionsPass():Bool 
	{
		_conditionsPass = true;
		for (i in 0...conditions.length)
		{
			if (Reflect.getProperty(conditions[i], "pass") == false) {
				_conditionsPass = false;
				break;
			}
		}
		return _conditionsPass;
	}
}