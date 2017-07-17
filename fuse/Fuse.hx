package fuse;

import fuse.core.KeaConfig;
import fuse.core.atlas.AtlasBuffers;
import fuse.core.layers.LayerCacheBuffers;
import fuse.core.memory.KeaMemory;
import fuse.core.memory.data.conductorData.ConductorData;
import fuse.display.containers.DisplayObject;
import fuse.display.containers.Stage;
import fuse.render.Context3DSetup;
import fuse.render.Renderer;
import fuse.worker.Workers;
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
	
	static var count:Int = 0;
	var index:Int;
	var atlasBuffers:AtlasBuffers;
	var layerCacheBuffers:LayerCacheBuffers;
	
	var rootClass:Class<DisplayObject>;
	var keaConfig:KeaConfig;
	var stage3D:Stage3D;
	var renderMode:Context3DRenderMode;
	var profile:Dynamic;
	var context3DSetup:Context3DSetup;
	
	var isWorker(get, null):Bool;
	
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
		renderer = new Renderer(context3DSetup.context3D);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
		
		atlasBuffers = new AtlasBuffers(keaConfig.atlasBuffers, 2048, 2048);
		layerCacheBuffers = new LayerCacheBuffers(2, 2048, 2048);
		
		stage = new Stage(rootClass);
	}
	
	private function Update(e:Event):Void 
	{
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
		
		renderer.update();
		
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