package kea2.display.containers;

import flash.display.BitmapData;
import kea.display.Sprite;
import kea2.display._private.Background;
import kea.texture.Texture;
import kea.util.ColourUtils;
import kea2.Kea;
import kea2.display.renderables.Quad;
import kha.Color;
import kha.System;
import kha.graphics2.Graphics;

class Stage extends Sprite {
	
	var root:Sprite;
	var count:Int = 0;
	var background:Quad;

	//public var textureAtlas:TextureAtlas;
	
	@:isVar public var stageWidth(get, null):Int;
	@:isVar public var stageHeight(get, null):Int;
	
	//public var layerRenderer:LayerRenderer;
	
	//public var renderList:Array<IDisplay> = [];

	public function new(RootClass:Class<Sprite>) 
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
	
	override function set_color(value:Color):Color { 
		
		var value2:Color = ColourUtils.addMissingAlpha(value, 0xFF);
		
		if (color != value2){
			color = value2;
			
			//background.color = color;
			/*if (background != null) {
				if (background.parent != null) {
					background.parent.removeChild(background);
				}
			}
			background = new Quad(32, 32, color);
			stage.addChildAt(background, 0);*/
			
			isStatic = 0;
		}
		return value;
	}
	
	
	/*override function get_renderIndex():Null<Int> 
	{
		return 0;
	}*/
	
	function get_stageHeight():Int 
	{
		return System.windowHeight();
	}
	
	function get_stageWidth():Int 
	{
		return System.windowWidth();
	}
}
