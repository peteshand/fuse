package mantle.notifier;

import mantle.filesystem.DocStore;
import msignal.Signal.Signal0;

/**
 * Underlying runtime object
 */
class BaseNotifier<T> extends Signal0 
{
	public var requireChange:Bool = true;
	private var _value:T;
	private var _setHandlers:Array<T->Void>;
	private var _unsetHandlers:Array<T->Void>;
	private var actions:Array<T->T>;
	
	public var value(get, set):Null<T>;
	//public var change:Signal0;
	
	public var sharedObject:DocStore;
	
	public function new(?v:T, ?id:String) 
	{
		//change = new Signal0();
		_value = v;
		if (id != null) {
			sharedObject = DocStore.getLocal("Notifier_" + id);
			var localData:Null<T> = untyped Reflect.getProperty(sharedObject.data, "value");
			if (localData != null) _value = localData;
			this.add(SaveDataLocally);
		}
		super();
	}
	function SaveDataLocally() 
	{
		sharedObject.setProperty("value", this.value);
		sharedObject.flush();
	}
	
	
	
	function toString():String
	{
		return cast this.value;
	}
	
	private function get_value():Null<T> 
	{
		return _value;
	}
	
	private function set_value(v:Null<T>):Null<T> 
	{
		if (actions != null) {
			for (i in 0...actions.length) v = actions[i](v);
		}
		
		if (_value == v && requireChange) return v;
		
		if (_value != null && _unsetHandlers != null) {
			for(handler in _unsetHandlers) handler(_value);
		}
		_value = v;
		if (_value != null && _setHandlers != null) {
			for(handler in _setHandlers) handler(_value);
		}
		this.dispatch();
		return v;
	}
	
	public function addAction(action:T->T) 
	{
		if (actions == null) actions = [];
		actions.push(action);
	}
	
	public function set(handler:T->Void):BaseNotifier<T> 
	{
		if (_setHandlers == null)_setHandlers = [];
		_setHandlers.push(handler);
		return this;
	}
	
	/**
	 * unset handlers are unshifted onto the stack so that unbinding happens in 
	 * the reverse direction to binding (last added first).
	 */
	public function unset(handler:T->Void):BaseNotifier<T>
	{
		if (_unsetHandlers == null)_unsetHandlers = [];
		_unsetHandlers.unshift(handler);
		return this;
	}
}