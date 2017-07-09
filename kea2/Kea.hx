package kea2;
import flash.events.Event;
import flash.display.Stage as OpenFLStage;
import kea.display.Sprite;
import kea2.core.atlas.AtlasBuffers;
import kea2.core.layers.LayerCacheBuffers;
import kea2.core.memory.KeaMemory;
import kea2.display.containers.Stage;
import kea.logic.Logic;
import kea.model.Model;
import kea.model.config.KeaConfig;
import kea2.render.Renderer;
import kea2.worker.Workers;
import kha.Canvas;
import kha.Scheduler;
import kha.System;
import kha.System.SystemOptions;
import kha.graphics2.Graphics;
import msignal.Signal.Signal0;
import openfl.Lib;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;

import flash.system.Worker;

class Kea
{
	public var keaMemory:KeaMemory;
	public var renderer:Renderer;
	//public var atlasBuffer:AtlasBuffer;
	public var stage:Stage;
	public var model:Model;
	public var logic:Logic;
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
	var rootClass:Class<Sprite>;
	var atlasBuffers:AtlasBuffers;
	var layerCacheBuffers:LayerCacheBuffers;
	
	public var workers:Workers;
	
	static function __init__():Void
	{
		current = new Kea();
		enterFrame = new Signal0();
	}
	
	public static function init(rootClass:Class<Sprite>, keaConfig:KeaConfig): Void {
		
		current.index = count;
		count++;
		
		if (Worker.current.isPrimordial) {
			//Kea.current.model.init(keaConfig);
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
		//model = new Model();
		
		
	}
	
	function start(rootClass:Class<Sprite>) 
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
		checkMemoryIsAvailable();
		
		Kea.enterFrame.dispatch();
		
		renderer.update();
	}
	
	function checkMemoryIsAvailable() 
	{
		var i:Int = 0;
		while (renderer.conductorData.busy == 1) {
			// wait
			//trace("wait");
			i++;
		}
	}

	function update(): Void {
		
	}

	public function systemRender(framebuffer:Canvas): Void
	{
		
		
		
		return;
		
		//
		//onRender.dispatch();
		//
		//logic.updater.execute();
		//
		//g2 = framebuffer.g2;
		//
		////profileMonitor.prerender();
		//
		///*
		 //* Loop through whole displaylist in a Hierarchical order and calculate their transform matrix
		 //* TODO: skip items that are currently in cached layer
		//*/
		//logic.displayList.update(g2);	// Hierarchical
		//
		//
		///*
		 //* - Loops through whole displaylist in linear order and updates isStatic
		 //* - If Renderer.layerStateChangeAvailable == true
		 //* -- Order displaylist by layerIndex > low to high
		 //* -- Group displaylist items into cache and direct render layers
		 //* Calculate cache vs direct layers
		//*/
		//logic.layerConstruct.update();	// Linear
		//
		//// Calculate texture draw order and generate atlas buffers
		//logic.atlasBuffer.update();		// Linear
		//
		//// Draw renderables in linear order (cache and direct layers)
		//logic.renderer.render(g2);		// Linear
		//
		////profileMonitor.postrender();
		//
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