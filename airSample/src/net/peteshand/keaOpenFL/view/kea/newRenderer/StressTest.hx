package net.peteshand.keaOpenFL.view.kea.newRenderer;

import kea.display.Sprite;
import kea2.Kea;
import kea2.display.renderables.Image;
import kea2.render.Renderer;
import kea2.texture.BitmapTexture;
import kea2.texture.RenderTexture;
import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class StressTest extends Sprite
{
	var images:Array<Image> = [];
	var image1:Image;
	
	public function new() 
	{
		super();
		
		
	}
	
	public function init() 
	{
		var bmd1:BitmapData = Assets.getBitmapData("img/keaSquare.png");
		var texture1:BitmapTexture = new BitmapTexture(bmd1, false);
		
		var numQuads:Int = 5000;// Renderer.bufferSize;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{
			image1 = new Image(texture1);
			image1.x = Math.random() * 1600;
			image1.y = Math.random() * 900;
			image1.scaleX = image1.scaleY = 0.2;
			image1.pivotX = image1.width / 2;
			image1.pivotY = image1.height / 2;
			addChild(image1);
			images.push(image1);	
		}
		
		Kea.enterFrame.add(OnTick);
	}
	
	function OnTick() 
	{
		for (i in 0...images.length) 
		{
			images[i].rotation++;
		}
	}
}