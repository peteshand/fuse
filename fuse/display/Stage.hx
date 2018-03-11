package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.Sprite;
import fuse.display.Quad;
import fuse.Fuse;
import mantle.managers.resize.Resize;
import msignal.Signal.Signal1;

import openfl.Lib;
import openfl.events.Event;

class Stage extends Sprite {
	
	var count:Int = 0;
	var background:Quad;
	
	@:isVar public var stageWidth(default, set):Int;
	@:isVar public var stageHeight(default, set):Int;
	
	public var onDisplayAdded = new Signal1<DisplayObject>();
	public var onDisplayRemoved = new Signal1<DisplayObject>();
	
	public function new() 
	{	
		super();
		
		this.setStage(this);
		
		displayType = DisplayType.STAGE;
		//this.parentId = -1;
		Fuse.current.workerSetup.addChild(this, null);
		
		this.name = "stage";
		
		new Resize(Lib.current.stage);
		Resize.add(OnResize);
		OnResize();
	}
	
	private function OnResize():Void 
	{
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
