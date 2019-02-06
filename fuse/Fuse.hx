package fuse;
import fuse.core.ThreadBase;
import fuse.core.backend.WorkerThread;
import fuse.core.front.FuseConfig;
import fuse.core.front.MainThread;
import fuse.core.messenger.MessageManager;
import fuse.info.WorkerInfo;
import fuse.display.Sprite;
import fuse.display.Stage;
import fuse.events.FuseEvent;
import fuse.utils.FrameBudget;
import openfl.Lib;
import openfl.display.Stage3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class Fuse extends EventDispatcher
{
	//public static inline var MAX_TEXTURE_SIZE:Int = 8192;
	public static inline var MAX_TEXTURE_SIZE:Int = 4096;
	//public static inline var MAX_TEXTURE_SIZE:Int = 2048;
	
	var mainThread:MainThread;
	var workerThread:WorkerThread;
	@:isVar public static var current(default, null):ThreadBase;
	public var stage:Stage;
	
	public static var skipUnchangedFrames:Bool = true;
	
	public function new(rootClass:Class<Sprite>, fuseConfig:FuseConfig=null, stage3D:Stage3D=null, renderMode:Context3DRenderMode = AUTO, profile:Array<Context3DProfile> = null)
	{
		MessageManager.init();
		if (fuseConfig == null) fuseConfig = { };
		trace("FUSE VERSION: 0.0.7");
		if (WorkerInfo.isMainThread) {
			mainThread = new MainThread(this, rootClass, fuseConfig, stage3D, renderMode, profile);
			mainThread.addEventListener(FuseEvent.ROOT_CREATED, this.dispatchEvent);
			//mainThread.init();
		}
		if (WorkerInfo.isCoreThread) {
			workerThread = new WorkerThread();
			//workerThread.init();
		}
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, function(e:Event):Void
		{
			FrameBudget.startFrame();
		}, false, 1000);
		Lib.current.stage.addEventListener(Event.EXIT_FRAME, function(e:Event):Void
		{
			FrameBudget.endFrame();
		}, false, 1000);
		super();
		
		if (fuseConfig.autoStart == true) {
			this.addEventListener(FuseEvent.ROOT_CREATED, function(e:Event) {
				this.start();
			});
			this.init();
		}
	}
	
	public function init():Void
	{
		if (WorkerInfo.isMainThread) {
			mainThread.init();
		}
		if (WorkerInfo.isCoreThread) {
			workerThread.init();
		}
	}
	
	public function start():Void
	{
		mainThread.start();
	}
	
	public function stop():Void
	{
		mainThread.stop();
	}
	
	public function process() 
	{
		mainThread.process();
	}
	
	static public function useWorker():Bool 
	{
		WorkerInfo.numberOfWorkers = 1;
		if (WorkerInfo.isWorkerThread) {
			var fuse:Fuse = new Fuse(null, null, null);
			fuse.init();
			return true;
		}
		
		return false;
	}
}