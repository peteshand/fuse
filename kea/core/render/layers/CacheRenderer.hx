package kea.core.render.layers;

import kha.graphics2.Graphics;
import kha.Image;
import kea.display.IDisplay;

class CacheRenderer extends BaseRenderer
{	
	var drawnStartIndex:Int;
	var drawnEndIndex:Int;
	
	var image:Image;

	public function new() {
		super();
		image = Image.createRenderTarget(1024, 1024);
		
		image.g2.begin(true, 0x00000000);
		image.g2.end();
	}

	override public function cache(graphics:Graphics):Void
	{
		if (drawnStartIndex != layerDefinition.startIndex || drawnEndIndex != layerDefinition.endIndex){
			image.g2.begin(true, 0x00000000);		
			for (i in 0...layerDefinition.displays.length){
				var display:IDisplay = layerDefinition.displays[i];
				display.prerender(image.g2);
				display.render(image.g2);
				display.postrender(image.g2);
			}
			image.g2.end();
		}

		drawnStartIndex = layerDefinition.startIndex;
		drawnEndIndex = layerDefinition.endIndex;
	}

	override public function render(graphics:Graphics):Void
	{
		//trace("cache");
		graphics.color = 0xFFFFFFFF;
		graphics.drawImage(image, 0, 0);
	}
}