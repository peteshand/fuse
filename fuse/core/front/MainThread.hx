package fuse.core.front;

import fuse.core.front.FuseConfig;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.front.input.mouse.FrontMouseInput;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.input.Input;
import fuse.display.DisplayObject;
import fuse.display.Stage;
import fuse.events.FuseEvent;
import fuse.render.Context3DSetup;
import fuse.render.Renderer;
import fuse.core.WorkerSetup;
import fuse.text.SnapTextField;
import openfl.display.Stage3D;
import openfl.events.Event;

import msignal.Signal.Signal0;

import openfl.Lib;

import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class MainThread extends ThreadBase
{
	//static public inline var ROOT_CREATED:String = "rootCreated";
	//public static var MAX_TEXTURE_SIZE:Int = 4096;
	
	//@:isVar 
	//public static var current(default, null):MainThread;
	
	static var count:Int = 0;
	var index:Int;
	//var atlasBuffers:AtlasBuffers;
	
	var rootClass:Class<DisplayObject>;
	var fuseConfig:FuseConfig;
	var stage3D:Stage3D;
	var renderMode:Context3DRenderMode;
	var profile:Dynamic;
	var context3DSetup:Context3DSetup;
	
	var setupComplete:Bool = false;
	
	var stageWidth:Int;
	var stageHeight:Int;
	var dimensionChange:Bool = false;
	var fuse:Fuse;
	
	public function new(fuse:Fuse, rootClass:Class<DisplayObject>, fuseConfig:FuseConfig, stage3D:Stage3D=null, renderMode:Context3DRenderMode = AUTO, profile:Array<Context3DProfile> = null)
	{	
		super();
		this.fuse = fuse;
		
		
		Fuse.current = this;
		index = count++;
		
		this.rootClass = rootClass;
		this.fuseConfig = fuseConfig;
		this.stage3D = stage3D;
		this.renderMode = renderMode;
		this.profile = profile;
		//this.frameRate = fuseConfig.frameRate;
		
		
	}
	
	public function init():Void
	{
		//Lib.current.stopAllMovieClips();
		
		workerSetup = new FrontWorkerSetup();
		workerSetup.onReady.add(OnWorkerReady);
		workerSetup.init();
	}
	
	function OnWorkerReady() 
	{
		context3DSetup = new Context3DSetup();
		context3DSetup.onComplete.add(OnContextCreated);
		context3DSetup.init(stage3D, renderMode, profile);
		
		var input:Input = new Input();
	}
	
	function OnContextCreated() 
	{
		//Fuse.current.cleanContext = context3DSetup.sharedContext;
		
		this.stage = fuse.stage = new Stage();
		renderer = new Renderer(context3DSetup.context3D, context3DSetup.sharedContext);
		
		AtlasBuffers.init(Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE);
		LayerCacheBuffers.init(Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE);
		
		root = Type.createInstance(rootClass, []);
		root.stage = fuse.stage;
		
		stage.addChild(root);
		
		setupComplete = true;
		dispatchEvent(new Event(FuseEvent.ROOT_CREATED));
	}
	
	public function start():Void
	{
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	public function stop():Void
	{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
	}
	
	private function Update(e:Event):Void 
	{
		process();
	}
	
	public function process():Void
	{
		if (!setupComplete) return;
		
		SnapTextField.updateDirtyTextFields();
		
		//trace("Update");
		workerSetup.lock();
		
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		
		if (Fuse.current.isStatic == 1) {
			Fuse.current.staticCount++;
		}
		else {
			Fuse.current.staticCount = 0;
		}
		if (Fuse.current.staticCount <= 2) {
			Fuse.current.conductorData.isStatic = 0;
		}
		else {
			Fuse.current.conductorData.isStatic = 1;
		}
		
		Fuse.current.isStatic = 1;
		
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		
		if (renderer != null) {
			renderer.update();
		}
		
		dimensionChange = false;
		if (stageWidth != stage.stageWidth) {
			stageWidth = stage.stageWidth;
			dimensionChange = true;
		}
		if (stageHeight != stage.stageHeight) {
			stageHeight = stage.stageHeight;
			dimensionChange = true;
		}
		if (dimensionChange) {
			//stage.forceRedraw();
		}
		
		Fuse.current.enterFrame.dispatch();
		
		workerSetup.unlock();
	}
}