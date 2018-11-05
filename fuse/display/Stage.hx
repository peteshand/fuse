package fuse.display;

import fuse.camera.Camera2D;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.front.FuseConfig;
import fuse.display.Sprite;
import fuse.display.Quad;
import fuse.Fuse;
import fuse.utils.Color;
import mantle.managers.resize.Resize;
import notifier.Notifier;
import msignal.Signal.Signal1;

import openfl.Lib;
import openfl.events.Event;

#if html5
import js.Browser;
#end

class Stage extends Sprite {
	
	var count:Int = 0;
	var background:Quad;
	
	@:isVar public var stageWidth(default, set):Int;
	@:isVar public var stageHeight(default, set):Int;
	
	public var onDisplayAdded = new Signal1<DisplayObject>();
	public var onDisplayRemoved = new Signal1<DisplayObject>();
	public var camera = new Camera2D();
	public var focus = new Notifier<DisplayObject>();
	//var stageColor:Color = 0xFF000000;
	//public var transparent:Bool;
	
	public function new() 
	{	
		super();
		
		
		
		this.setStage(this);
		
		displayType = DisplayType.STAGE;
		//this.parentId = -1;
		Fuse.current.workerSetup.addChild(this, null);
		this.touchable = true;
		this.name = "stage";
		
		new Resize(Lib.current.stage);
		Resize.add(OnResize);
		OnResize();
	}
	
	function configure(fuseConfig:FuseConfig) 
	{
		#if html5
			/*var configColor:UInt = Lib.current.stage.window.config.background;
			var bgColor:String = "#";
			if (fuseConfig.transparent) {
				trace("A");
				var c:Color = Lib.current.stage.window.config.background;
				var c2:Color = 0x0;
				c2.alpha = c.red;
				c2.red = c.green;
				c2.green = c.blue;
				c2.blue = c.alpha;
				trace([c2.red, c2.green, c2.blue, c2.alpha]);
				bgColor += StringTools.hex(c2, 8);
			}
			else {
				trace("B");
				bgColor += StringTools.hex(Lib.current.stage.window.config.background, 6);
			}
			
			trace("bgColor = " + bgColor);
			//Lib.current.stage.window.config.element.style.background = bgColor;
			Lib.current.stage.window.element.style.setProperty("background", bgColor);*/
			trace("TODO: fix set background color");
			Reflect.setProperty(Browser.window, "stageWindow", Lib.current.stage.window);
		#end
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
	
	//override function set_color(value:Color):Color { 
		//return stageColor = value;
	//}
	//
	//override function get_color():Color { 
		//if (transparent) stageColor.alpha = 0;
		//else stageColor.alpha = 0xFF;
		//return stageColor;
	//}
}
