package kea.display;

import kha.Image;
import kha.Color;
import kha.graphics2.Graphics;

class Quad extends DisplayObject implements IDisplay
{
	private static var baseImages = new Map<Color, kha.Image>();
	
	public function new(width:Int, height:Int, color:Color)
	{
		//this.renderable = true;
		if (!baseImages.exists(color)){
			var baseImage:Image = Image.createRenderTarget(1, 1);
			baseImage.name = "KeaQuad#" + StringTools.hex(color);
			baseImage.g2.begin(true, color);		
			baseImage.g2.end();
			baseImages.set(color, baseImage);
		}
		this.base = baseImages.get(color);
		super();
		
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
