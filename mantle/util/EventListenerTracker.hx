package mantle.util;

#if openfl
import openfl.events.Event;
import openfl.events.IEventDispatcher;
#else
import flash.events.Event;
import flash.events.IEventDispatcher;
#end

/**
 * Allows you to remove all listeners and swap dispatchers.
 * 
 * @author Thomas Byrne
 */
class EventListenerTracker
{
	@:isVar public var dispatcher(get, set):IEventDispatcher;
	
	private var _listeners:Map<String, Array<Dynamic->Void>> = new Map();

	public function new(dispatcher:IEventDispatcher=null) 
	{
		this.dispatcher = dispatcher;
	}
	
	function get_dispatcher():IEventDispatcher 
	{
		return dispatcher;
	}
	
	function set_dispatcher(value:IEventDispatcher):IEventDispatcher 
	{
		if (dispatcher == value) return dispatcher;
		if (dispatcher!=null) {
			unbindAll();
		}
		dispatcher = value;
		if (dispatcher!=null) {
			bindAll();
		}
		
		return dispatcher;
	}
	
	function unbindAll() 
	{
		for (eventName in _listeners.keys()) {
			var listeners:Array<Dynamic->Void> = _listeners.get(eventName);
			for(list in listeners){
				dispatcher.removeEventListener(eventName, list);
			}
		}
	}
	
	function bindAll() 
	{
		for (eventName in _listeners.keys()) {
			var listeners:Array<Dynamic->Void> = _listeners.get(eventName);
			for(list in listeners){
				dispatcher.addEventListener(eventName, list);
			}
		}
	}
	
	public function addEventListener<K:Event>(type:String, listener:K->Void):Void 
	{
		var list:Array<Dynamic->Void> = _listeners.get(type);
		if (list == null) {
			list = [];
			_listeners.set(type, list);
			
		}
		list.push(untyped listener);
		if(dispatcher!=null)dispatcher.addEventListener(type, listener);
	}
	
	public function removeEventListener<K:Event>(type:String, listener:K->Void):Void 
	{
		var list:Array<Dynamic->Void> = _listeners.get(type);
		if (list == null) {
			return;
		}
		list.remove(untyped listener);
		if(dispatcher!=null)dispatcher.removeEventListener(type, listener);
	}
	
	public function removeAllEventListeners() 
	{
		unbindAll();
		_listeners = new Map();
	}
	
}