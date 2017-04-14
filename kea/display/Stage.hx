package kea.display;

import kea.display.Sprite;
import kea.atlas.TextureAtlas;
import kha.graphics2.Graphics;

class Stage extends Sprite {
	
	var root:Sprite;
	var count:Int = 0;

	public var textureAtlas:TextureAtlas;
	//public var layerRenderer:LayerRenderer;
	
	//public var renderList:Array<IDisplay> = [];

	public function new(RootClass:Class<Sprite>) 
	{	
		super();
		
		this.name = "stage";

		textureAtlas = new TextureAtlas();
		
		stage = this;

		root = Type.createInstance(RootClass, []);
		
		//layerRenderer = new LayerRenderer(this, root);

		addChild(root);
	}

	override function get_renderIndex():Null<Int> 
	{
		return 0;
	}
}
