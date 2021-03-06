package robotlegs.extensions.impl.model.timeout;

import notifier.Notifier;
import signals.Signal;

/**
 * ...
 * @author P.J.Shand
 */
@:allow(robotlegs.extensions)
class TimeoutModel {
	private var _value:Bool = false;

	public var value(get, null):Bool;

	function get_value():Bool {
		return _value;
	}

	public var change = new Signal();

	public function new() {}
}
