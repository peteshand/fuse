package kea.display;

import kea.display.Sprite;
import kea.model.buffers.atlas.TextureAtlas;
import kha.System;
import kha.graphics2.Graphics;

class Stage extends Sprite {
	
	var root:Sprite;
	var count:Int = 0;

	public var textureAtlas:TextureAtlas;
	
	@:isVar public var stageWidth(get, null):Int;
	@:isVar public var stageHeight(get, null):Int;
	
	//public var layerRenderer:LayerRenderer;
	
	//public var renderList:Array<IDisplay> = [];

	public function new(RootClass:Class<Sprite>) 
	{	
		super();
		
		this.name = "stage";
		
		textureAtlas = new TextureAtlas();
		
		stage = this;
		
		root = Type.createInstance(RootClass, []);
		root.stage = this;
		//layerRenderer = new LayerRenderer(this, root);

		addChild(root);
	}
	
	override function get_renderIndex():Null<Int> 
	{
		return 0;
	}
	
	function get_stageHeight():Int 
	{
		return System.windowHeight();
	}
	
	function get_stageWidth():Int 
	{
		return System.windowWidth();
	}
}
