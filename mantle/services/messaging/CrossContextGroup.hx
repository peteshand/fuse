package mantle.services.messaging;

import msignal.Signal.AnySignal;
import msignal.Signal.Signal1;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author pjshand
 */
@:internal
class CrossContextGroup<T>
{
	public var groupID:String;
	private var signal = new Signal1<T>();
	public var valueClasses(get, set):T;
	
	public function new(groupID:String)
	{
		this.groupID = groupID;
	}
	
	public function add(listener:T->Void):Void
	{
		signal.add(listener);
	}
	
	public function addOnce(listener:T->Void):Void
	{
		signal.addOnce(listener);
	}
	
	public function dispatch(value:T):Void
	{
		signal.dispatch(value);
	}
	
	public function remove(listener:T->Void):Void
	{
		signal.remove(listener);
	}
	
	public function removeAll():Void
	{
		signal.removeAll();
	}
	
	public function get_valueClasses():T
	{
		return cast signal.valueClasses;
	}
	
	public function set_valueClasses(value:T):T
	{
		signal.valueClasses = cast value;
		return value;
	}
}