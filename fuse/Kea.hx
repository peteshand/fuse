package fuse;
import flash.events.Event;
import flash.display.Stage as OpenFLStage;
import fuse.core.KeaConfig;
import fuse.core.atlas.AtlasBuffers;
import fuse.core.layers.LayerCacheBuffers;
import fuse.core.memory.KeaMemory;
import fuse.core.memory.data.conductorData.ConductorData;
import fuse.display.containers.DisplayObject;
import fuse.display.containers.Stage;
import fuse.render.Renderer;
import fuse.worker.Workers;
import kha.Canvas;
import kha.Scheduler;
import kha.System;
import kha.System.SystemOptions;
import kha.graphics2.Graphics;
import msignal.Signal.Signal0;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;

import flash.system.Worker;

class Kea
{
	public var keaMemory:KeaMemory;
	public var renderer:Renderer;
	//public var atlasBuffer:AtlasBuffer;
	public var stage:Stage;
	@:isVar public var frameRate(get, set):Int;
	public var keaConfig:KeaConfig;
	public var onRender:Signal0;
	
	var index:Int;
	var g2:Graphics;
	
	public static var enterFrame:Signal0;
	
	@:isVar 
	public static var current(get, null):Kea;
	
	//static var rootClass:Class<Sprite>;
	static var calcTransformIndex:Int = 0;
	static var count:Int = 0;
	var rootClass:Class<DisplayObject>;
	var atlasBuffers:AtlasBuffers;
	var layerCacheBuffers:LayerCacheBuffers;
	
	public var workers:Workers;
	public var staticCount:Int = 0;
	public var isStatic:Int = 0;
	public var conductorData:ConductorData;
	
	static function __init__():Void
	{
		current = new Kea();
		enterFrame = new Signal0();
	}
	
	public static function init(rootClass:Class<DisplayObject>, keaConfig:KeaConfig): Void {
		
		current.index = count;
		count++;
		
		if (Worker.current.isPrimordial) {
			//Kea.rootClass = rootClass;
			//var options:SystemOptions = { title: "Project", width: 1920, height: 1080 };
			//System.init(options, OnKhaSetupComplete);
			Kea.current.keaConfig = keaConfig;
			Kea.current.frameRate = keaConfig.frameRate;
			//Kea.current.start(rootClass);
			//OnKeaSetupComplete();
		}
		Kea.current.start(rootClass);
	}
	
	static private function OnKeaSetupComplete() 
	{
		//current.onRender = new Signal0();
		//current.logic = new Logic();
		
		//current.logic.displayList.init();
		//current.logic.atlasBuffer.add( -1, current.logic.displayList.background);
		
		//System.notifyOnRender(current.systemRender);
		//Scheduler.addTimeTask(current.update, 0, 1 / 60);
		
		//Kea.current.stage = new Stage(rootClass);
	}
	
	public static inline function get_current():Kea
	{
		return current;
	}
	
	
	public function new() { 
		
		
	}
	
	function start(rootClass:Class<DisplayObject>) 
	{
		this.rootClass = rootClass;
		
		
		workers = new Workers();
		workers.onReady.add(OnWorkersReady);
		workers.init();
	}
	
	function OnWorkersReady() 
	{
		if (Worker.current.isPrimordial) {
			setupMemory();
			setupStage3D();
		}
	}
	
	function setupMemory() 
	{
		
	}
	
	function setupStage3D() 
	{
		Lib.current.stopAllMovieClips();
		var stage:OpenFLStage = Lib.current.stage;
		stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onStage3DInit );
		stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD_EXTENDED);
	}
	
	private function onStage3DInit(e:Event):Void 
	{
		var openFLStage:OpenFLStage = Lib.current.stage;
		renderer = new Renderer(openFLStage.stage3Ds[0]/*, workers.vertexData*/);
		openFLStage.addEventListener(Event.ENTER_FRAME, Update);
		
		atlasBuffers = new AtlasBuffers(keaConfig.atlasBuffers, 2048, 2048);
		layerCacheBuffers = new LayerCacheBuffers(2, 2048, 2048);
		
		stage = new Stage(rootClass);
		
		//atlasBuffer = new AtlasBuffer();
		
	}
	
	private function Update(e:Event):Void 
	{
		//trace("Update");
		workers.condition.mutex.lock();
		
		
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		
		if (Kea.current.isStatic == 1) {
			Kea.current.staticCount++;
		}
		else {
			Kea.current.staticCount = 0;
		}
		if (Kea.current.staticCount <= 2) {
			Kea.current.conductorData.isStatic = 0;
		}
		else {
			Kea.current.conductorData.isStatic = 1;
		}
		
		Kea.current.isStatic = 1;
		
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		
		renderer.update();
		
		//checkMemoryIsAvailable();
		
		
		
		
		Kea.enterFrame.dispatch();
		
		
		
		
		workers.condition.notifyAll();
		workers.condition.mutex.unlock();
		
		
		
	}
	
	function checkMemoryIsAvailable() 
	{
		//var i:Int = 0;
		//while (renderer.conductorData.busy == 1) {
			//// wait
			////trace("wait");
			//i++;
		//}
	}

	function update(): Void {
		
	}

	public function systemRender(framebuffer:Canvas): Void
	{
		
		
		
		return;
		
		count++;
	}
	
	function get_frameRate():Int 
	{
		return frameRate;
	}
	
	function set_frameRate(value:Int):Int 
	{
		frameRate = value;
		flash.Lib.current.stage.frameRate = frameRate;
		return frameRate;
	}
}