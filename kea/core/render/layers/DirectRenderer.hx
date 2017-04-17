package kea.core.render.layers;

import kea.display.IDisplay;
import kha.graphics2.Graphics;

class DirectRenderer extends BaseRenderer
{	
	public function new() {
		super();
	}

	override public function cache(graphics:Graphics):Void
	{
		
	}

	override public function render(graphics:Graphics):Void
	{
		//trace("render: " + layerDefinition.startIndex + " " + layerDefinition.endIndex);
		for (i in layerDefinition.startIndex...layerDefinition.endIndex) {
			var display:IDisplay = Kea.current.updateList.renderList[i];
			display.prerender(graphics);
			display.render(graphics);
			display.postrender(graphics);
		}
	}
}