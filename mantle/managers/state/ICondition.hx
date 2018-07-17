package mantle.managers.state;

import mantle.notifier.Notifier;
import msignal.Signal.AnySignal;
import msignal.Slot;

/**
 * @author P.J.Shand
 */
interface ICondition 
{
	public var notifier:Notifier<Dynamic>;
	public var targetValue:Dynamic;
	public var operation:String;
	public function check():Void;
	public function add(listener:Void -> Void):Slot0;
	public function remove(listener:Void -> Void):Slot0;
	public var value(get, set):Null<Bool>;
}

//Slot0:Slot<Dynamic, Dynamic>, Void -> Void