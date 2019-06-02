package robotlegs.extensions.impl.model.activity;

import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class ActivityModel {
	public var inactiveTime = new Notifier<Int>(0);
	public var animationTime = new Notifier<Int>(0);

	public function new() {}

	public function animating():Void {
		animationTime.value = 0;
	}
}
