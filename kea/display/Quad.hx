package kea.display;

import flash.display.BitmapData;
import kea.texture.Texture;
import kea.util.ColourUtils;
import kha.Color;
import kha.graphics2.Graphics;

class Quad extends DisplayObject implements IDisplay
{
	private static var baseImages = new Map<Color, Texture>();
	
	public function new(width:Int, height:Int, color:Color)
	{
		color = ColourUtils.addMissingAlpha(color, 0xFF);
		if (!baseImages.exists(color)){
			//var baseImage:Texture = Texture.createRenderTarget(1, 1);
			var baseImage:Texture = Texture.fromBitmapData(new BitmapData(1, 1, true, color), true);
			baseImage.name = "KeaQuad#" + StringTools.hex(color);
			baseImages.set(color, baseImage);
		}
		this.base = baseImages.get(color);
		super();
		
		this.renderable = true;
		this.width = width;
		this.height = height;
		this.color = color;
	}
	
	override function setScale() 
	{
		localTransform._00 = scaleX * width;
		localTransform._11 = scaleY * height;
	}
}
