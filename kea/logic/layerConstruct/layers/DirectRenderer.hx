package kea.logic.layerConstruct.layers;

import kea2.display.containers.IDisplay;
import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.logic.layerConstruct.layers.BaseRenderer;
import kea2.Kea;
import kha.graphics2.Graphics;

class DirectRenderer implements IRenderer
{	
	public var layerDefinition:LayerDefinition;
	
	public function new() { }

	public function cache(graphics:Graphics):Void
	{
		
	}

	public function render(graphics:Graphics):Void
	{
		
		for (i in layerDefinition.startIndex...layerDefinition.endIndex) {
			var display:IDisplay = Kea.current.logic.displayList.renderList[i];
			//display.prerender(graphics);
			display.render(graphics);
			//display.postrender(graphics);
		}
	}
} 