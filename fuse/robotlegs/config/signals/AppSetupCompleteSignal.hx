package fuse.robotlegs.config.signals;

import fuse.signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class AppSetupCompleteSignal extends Signal0 
{
	public var done:Bool;
	
	public function new() 
	{
		super();
		
	}
	
	override public function dispatch() 
	{
		done = true;
		super.dispatch();
	}
}