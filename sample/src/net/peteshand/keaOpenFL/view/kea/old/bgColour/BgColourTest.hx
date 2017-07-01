package net.peteshand.keaOpenFL.view.kea.old.bgColour;
import flash.display.BitmapData;
import hxColorToolkit.spaces.RGB;
import kea.display.Image;
import kea.display.Quad;
import kea.display.Sprite;
import kea.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
class BgColourTest extends Sprite
{

	public function new() 
	{
		super();
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		//stage.color = 0xFF112211;
		
		//var colour = new RGB(Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF));
		/*var bmd:BitmapData = new BitmapData(300, 300, false, 0xFFFF0000);
		
		var texture:Texture = Texture.fromBitmapData(bmd, true);
		var image:Image = new Image(texture);
		image.x = 500 + (Math.random() * 1000);
		image.y = Math.random() * 800;
		addChild(image);*/
		
		var quad:Quad = new Quad(300, 300, 0xFF0000FF);
		quad.x = 10;
		quad.y = 10;
		addChild(quad);
	}
	
}