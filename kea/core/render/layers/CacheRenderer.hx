package kea.core.render.layers;

import kha.graphics2.Graphics;
import kha.Image;
import kea.display.IDisplay;

class CacheRenderer extends BaseRenderer
{	
	var drawnStartIndex:Int;
	var drawnEndIndex:Int;
	
	var buffer:Image;

	public function new() {
		super();
		buffer = Image.createRenderTarget(1024, 1024);
		
		//buffer.g2.begin(true, 0x00000000);
		//buffer.g2.end();
	}

	override public function cache(graphics:Graphics):Void
	{
		if (drawnStartIndex != layerDefinition.startIndex || drawnEndIndex != layerDefinition.endIndex){
			buffer.g2.begin(true, 0x00000000);		
			for (i in layerDefinition.startIndex...layerDefinition.endIndex){
				var display:IDisplay = Kea.current.updateList.renderList[i];
				display.prerender(buffer.g2);
				display.render(buffer.g2);
				display.postrender(buffer.g2);
			}
			buffer.g2.end();
			
			drawnStartIndex = layerDefinition.startIndex;
			drawnEndIndex = layerDefinition.endIndex;
		}
	}

	override public function render(graphics:Graphics):Void
	{
		//trace(" cache:  " + layerDefinition.startIndex + " " + layerDefinition.endIndex);
		graphics.color = 0xFFFFFFFF;
		graphics.drawImage(buffer, 0, 0);
	}
}