package kea.display;

import kha.Image;
import kha.Color;
import kha.graphics2.Graphics;

class Quad extends DisplayObject implements IDisplay
{
	private static var baseImages = new Map<Color, kha.Image>();
	
	public function new(width:Int, height:Int, color:Color)
	{
		super();
		this.width = width;
		this.height = height;
		this.color = color;
		if (!baseImages.exists(color)){
			var baseImage:Image = Image.createRenderTarget(width, height);
			baseImage.g2.begin(true, color);		
			baseImage.g2.end();
			baseImages.set(color, baseImage);
		}
		this.base = baseImages.get(color);
	}

	override public function render(graphics:Graphics): Void
	{
		if (atlas != null){
			if (atlas.texture != null){
				graphics.drawSubImage(atlas.texture, 
					-pivotX, -pivotY, // draw x/y
					0, 0, // sample x/y
					this.base.width, this.base.height // draw width/height
				);
			}
		}
	}
}
