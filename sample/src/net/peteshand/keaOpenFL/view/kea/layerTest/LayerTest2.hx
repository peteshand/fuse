package net.peteshand.keaOpenFL.view.kea.layerTest;

import hxColorToolkit.spaces.RGB;
import kea.Kea;
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

using hxColorToolkit.ColorToolkit;
/**
 * ...
 * @author P.J.Shand
 */
class LayerTest2 extends Sprite
{
	var images:Array<Image> = [];
	var count:Int = 0;
	var offset:Int = 0;
	
	public function new() 
	{
		super();
		this.name = "LayerTest2";
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		Assets.loadEverything(OnLoadComplete);
	}

	function OnLoadComplete(): Void
	{
		this.rotation = 45;
		for (i in 0...10) 
		{
			var container:Sprite = new Sprite();
			container.rotation = -45;
			addChild(container);
			container.x = 50 * i;
			
			//var color:Color = Color.fromFloats(Math.random(), Math.random(), Math.random(), 1);
			var colour = new RGB(Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF));
			var quad:Quad = new Quad(250, 250, colour.getColor());
			container.addChild(quad);
			//quad.x = 200 * i;
			
			var image:Image = new Image(Assets.images.kea);
			//image.width = 250;
			//image.height = 250;
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			
			image.layerIndex = 1;
			container.addChild(image);
			images.push(image);
			
			//image.blendMode = BlendMode.MULTIPLY;
			//image.x = 200 * i;
			
		}
		Keyboard.get().notify(OnDown, OnUp);
		
		Kea.current.onRender.add(update);
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
				//setRandom();
				trace('release A');
			}
			default: return;
		}
	}
	
	override public function update() 
	{
		count++;
		if (count % 200 < 100) {
			offset++;
			for (i in 0...images.length) 
			{
				images[i].x = 250 + (Math.sin(offset / 180 * Math.PI) * 200);
			}
		}
	}
	
}