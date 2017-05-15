package kea.logic.layerConstruct.layers;

import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.logic.layerConstruct.layers.BaseRenderer;
import kea.model.buffers.Buffer;
import kea.texture.Texture;
import kha.graphics2.Graphics;
import kea.display.IDisplay;

class CacheRenderer implements IRenderer
{	
	public var layerDefinition:LayerDefinition;
	//var prevDrawnStartIndex:Int = -1;
	//var prevDrawnEndIndex:Int = -1;
	var drawnStartIndex:Int = -1;
	var drawnEndIndex:Int = -1;
	var buffer:Texture;

	public function new() {
		buffer = Texture.createRenderTarget(Buffer.bufferWidth, Buffer.bufferHeight);
		clear();
	}
	
	function clear():Void
	{
		buffer.g2.begin(true, 0x00000000);
		buffer.g2.end();
	}

	public function cache(graphics:Graphics):Void
	{
		if (drawnStartIndex != layerDefinition.startIndex || drawnEndIndex != layerDefinition.endIndex){
			
			/*if (drawnStartIndex == -1) {
				clear();
			}*/
			
			buffer.g2.begin(false);
			
			var startIndex:Int = layerDefinition.startIndex;
			var endIndex:Int = layerDefinition.endIndex;
			
			if (startIndex < drawnEndIndex) {
				startIndex = drawnEndIndex;
			}
			
			for (i in startIndex...endIndex){
				var display:IDisplay = Kea.current.logic.displayList.renderList[i];
				display.render(buffer.g2);
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