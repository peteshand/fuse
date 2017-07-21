package fuse.display.containers;

import fuse.display.renderables.Quad;
import fuse.Fuse;

import openfl.Lib;
import openfl.events.Event;

class Stage extends Sprite {
	
	var count:Int = 0;
	var background:Quad;
	
	@:isVar public var stageWidth(default, set):Int;
	@:isVar public var stageHeight(default, set):Int;
	
	public function new() 
	{	
		stage = this;
		
		super();
		
		this.parentId = -1;
		Fuse.current.workers.addChild(this, null);
		
		this.name = "stage";
		
		Lib.current.stage.addEventListener(Event.RESIZE, OnStageResize);
		OnStageResize(null);
	}
	
	private function OnStageResize(e:Event):Void 
	{
		/*trace(["OnStageResize", Lib.current.stage.stageWidth, Lib.current.stage.stageHeight]);*/
		this.stageWidth = Lib.current.stage.stageWidth;
		this.stageHeight = Lib.current.stage.stageHeight;
	}
	
	function set_stageHeight(value:Int):Int 
	{
		if (stageHeight != value) {
			stageHeight = value;
			Fuse.current.conductorData.stageHeight = value;
		}
		return value;
	}
	
	function set_stageWidth(value:Int):Int 
	{
		if (stageWidth != value) {
			stageWidth = value;
			Fuse.current.conductorData.stageWidth = value;
		}
		return value;
	}
}
