package robotlegs.extensions.impl.model.timeout;

import mantle.notifier.Notifier;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
@:allow(robotlegs.extensions)
class TimeoutModel 
{
	private var _value:Bool = false;
	public var value(get, null):Bool;
	function get_value():Bool { return _value; }
	public var change = new Signal0();
	
	public function new() { }	
}