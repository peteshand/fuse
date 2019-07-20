#if !flash
package openflEx.concurrent;

/**
 * ...
 * @author P.J.Shand
 */
class Condition {
	public var mutex:Mutex;

	public function new(mutex:Mutex) {
		this.mutex = mutex;
	}

	public function notify() {}

	public function notifyAll() {}

	public function wait() {}
}
#end
