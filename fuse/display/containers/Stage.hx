package fuse.display.containers;

import flash.display.BitmapData;
import hxColorToolkit.spaces.Color;
import fuse.Kea;
import fuse.display.renderables.Quad;
import openfl.Lib;

class Stage extends Sprite {
	
	var root:DisplayObject;
	var count:Int = 0;
	var background:Quad;

	//public var textureAtlas:TextureAtlas;
	
	@:isVar public var stageWidth(get, null):Int;
	@:isVar public var stageHeight(get, null):Int;
	
	//public var layerRenderer:LayerRenderer;
	
	//public var renderList:Array<IDisplay> = [];

	public function new(RootClass:Class<DisplayObject>) 
	{	
		stage = this;
		
		super();
		
		this.parentId = -1;
		//displayDataAccess.parentId = -1;
		Kea.current.workers.addChild(this, null);
		
		
		
		
		
		this.name = "stage";
		
		//textureAtlas = new TextureAtlas();
		
		/*background = new Quad(stageWidth, stageHeight, 0xFFFFFFFF);
		addChild(background);*/
		
		root = Type.createInstance(RootClass, []);
		root.stage = this;
		//layerRenderer = new LayerRenderer(this, root);

		addChild(root);
		
		
		
	}
	
	//override function set_color(value:Color):Color { 
		//
		//var value2:Color = ColourUtils.addMissingAlpha(value, 0xFF);
		//
		//if (color != value2){
			//color = value2;
			//
			////background.color = color;
			///*if (background != null) {
				//if (background.parent != null) {
					//background.parent.removeChild(background);
				//}
			//}
			//background = new Quad(32, 32, color);
			//stage.addChildAt(background, 0);*/
			//
			//isStatic = 0;
		//}
		//return value;
	//}
	
	
	/*override function get_renderIndex():Null<Int> 
	{
		return 0;
	}*/
	
	function get_stageHeight():Int 
	{
		return Lib.current.stage.stageHeight;
	}
	
	function get_stageWidth():Int 
	{
		return Lib.current.stage.stageWidth;
	}
}
