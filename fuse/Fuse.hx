package fuse;

import fuse.core.front.KeaConfig;
import fuse.core.front.atlas.AtlasBuffers;
import fuse.core.front.layers.LayerCacheBuffers;
import fuse.core.front.memory.KeaMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.display.DisplayObject;
import fuse.display.Stage;
import fuse.render.Context3DSetup;
import fuse.render.Renderer;
import fuse.core.Workers;
import openfl.display.Stage3D;

import msignal.Signal.Signal0;

import openfl.Lib;
import openfl.events.Event;

import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.EventDispatcher;

#if flash
import flash.system.Worker;
#end

@:access(fuse)
class Fuse extends EventDispatcher
{
	static public inline var ROOT_CREATED:String = "rootCreated";
	
	@:isVar 
	public static var current(default, null):Fuse;
	public static var enterFrame:Signal0 = new Signal0();
	
	public var keaMemory:KeaMemory;
	public var renderer:Renderer;
	public var stage:Stage;
	public var frameRate(get, set):Float;
	public var onRender:Signal0;
	public var workers:Workers;
	public var staticCount:Int = 0;
	public var isStatic:Int = 0;
	public var conductorData:ConductorData;
	public var root:DisplayObject;
	
	static var count:Int = 0;
	var index:Int;
	//var atlasBuffers:AtlasBuffers;
	
	var rootClass:Class<DisplayObject>;
	var keaConfig:KeaConfig;
	var stage3D:Stage3D;
	var renderMode:Context3DRenderMode;
	var profile:Dynamic;
	var context3DSetup:Context3DSetup;
	
	var isWorker(get, null):Bool;
	var setupComplete:Bool = false;
	
	var stageWidth:Int;
	var stageHeight:Int;
	var dimensionChange:Bool = false;
	
	public function new(rootClass:Class<DisplayObject>, keaConfig:KeaConfig, stage3D:Stage3D=null, renderMode:Context3DRenderMode = AUTO, profile:Array<Context3DProfile> = null)
	{	
		super();
		
		Fuse.current = this;
		index = count++;
		
		this.rootClass = rootClass;
		this.keaConfig = keaConfig;
		this.stage3D = stage3D;
		this.renderMode = renderMode;
		this.profile = profile;
		//this.frameRate = keaConfig.frameRate;
		
		
	}
	
	public function init():Void
	{
		Lib.current.stopAllMovieClips();
		
		workers = new Workers();
		workers.onReady.add(OnWorkerReady);
		workers.init();
	}
	
	function OnWorkerReady() 
	{
		if (!isWorker) {
			context3DSetup = new Context3DSetup();
			context3DSetup.onComplete.add(OnContextCreated);
			context3DSetup.init(stage3D, renderMode, profile);
		}
	}
	
	function OnContextCreated() 
	{
		stage = new Stage();
		renderer = new Renderer(context3DSetup.context3D, context3DSetup.sharedContext);
		
		AtlasBuffers.init(2048, 2048);
		LayerCacheBuffers.init(2048, 2048);
		
		root = Type.createInstance(rootClass, []);
		root.stage = stage;
		stage.addChild(root);
		
		setupComplete = true;
		dispatchEvent(new Event(Fuse.ROOT_CREATED));
	}
	
	public function start():Void
	{
		if (isWorker) return;
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	public function stop():Void
	{
		if (isWorker) return;
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
	}
	
	private function Update(e:Event):Void 
	{
		process();
	}
	
	public function process():Void
	{
		if (isWorker) return;
		if (!setupComplete) return;
		
		//trace("Update");
		workers.condition.mutex.lock();
		
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
		
		Fuse.enterFrame.dispatch();
		
		workers.condition.notifyAll();
		workers.condition.mutex.unlock();
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
	
	function get_isWorker():Bool 
	{
		#if flash
			return Worker.current.isPrimordial == false;
		#else
			return false;
		#end
	}
}