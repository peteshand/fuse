package mantle.managers.state;

import mantle.managers.transition.Transition;
import mantle.notifier.Notifier;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
interface IState
{
	public var conditionPolicy:ConditionPolicy;
	public var value(get, set):Null<Bool>;
	public var onActive:Signal0;
	public var onInactive:Signal0;
	public function addURI(uri:String):Void;
	public function addURIMask(uri:String):Void;
	public function removeURI(uri:String):Void;
	public function removeURIMask(uri:String):Void;
	public function addCondition(notifier:Notifier<Dynamic>, value:Dynamic, operation:String = "=="):Void;
	public function removeCondition(notifier:Notifier<Dynamic>, value:Dynamic = null, operation:String = null):Void;
	public function check(forceDispatch:Bool = false):Bool;
	public function dispose():Void;
	public function clone():State;
	public function attachTransition(transition:Transition):Void;
	public function removeTransition(transition:Transition):Void;
}