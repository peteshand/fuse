package net.peteshand.keaOpenFL.view.kea.newRenderer;

import fuse.display.containers.Sprite;
import fuse.Kea;
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
class RenderTextureTest extends Sprite
{
	var images:Array<Image> = [];
	var renderTexture:RenderTexture;
	var image2:Image;
	var image1:Image;
	
	public function new() 
	{
		super();
		
		
	}
	
	public function init() 
	{
		var bmd1:BitmapData = Assets.getBitmapData("img/keaSquare.png");
		var bmd2:BitmapData = Assets.getBitmapData("img/keaSquare2.png");
		
		//var bmd:BitmapData = new BitmapData(256, 256, true, 0x44FFFFFF);
		
		
		
		var texture1:BitmapTexture = new BitmapTexture(bmd1, false);
		var texture2:BitmapTexture = new BitmapTexture(bmd2, false);
		
		var bmd = new BitmapData(512, 512, true, 0xFFFF0000);
		
		/*var numQuads:Int = 1;// Renderer.bufferSize;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{*/
			image1 = new Image(texture1);
			image1.x = 0;
			image1.y = 0;
			image1.scaleX = image1.scaleY = 1;
			//image1.pivotX = image1.width / 2;
			//image1.pivotY = image1.height / 2;
			addChild(image1);
			//images.push(image1);
			
			image2 = new Image(texture2);
			image2.x = 100;
			image2.y = 100;
			image2.scaleX = image2.scaleY = 1;
			//image2.pivotX = image2.width / 2;
			//image2.pivotY = image2.height / 2;
			addChild(image2);
			//images.push(image2);
			
			/*var image3 = new Image(texture3);
			image3.x = 200;
			image3.y = 200;
			image3.scaleX = image3.scaleY = 1;
			//image3.pivotX = image3.width / 2;
			//image3.pivotY = image3.height / 2;
			addChild(image3);
			//images.push(image3);*/
		//}
		
		
		//renderTexture = new RenderTexture(512, 512);
		//
		//
		//
		//
		//var renderTextureImage:Image = new Image(renderTexture);
		//renderTextureImage.x = 200;
		//renderTextureImage.y = 400;
		//renderTextureImage.scaleX = renderTextureImage.scaleY = 1;
		////renderTextureImage.pivotX = renderTextureImage.width / 2;
		////renderTextureImage.pivotY = renderTextureImage.height / 2;
		//addChild(renderTextureImage);
		////images.push(renderTextureImage);
		//
		///*var renderTextureImage:Image = new Image(texture3);
		//renderTextureImage.x = 100;
		//renderTextureImage.y = 500;
		//addChild(renderTextureImage);
		//images.push(renderTextureImage);*/
		//
		//Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
		Kea.enterFrame.add(OnTick);
	}
	
	var count:Int = 0;
	var texture3:BitmapTexture;
	
	function OnTick() 
	{
		count++;
		if (count == 30) {
			
			var bmd3:BitmapData = Assets.getBitmapData("img/kea2.png");
			texture3 = new BitmapTexture(bmd3, true);
			
			var image3 = new Image(texture3);
			image3.x = 200;
			image3.y = 200;
			image3.scaleX = image3.scaleY = 1;
			//image3.pivotX = image3.width / 2;
			//image3.pivotY = image3.height / 2;
			addChild(image3);
			//images.push(image3);
		}
		//renderTexture.clear();
		//renderTexture.draw(image2);
		
		for (i in 0...images.length) 
		{
			images[i].rotation++;
		}
	}
	
	/*private function Update(e:Event):Void 
	{
		
	}*/
}