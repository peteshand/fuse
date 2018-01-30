package fuse.utilsSort.state;

import fuse.utilsSort.conditions.ConditionItem;
import fuse.utilsSort.conditions.ConditionManager;
import fuse.utils.Notifier;
import fuse.utilsSort.transition.Transition;
import fuse.utils.delay.Delay;
import fuse.signal.Signal0;

import fuse.robotlegs.scene.model.SceneModel;

/**
 * ...
 * @author P.J.Shand
 */
class State 
{
	private var _transitionManagers = new Array<Transition>();
	private var _onActive = new Signal0();
	private var _onInactive = new Signal0();
	
	private var sceneModel:SceneModel;
	private var _isActive:Bool = false;
	private var stateObjects = new Map<String, StateObject>();
	private var conditionManager:ConditionManager;
	private var forceDispatch:Bool = false;
	
	public var conditionsPass(get, null):Bool;
	public var onActive(get, null):Signal0;
	public var onInactive(get, null):Signal0;
	public var isActive(get, null):Bool;
	
	public function new(_sceneModel:SceneModel=null) 
	{
		this.sceneModel = _sceneModel;
		if (this.sceneModel == null) {
			this.sceneModel = SceneModel.instance;
		}
		
		this.sceneModel.add(OnSceneChange);
		conditionManager = new ConditionManager();
		conditionManager.onActive.add(ConditionChange);
		conditionManager.onInactive.add(ConditionChange);
		
		//Delay.nextFrame(InitCheck);
	}
	
	private function ConditionChange() 
	{
		check();
	}
	
	//private function InitCheck():Void 
	//{
		//forceDispatch = true;
		//OnSceneChange();
		//forceDispatch = false;
	//}
	
	public function countKeys(myDictionary:Map<String, StateObject>):Int 
	{
		var n:Int = 0;
		for (key in stateObjects.keys()) {
			n++;
		}
		return n;
	}
	
	private function OnSceneChange():Void 
	{
		var active:Bool = false;
		var count = countKeys(stateObjects);
		if (count == 0) {
			active = true;
		}
		
		for (key in stateObjects.keys())
		{
			var item:StateObject = stateObjects[key];
			var sceneModelURI = sceneModel.uri;
			var itemConditionsPass = item.conditionsPass;
			
			if (item.uri == sceneModelURI && item.ignore) {
				if (this.conditionsPass && itemConditionsPass) return; // ignore only if conditionsPass
			}
			if (item.wildcard) {
				
				if (sceneModelURI != null && sceneModelURI.indexOf(item.uri) == 0) {
					if (item.mask) active = false;
					else if (itemConditionsPass) {
						active = true;
					}
				}
			}
			if (item.uri == sceneModelURI || item.uri == "*") {
				if (item.mask) {
					active = false;
					break;
				}
				else if (itemConditionsPass) {
					active = true;
				}
			}
		}
		
		var _conditionsPass = this.conditionsPass;
		if (active && _conditionsPass) {
			if (!_isActive || forceDispatch) {
				_isActive = true;
				_onActive.dispatch();
			}
		}
		else {
			if (_isActive || forceDispatch) {
				_isActive = false;
				_onInactive.dispatch();
			}
		}
	}
	
	public function addURI(uri:String, condition:ConditionItem=null):State 
	{
		stateObject(uri).mask = false;
		stateObject(uri).ignore = false;
		if (condition != null) {
			stateObject(uri).addCondition(condition);
			condition.change.add(ConditionChange);
		}
		check(true);
		return this;
	}
	
	public function removeURI(uri:String):State 
	{
		if (stateObjects.exists(uri)) {
			stateObjects.remove(uri);
		}
		check(true);
		return this;
	}
	
	public function maskURI(uri:String):State 
	{
		stateObject(uri).mask = true;
		check(true);
		return this;
	}
	
	public function check(forceDispatch:Bool=false):Bool 
	{
		this.forceDispatch = forceDispatch;
		OnSceneChange();
		forceDispatch = false;
		return _isActive;
	}
	
	public function ignore(uri:String):State 
	{
		stateObject(uri).ignore = true;
		return this;
	}
	
	private function stateObject(uri:String):StateObject 
	{
		var stateObject = stateObjects.get(uri);
		if (stateObject == null) {
			stateObject = new StateObject(uri);
			stateObjects.set(uri, stateObject);
		}
		return stateObject;
	}
	
	public function addCondition(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="=="):State 
	{
		conditionManager.add(notifier, value, operation);
		return this;
	}
	
	public function removeCondition(notifier:Notifier<Dynamic>):State 
	{
		conditionManager.remove(notifier);
		return this;
	}
	
	public static function fromURI(uri:String):State 
	{
		return new State().addURI(uri);
	}
	
	public function attachTransition(transition:Transition):Void 
	{
		if (transition == null) {
			trace("transition not set");
			return;
		}
		removeTransition(transition);
		_onActive.add(transition.Show);
		_onInactive.add(transition.Hide);
		_transitionManagers.push(transition);
	}
	
	public function removeTransition(transition:Transition):Bool 
	{
		if (transition == null) return false;
		for (i in 0..._transitionManagers.length)
		{
			if (_transitionManagers[i] == transition) {
				_onActive.remove(_transitionManagers[i].Show);
				_onInactive.remove(_transitionManagers[i].Hide);
				_transitionManagers.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	
	public function dispose() 
	{
		conditionManager.onActive.remove(ConditionChange);
		conditionManager.onInactive.remove(ConditionChange);
		
		_transitionManagers = new Array<Transition>();
		_onActive = new Signal0();
		_onInactive = new Signal0();
		stateObjects = new Map<String, StateObject>();
		
	}
	
	private function get_conditionsPass():Bool 
	{
		conditionManager.check();
		return conditionManager.pass;
	}
	
	private function get_onActive():Signal0 { return _onActive; }
	private function get_onInactive():Signal0 { return _onInactive; }
	private function get_isActive():Bool { return _isActive; }
}

