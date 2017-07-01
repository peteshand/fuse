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
class AtlasGenTest extends Sprite
{
	public function new() 
	{
		super();
		
		
	}
	
	public function init() 
	{
		var colour:Array<Int> = [
			0x88FF0000,
			0x8800FF00,
			0x880000FF,
			0x880FF000,
			0x88000FF0,
			0x88559933,
			0x88AA55BB,
			0x88CC4488,
			0x88BBEEBB,
			0x886699EE
		];
		
		var textures:Array<BitmapTexture> = [];
		for (i in 0...colour.length) 
		{
			var bmd = new BitmapData(180, 180, true, colour[i]);
			var texture:BitmapTexture = new BitmapTexture(bmd, false);
			textures.push(texture);
		}
		
		var j:Int = textures.length - 1;
		while (j >= 0) {
			var i:Int = textures.length - j;
			var image:Image = new Image(textures[j]);
			image.x = 100 + (50 * i);
			image.y = 100 + (50 * i);
			image.alpha = 0.5;
			image.scaleX = image.scaleY = 1;
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			addChild(image);
			j--;
		}
	}
}