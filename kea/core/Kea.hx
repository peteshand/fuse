package kea.core;

import kea.display.Sprite;
import kea.display.Stage;
import kea.core.render.layers.LayerDef;
import kea.core.render.Renderer;
import kea.core.render.UpdateList;
import kea.atlas.TextureAtlas;
import kea.core.profiling.ProfileMonitor;
import kea.model.Performance;

import kha.Canvas;
import kha.Scheduler;
import kha.System;
import kha.graphics2.Graphics;

class Kea {
	
	static var _current:Kea;
	public static var current(get, null):Kea;
	static var count:Int = 0;
	var index:Int;

	public var layerDef:LayerDef;
	public var renderer:Renderer;
	public var updateList:UpdateList;
	public var textureAtlas:TextureAtlas;
	public var stage:Stage;

	var profileMonitor:ProfileMonitor;

	// Models
	public var performance:Performance;

	//public static function __init__() {
	//	current = new Kea();
	//}
	public var onRender:Void -> Void;
	var g2:Graphics;

	public static inline function get_current():Kea
	{
		if (_current == null) _current = new Kea();
		return _current;
	}

	public function new()
	{
		index = count;
		count++;

		performance = new Performance();

		layerDef = new LayerDef();
		renderer = new Renderer();
		updateList = new UpdateList();
		textureAtlas = new TextureAtlas();
		profileMonitor = new ProfileMonitor();
		
		System.notifyOnRender(systemRender);
		Scheduler.addTimeTask(update, 0, 1 / 60);

	}

	function update(): Void {
		
	}

	public function systemRender(framebuffer:Canvas): Void
	{
		if (onRender != null) onRender();

		g2 = framebuffer.g2;
		
		//profileMonitor.prerender();
		
		Kea.current.textureAtlas.update();
		Kea.current.renderer.render(g2);

		//profileMonitor.postrender();

		count++;

		//root.transformAvailable.value = true;
	}

	public static function init(rootClass:Class<Sprite>): Void {
		System.init({title: "Project", width: 1024, height: 768}, function () {
			Kea.current.stage = new Stage(rootClass);
		});
	}
}
