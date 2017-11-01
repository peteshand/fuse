package fuse.state;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class AppState extends Notifier<String>
{
	var _history = new Array<String>();
	var queueValue:String;
	var updateHistory:Bool = true;
	var queuedUpdateHistory:Bool = true;
	
	//public var queueURI:Bool = true;
	public var goBackUri:String;
	
	public var uri(get, set):String;
	public var uriWithoutHistory(null, set):String;
	public var previousUri(get, never):String;
	
	public function new() { }
	
	function get_uri():String { return value; }
	function set_uri(v:String):String { return value = v; }
	
	override function set_value(v:Null<String>):Null<String> 
	{
		if (_value == v && requireChange) return v;
		//if (queueURI && Transition.globalTransitioning.value) {
			//queue(v, updateHistory);
		//}
		//else {
			goBackUri = null;
			_value = v;
			if (updateHistory) _history.push(v);
			dispatch()
		//}
		return v;
	}
	
	public function setUriWithoutUpdate(value:String):Void 
	{
		goBackUri = _value;
		_value = value;
		_history.push(_value);
	}
	
	function set_uriWithoutHistory(value:String):String 
	{
		updateHistory = false;
		uri = value;
		updateHistory = true;
		return value;
	}
	
	function queue(value:String, updateHistory:Bool):Void 
	{
		queuedUpdateHistory = updateHistory;
		queueValue = value;
	}
	
	public function goBack(backNum:Int=1):Void 
	{
		if (_history.length < backNum) return;
		goBackUri = _value;
		for (i in 0...backNum) { _history.pop(); }
		value = _history[_history.length - 1];
	}
	
	function get_previousUri():String 
	{
		if (_history.length > 1) return _history[_history.length - 2];
		else return null;
	}
}