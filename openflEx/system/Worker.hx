#if !flash
package openflEx.system;

import openfl.system.MessageChannel;
import openfl.system.Worker;

/**
 * ...
 * @author P.J.Shand
 */
class Worker {
	static public var current:Worker;

	public var isPrimordial:Bool = true;

	static function __init__():Void {
		current = new Worker();
	}

	public function new() {}

	public function createMessageChannel(worker:Worker):MessageChannel {
		return null;
	}

	public function setSharedProperty(key:String, property:Dynamic) {}

	public function getSharedProperty(key:String):Dynamic {
		return null;
	}

	public function start() {}
}
#end
