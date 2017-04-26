package kea.logic.layerConstruct.layers;

import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.logic.layerConstruct.layers.BaseRenderer;
import kea.model.buffers.Buffer;
import kha.graphics2.Graphics;
import kha.Image;
import kea.display.IDisplay;

class CacheRenderer implements IRenderer
{	
	public var layerDefinition:LayerDefinition;
	var drawnStartIndex:Int;
	var drawnEndIndex:Int;
	
	var buffer:Image;

	public function new() {
		buffer = Image.createRenderTarget(Buffer.bufferWidth, Buffer.bufferHeight);
		
		//buffer.g2.begin(true, 0x00000000);
		//buffer.g2.end();
	}

	public function cache(graphics:Graphics):Void
	{
		if (drawnStartIndex != layerDefinition.startIndex || drawnEndIndex != layerDefinition.endIndex){
			buffer.g2.begin(true, 0x00000000);		
			for (i in layerDefinition.startIndex...layerDefinition.endIndex){
				var display:IDisplay = Kea.current.logic.displayList.renderList[i];
				//display.prerender(buffer.g2);
				display.render(buffer.g2);
				//display.postrender(buffer.g2);
			}
			buffer.g2.end();
			
			drawnStartIndex = layerDefinition.startIndex;
			drawnEndIndex = layerDefinition.endIndex;
		}
	}

	public function render(graphics:Graphics):Void
	{
		//trace(" cache:  " + layerDefinition.startIndex + " " + layerDefinition.endIndex);
		graphics.color = 0xFFFFFFFF;
		graphics.drawImage(buffer, 0, 0);
	}
}