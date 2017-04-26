package kea;
import kea.display.Sprite;
import kea.display.Stage;
import kea.logic.Logic;
import kea.model.Model;
import kha.Canvas;
import kha.Scheduler;
import kha.System;
import kha.System.SystemOptions;
import kha.graphics2.Graphics;
import msignal.Signal.Signal0;

class Kea
{
	public var stage:Stage;
	public var model:Model;
	public var logic:Logic;
	public var onRender:Signal0;
	
	var index:Int;
	var g2:Graphics;
	
	@:isVar 
	public static var current(get, null):Kea;
	
	static var rootClass:Class<Sprite>;
	static var calcTransformIndex:Int = 0;
	static var count:Int = 0;
	
	static function __init__():Void
	{
		current = new Kea();
	}

	public function new() { }
	
	public static function init(rootClass:Class<Sprite>): Void {
		
		current.index = count;
		count++;
		
		Kea.rootClass = rootClass;
		var options:SystemOptions = { title: "Project", width: 1920, height: 1080 };
		System.init(options, OnKhaSetupComplete);
	}
	
	static private function OnKhaSetupComplete() 
	{
		current.onRender = new Signal0();
		current.model = new Model();
		current.logic = new Logic();
		
		System.notifyOnRender(current.systemRender);
		Scheduler.addTimeTask(current.update, 0, 1 / 60);
		
		Kea.current.stage = new Stage(rootClass);
	}
	
	public static inline function get_current():Kea
	{
		return current;
	}

	function update(): Void {
		
	}

	public function systemRender(framebuffer:Canvas): Void
	{
		onRender.dispatch();
		
		g2 = framebuffer.g2;
		
		//profileMonitor.prerender();
		
		/*
		 * Loop through whole displaylist in a Hierarchical order and calculate their transform matrix
		 * TODO: skip items that are currently in cached layer
		*/
		logic.displayList.update(g2);	// Hierarchical
		
		
		logic.updater.execute();
		/*
		 * - Loops through whole displaylist in linear order and updates isStatic
		 * - If Renderer.layerStateChangeAvailable == true
		 * -- Order displaylist by layerIndex > low to high
		 * -- Group displaylist items into cache and direct render layers
		 * Calculate cache vs direct layers
		*/
		logic.layerConstruct.update();	// Linear
		
		// Calculate texture draw order and generate atlas buffers
		logic.atlasBuffer.update();		// Linear
		
		// Draw renderables in linear order (cache and direct layers)
		logic.renderer.render(g2);		// Linear
		
		//profileMonitor.postrender();
		
		count++;
	}
}
