package kea.model;

import kea.notify.Notifier;

class Performance
{
	public var fps = new Notifier<Int>(0);
	public var frameBudget = new Notifier<Float>(0);
	
	public function new()
	{
		
	}
}
