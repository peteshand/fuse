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
		//trace("direct");
		for (i in 0...layerDefinition.displays.length){
			var display:IDisplay = layerDefinition.displays[i];
			display.prerender(graphics);
			display.render(graphics);
			display.postrender(graphics);
		}
	}
}