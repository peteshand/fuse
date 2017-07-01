package net.peteshand.keaOpenFL.view.kea.old.layerTest;

import kea.display.BlendMode;
import kea.display.Image;
import kea.display.Quad;
import kea.display.Sprite;
import kha.Assets;
import kha.Color;
import kha.Key;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.input.Keyboard;

/**
 * ...
 * @author P.J.Shand
 */
class LayerTest extends Sprite
{
	var image:Image;

	public function new() 
	{
		super();
		this.name = "Test1";
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		Assets.loadEverything(OnLoadComplete);
	}

	function OnLoadComplete(): Void
	{
		this.rotation = 45;
		for (i in 0...1) 
		{
			var container:Sprite = new Sprite();
			container.rotation = -45;
			addChild(container);
			container.x = 50 * i;
			
			//var color:Color = Color.fromFloats(Math.random(), Math.random(), Math.random(), 1);
			var color:Color = Color.Green;
			var quad:Quad = new Quad(250, 250, color);
			container.addChild(quad);
			//quad.x = 200 * i;
			
			image = new Image(Assets.images.kea);
			//image.width = 250;
			//image.height = 250;
			image.layerIndex = 1;
			container.addChild(image);
			//image.blendMode = BlendMode.MULTIPLY;
			//image.x = 200 * i;
			
		}
		Keyboard.get().notify(OnDown, OnUp);
	}
	
	function OnDown(key:Key, char:String) 
	{
		switch(key) {
			case UP:trace("the UP key is pressed");
			case DOWN:trace("the DOWN key is pressed");
			case CHAR: if (char == 'a') trace('press A');
			default: return;
		}
	}
	
	function OnUp(key:Key, char:String) 
	{
		switch(key) {
			case UP:trace("the UP key is pressed");
			case DOWN:trace("the DOWN key is pressed");
			case CHAR: if (char == 'a') {
				setRandom();
				trace('release A');
			}
			default: return;
		}
	}
	
	function setRandom() 
	{
		var shaderPipeline:PipelineState = new PipelineState();
		shaderPipeline.fragmentShader = Shaders.painter_image_frag;
		shaderPipeline.vertexShader = Shaders.painter_image_vert;
		
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		shaderPipeline.inputLayout = [structure];
		
		var blends:Array<BlendingFactor> = [
			BlendingFactor.BlendOne,
			BlendingFactor.BlendZero,
			BlendingFactor.DestinationAlpha,
			BlendingFactor.DestinationColor,
			BlendingFactor.InverseDestinationAlpha,
			BlendingFactor.InverseDestinationColor,
			BlendingFactor.InverseSourceAlpha,
			BlendingFactor.InverseSourceColor,
			BlendingFactor.SourceAlpha,
			BlendingFactor.SourceColor,
			BlendingFactor.Undefined
		];
		
		shaderPipeline.blendSource = blends[Math.floor(Math.random() * blends.length)];
		shaderPipeline.blendDestination = blends[Math.floor(Math.random() * blends.length)];
		shaderPipeline.alphaBlendSource = blends[Math.floor(Math.random() * blends.length)];
		shaderPipeline.alphaBlendDestination = blends[Math.floor(Math.random() * blends.length)];
		
		shaderPipeline.compile();
		
		image.shaderPipeline = shaderPipeline;
		image.isStatic = false;
	}
	
}