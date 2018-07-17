package mantle.managers.state;

import mantle.managers.transition.Transition;
import mantle.model.scene.SceneModel;
import mantle.notifier.Notifier;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class State extends BaseNotifier<Bool> implements IState
{
	var sceneModel:Notifier<Dynamic>;
	public var standardConsitions:Array<Condition> = [];
	public var sceneConditions:Array<SceneCondition> = [];
	
	public var onActive = new Signal0();
	public var onInactive = new Signal0();
	public var uris:Array<String> = [];
	public var conditionPolicy:ConditionPolicy = ConditionPolicy.AND;
	
	public function new(_sceneModel:SceneModel=null) 
	{
		this.sceneModel = untyped _sceneModel;
		if (this.sceneModel == null) {
			this.sceneModel = untyped SceneModel.instance;
		}
		super();
		this.add(OnValueChange);
	}
	
	function OnValueChange() 
	{
		if (value) onActive.dispatch();
		else onInactive.dispatch();
	}
	
	public function addURI(uri:String):Void 
	{
		addCondition(sceneModel, uri);
	}
	
	public function addURIMask(uri:String):Void 
	{
		addCondition(sceneModel, uri, "!=");	
	}
	
	public function removeURI(uri:String):Void
	{
		removeCondition(sceneModel, uri);
	}
	
	public function removeURIMask(uri:String):Void
	{
		removeCondition(sceneModel, uri, "!=");
	}
	
	public function addCondition(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="=="):Void 
	{
		if (notifier == sceneModel) {
			uris.push(value);
			mapCondition(new SceneCondition(notifier, value, operation), untyped sceneConditions);
		}
		else {
			mapCondition(new Condition(notifier, value, operation), standardConsitions);
		}
		check();
	}
	
	public function removeCondition(notifier:Notifier<Dynamic>, value:Dynamic=null, operation:String=null):Void 
	{
		var consitions:Array<Condition>;
		if (notifier == sceneModel) consitions = untyped sceneConditions;
		else consitions = standardConsitions;
		
		var i:Int = consitions.length - 1;
		while (i >= 0) 
		{
			if (consitions[i].notifier == notifier) {
				if (value == consitions[i].targetValue  || value == null) {
					if (operation == consitions[i].operation  || operation == null){	
						consitions[i].remove(OnConditionChange);
						consitions.splice(i, 1);
					}
				}
			}
			i--;
		}
	}
	
	public function check(forceDispatch:Bool = false):Bool
	{
		for (i in 0...standardConsitions.length) 
		{
			standardConsitions[i].check(forceDispatch);
		}
		for (i in 0...sceneConditions.length) 
		{
			sceneConditions[i].check(forceDispatch);
		}
		OnConditionChange();
		if (forceDispatch) this.dispatch();
		return this.value;
	}
	
	function OnConditionChange() 
	{
		var _value1:Bool = checkWithPolicy(standardConsitions, conditionPolicy);
		var _value2:Bool = checkWithPolicy(untyped sceneConditions, ConditionPolicy.SCENE);
		if (sceneConditions.length == 0) _value2 = false;
		this.value = _value1 && _value2;
	}
	
	function checkWithPolicy(consitions:Array<Condition>, conditionPolicy:ConditionPolicy) 
	{
		if (consitions.length == 0) return true;
		var _value:Bool;
		if (conditionPolicy == ConditionPolicy.AND) {
			_value = true;
			for (i in 0...consitions.length) 
			{
				consitions[i].check();
				if (consitions[i].value == false) {
					_value = false;
					break;
				}
			}
		}
		else {
			_value = false;
			for (i in 0...consitions.length) 
			{
				consitions[i].check();
				if (consitions[i].value == true) {
					_value = true;
					if (conditionPolicy == ConditionPolicy.OR) break;
				}
				
				if (conditionPolicy == ConditionPolicy.SCENE) {
					if (consitions[i].value == false && consitions[i].operation == "!=") {
						_value = false;
						break;
					}
				}
			}
		}
		return _value;
	}
	
	public function dispose():Void
	{
		var i:Int = standardConsitions.length - 1;
		while (i >= 0) 
		{
			standardConsitions[i].remove(OnConditionChange);
			i--;
		}
		standardConsitions.splice(0, standardConsitions.length);
		
		var i:Int = sceneConditions.length - 1;
		while (i >= 0) 
		{
			sceneConditions[i].remove(OnConditionChange);
			i--;
		}
		sceneConditions.splice(0, sceneConditions.length);
	}
	
	public function clone():State
	{
		var _clone:State = new State(untyped sceneModel);
		_clone.conditionPolicy = this.conditionPolicy;
		for (i in 0...standardConsitions.length) {
			_clone.addCondition(standardConsitions[i].notifier, standardConsitions[i].targetValue, standardConsitions[i].operation);
		}
		for (i in 0...sceneConditions.length) {
			_clone.addCondition(sceneConditions[i].notifier, sceneConditions[i].targetValue, sceneConditions[i].operation);
		}
		return _clone;
	}
	
	function mapCondition(condition:Condition, _conditions:Array<Condition>):Void
	{
		condition.addWithPriority(OnConditionChange, 1000);
		_conditions.push(condition);
	}
	
	public function attachTransition(transition:Transition):Void
	{
		onActive.add(transition.Show);
		onInactive.add(transition.Hide);
	}
	
	public function removeTransition(transition:Transition):Void
	{
		onActive.remove(transition.Show);
		onInactive.remove(transition.Hide);
	}
	
	//public function ignore(uri:String):State 
	//public static function fromURI(uri:String):State 
}