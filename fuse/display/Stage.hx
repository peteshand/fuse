package fuse.display;

import fuse.camera.Camera2D;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.front.FuseConfig;
import fuse.display.Sprite;
import fuse.display.Quad;
import fuse.Fuse;
import fuse.utils.Color;
import resize.Resize;
import notifier.Notifier;
import signals.Signal1;
import fuse.utils.Orientation;
import openfl.Lib;
import openfl.events.Event;
#if html5
import js.Browser;
#end

class Stage extends Sprite {
	var count:Int = 0;
	var background:Quad;
	var _width:Int;
	var _height:Int;
	var fuseConfig:FuseConfig;

	@:isVar public var windowWidth(default, null):Int;
	@:isVar public var windowHeight(default, null):Int;
	@:isVar public var stageWidth(default, null):Int;
	@:isVar public var stageHeight(default, null):Int;
	@:isVar public var orientation(default, set):Orientation = Orientation.LANDSCAPE;
	public var onDisplayAdded = new Signal1<DisplayObject>();
	public var onDisplayRemoved = new Signal1<DisplayObject>();
	public var camera = new Camera2D();
	public var focus = new Notifier<DisplayObject>();

	public function new() {
		super();

		this.setStage(this);

		displayType = DisplayType.STAGE;
		Fuse.current.workerSetup.addChild(this, null);
		this.touchable = true;
		this.name = "stage";
		
		Resize.add(onResize);
		onResize();
	}

	function initialize() {}

	function configure(fuseConfig:FuseConfig) {
		this.fuseConfig = fuseConfig;
		#if html5
		Reflect.setProperty(Browser.window, "stageWindow", Lib.current.stage.window);
		#end
	}

	function set_orientation(value:Orientation):Orientation {
		if (orientation != value) {
			orientation = value;
			onResize();
		}
		return value;
	}

	private function onResize():Void {
		updateDimensions(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Fuse.current.workerSetup.resize(stageWidth, stageHeight, windowWidth, windowHeight);
	}

	public function updateDimensions(_width:Int, _height:Int) {
		if (fuseConfig != null) {
			if (fuseConfig.width != null)
				_width = fuseConfig.width;
			if (fuseConfig.height != null)
				_height = fuseConfig.height;
		}

		this.windowWidth = _width;
		this.windowHeight = _height;
		switch orientation {
			case Orientation.LANDSCAPE | Orientation.LANDSCAPE_FLIPPED:
				this.stageWidth = _width;
				this.stageHeight = _height;
				this.x = (orientation / 180) * windowWidth;
				this.y = (orientation / 180) * windowHeight;
			case Orientation.PORTRAIT | Orientation.PORTRAIT_FLIPPED:
				this.stageWidth = _height;
				this.stageHeight = _width;
				this.x = (1 - ((orientation - 90) / 180)) * windowWidth;
				this.y = ((orientation - 90) / 180) * windowHeight;	
		}

		this.rotation = orientation;
	}
}
