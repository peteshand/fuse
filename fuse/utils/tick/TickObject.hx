package fuse.utils.tick;

import haxe.Timer;
import lime.app.Application;

/**
 * ...
 * @author P.J.Shand
 */
class TickObject
{
	@:isVar public var callback(default, null):Int->Void;
	var running:Bool = false;
	
	public function new(callback:Int->Void) 
	{
		this.callback = callback;
	}
	
	public function start():Void
	{
		running = true;
	}
	
	public function stop():Void
	{
		running = false;
	}
	
	public function tick(delta:Int) 
	{
		if (running) callback(delta);
	}
}