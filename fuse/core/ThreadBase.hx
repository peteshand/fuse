package fuse.core;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.display.Sprite;
import fuse.display.Stage;
import fuse.core.render.Renderer;
import msignal.Signal.Signal0;
import openfl.Lib;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */

class ThreadBase extends EventDispatcher
{
	public var enterFrame:Signal0 = new Signal0();
	public var sharedMemory:SharedMemory;
	public var renderer:Renderer;
	public var stage:Stage;
	public var frameRate(get, set):Float;
	public var onRender:Signal0;
	public var workerSetup:WorkerSetup;
	public var conductorData:WorkerConductorData;
	
	public var staticCount:Int = 0;
	//public var frontIsStatic:Int = 0;
	public var cleanContext:Bool = false;
	public var root:Sprite;
	
	public function new() 
	{
		super();
	}
	
	function get_frameRate():Float 
	{
		return Lib.current.stage.frameRate;
	}
	
	function set_frameRate(value:Float):Float 
	{
		Lib.current.stage.frameRate = value;
		return value;
	}
}