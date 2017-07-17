package net.peteshand.keaOpenFL.view.kea.newRenderer;

import fuse.display.containers.Sprite;
import fuse.Kea;
import fuse.display.renderables.Image;
import fuse.render.Renderer;
import fuse.texture.BitmapTexture;
import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class NonPowerOfTwo extends Sprite
{
	var images:Array<Image> = [];
	
	public function new() 
	{
		super();
		
		
	}
	
	public function init() 
	{
		var bmd1:BitmapData = Assets.getBitmapData("img/kea.png");
		var bmd2:BitmapData = Assets.getBitmapData("img/keaSquare2.png");
		//var bmd:BitmapData = new BitmapData(256, 256, true, 0x44FFFFFF);
		
		var texture1:BitmapTexture = new BitmapTexture(bmd1, true, onTextureUploadComplete);
		var texture2:BitmapTexture = new BitmapTexture(bmd2);
		
		var numQuads:Int = 1;// Renderer.bufferSize;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{
			/*var quad:Quad = new Quad(200, 200, 0xFF00FF00);
			quad.pivotX = 100;
			quad.pivotY = 100;
			quad.x = 100;// 500 + Math.floor((stage.stageWidth - 500) * Math.random());
			quad.y = 100;// Math.floor(stage.stageHeight * Math.random());
			addChild(quad);
			quad.rotation = 45;*/
			
			
			
			var image1:Image = new Image(texture1);
			image1.x = image1.width / 2;
			image1.y = image1.height / 2;
			image1.scaleX = image1.scaleY = 1;
			image1.pivotX = image1.width / 2;
			image1.pivotY = image1.height / 2;
			addChild(image1);
			images.push(image1);
			
			var image2:Image = new Image(texture2);
			image2.x = Math.random() * 1600;
			image2.y = Math.random() * 900;
			image2.scaleX = image2.scaleY = 1;
			image2.pivotX = image2.width / 2;
			image2.pivotY = image2.height / 2;
			addChild(image2);
			images.push(image2);
		}
		
		//Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
		Kea.enterFrame.add(OnTick);
	}
	
	function onTextureUploadComplete() 
	{
		trace("onTextureUploadComplete");
	}
	
	function OnTick() 
	{
		for (i in 0...images.length) 
		{
			images[i].rotation += 1;
		}
	}
	
	/*private function Update(e:Event):Void 
	{
		
	}*/
}