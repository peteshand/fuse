#if !flash
package openfl.system;

import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */
class MessageChannel extends EventDispatcher {
	public var messageAvailable:Bool = false;

	public function new() {
		super();
	}

	public function send(object:Dynamic) {}

	public function receive():Dynamic {
		return null;
	}
}
#end
