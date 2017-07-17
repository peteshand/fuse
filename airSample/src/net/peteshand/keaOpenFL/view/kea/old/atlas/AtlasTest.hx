package net.peteshand.keaOpenFL.view.kea.old.atlas;

import flash.display.BitmapData;
import hxColorToolkit.spaces.RGB;
import fuse.Kea;
import fuse.display.containers.IDisplay;
import kea.display.Quad;
import fuse.display.containers.Sprite;
import kea.texture.Texture;
import kha.Assets;
import kea.display.Image;

using hxColorToolkit.ColorToolkit;
/**
 * ...
 * @author P.J.Shand
 */
class AtlasTest extends Sprite
{
	var images:Array<kea.display.Image> = [];
	var count:Int = -1;
	var visCount:Int = 0;
	var displays:Array<IDisplay> = [];
	
	public function new() 
	{
		super();
		
		this.name = "AtlasText";
		this.onAdd.add(OnAdd);
	}
	
	function OnAdd() 
	{
		Assets.loadEverything(OnLoadComplete);
	}

	function OnLoadComplete(): Void
	{
		count = 0;
		
		Kea.current.onRender.add(update);
	}
	
	override public function update():Void
	{
		if (count >= 0) count++;
		
		if (count == 120) {
			init();
		}
		if (count == 150) {
			for (i in 0...displays.length) 
			{
				addChild(displays[i]);
			}
		}
		/*if (count % 60 * 5 == 0) {
			visCount++;
			
			for (i in 0...images.length) 
			{
				if (i == visCount % images.length) {
					addChild(images[i]);
					trace("add " + i);
				}
				else {
					var parent:Sprite = cast images[i].parent;
					if (parent != null) parent.removeChild(images[i]);
					trace("remove " + i);
				}
			}
			trace("------------");
		}
		count++;*/
	}
	
	function init() 
	{
		
		//stage.color = 0xFF8833EE;
		
		addImage(Assets.images.kea, 0, 0);
		addImage(Assets.images.kea2, 1, 1);
		
		
		/*for (i in 0...1) 
		{
			addQuad();
		}*/
		
		for (i in 0...200) 
		{
			addBmdImage();
		}
		//
		addImage(Assets.images.kea3, 2, 1);
		addImage(Assets.images.kea4, 3, 1);
	}
	
	function addBmdImage() 
	{
		var colour = new RGB(Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF));
		var bmd:BitmapData = null;
		if (Math.random() < 0.5) {
			bmd = new BitmapData(60 + Math.floor(Math.random() * 1100), 30 + Math.floor(Math.random() * 50), false, colour.getColor());
		}
		else {
			bmd = new BitmapData(30 + Math.floor(Math.random() * 50), 60 + Math.floor(Math.random() * 1100), false, colour.getColor());
		}
		var texture:Texture = Texture.fromBitmapData(bmd, true);
		var image = new Image(texture);
		image.x = 500 + (Math.random() * 1000);
		image.y = Math.random() * 800;
		//addChild(image);
		displays.push(image);
	}
	
	function addQuad() 
	{
		var colour = new RGB(Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF), Math.floor(Math.random() * 0xFF));
		
		var quad:Quad = new Quad(40 + Math.floor(Math.random() * 100), 40 + Math.floor(Math.random() * 100), colour.getColor());
		quad.x = 500 + (Math.random() * 1000);
		quad.y = Math.random() * 800;
		quad.alpha = 1;
		//addChild(quad);
		displays.push(quad);
	}
	
	function addImage(base:Texture, index:Int, addAt:Int) 
	{
		var image = new kea.display.Image(base);
		image.x = 500 + (index * 50);// + (stage.stageWidth - 500) * Math.random();
		image.y = 100 + (index * 50);// stage.stageHeight * Math.random();
		//addChildAt(image, addAt);
		//addChild(image);
		images.push(image);
		displays.push(image);
	}
}