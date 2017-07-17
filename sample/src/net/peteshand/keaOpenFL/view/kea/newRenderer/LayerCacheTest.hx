package net.peteshand.keaOpenFL.view.kea.newRenderer;

import fuse.Kea;
import fuse.display.containers.Sprite;
import fuse.display.renderables.Image;
import fuse.render.Renderer;
import fuse.texture.BitmapTexture;
import fuse.texture.RenderTexture;
import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class LayerCacheTest extends Sprite
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
		var bmd2:BitmapData = Assets.getBitmapData("img/keaSquare2.png");
		var texture2:BitmapTexture = new BitmapTexture(bmd2, false);
		
		var mod:Float = 3;
		var numQuads:Int = 6;// Renderer.bufferSize;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{
			//if (j % Math.floor(mod) == 0) {
			if (j >= 2 && j < 4) {	
				trace("B");
				image1 = new Image(texture2);
				//image1.rotation = 3 + (j * 10);
			}
			else {
				trace("A");
				image1 = new Image(texture1);
				images.push(image1);
				
			}
			
			image1.x = (50 * j);// Math.random() * 1600;
			image1.y = (50 * j);//Math.random() * 900;
				
			image1.scaleX = image1.scaleY = 1;
			//image1.pivotX = image1.width / 2;
			//image1.pivotY = image1.height / 2;
			addChild(image1);
			
			
			mod += 0.25;
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