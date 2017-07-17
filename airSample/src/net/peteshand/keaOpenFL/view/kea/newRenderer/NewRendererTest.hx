package net.peteshand.keaOpenFL.view.kea.newRenderer;

import fuse.display.containers.Sprite;
import fuse.display.renderables.Image;
import fuse.display.renderables.Quad;
import fuse.render.Renderer;
import fuse.texture.BitmapTexture;
import fuse.texture.ITexture;
import kha.Color;
import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class NewRendererTest extends Sprite
{
	var images:Array<Image> = [];
	
	public function new() 
	{
		super();
		
		
	}
	
	public function init() 
	{
		var bmd:BitmapData = Assets.getBitmapData("img/keaSquare.png");
		//var bmd:BitmapData = new BitmapData(256, 256, true, 0x44FFFFFF);
		
		var texture:ITexture = new BitmapTexture(bmd);
		
		var numQuads:Int = Renderer.bufferSize;// Math.floor(Math.random() * 5);
		for (j in 0...numQuads) 
		{
			/*var quad:Quad = new Quad(200, 200, 0xFF00FF00);
			quad.pivotX = 100;
			quad.pivotY = 100;
			quad.x = 100;// 500 + Math.floor((stage.stageWidth - 500) * Math.random());
			quad.y = 100;// Math.floor(stage.stageHeight * Math.random());
			addChild(quad);
			quad.rotation = 45;*/
			
			
			
			var image1:Image = new Image(texture);
			image1.x = Math.random() * 1600;
			image1.y = Math.random() * 900;
			image1.scaleX = image1.scaleY = 0.1;
			image1.pivotX = image1.width / 2;
			image1.pivotY = image1.height / 2;
			addChild(image1);
			images.push(image1);
		}
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	private function Update(e:Event):Void 
	{
		for (i in 0...images.length) 
		{
			images[i].rotation++;
		}
	}
}