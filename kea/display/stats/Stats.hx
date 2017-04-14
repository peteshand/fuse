package kea.display.stats;

import kha.Image;
import kha.Color;
import kha.graphics2.Graphics;
import kea.display.Sprite;
import kea.display.IDisplay;
import kea.core.Kea;
import kha.Font;
import kha.Assets;

import kha.graphics4.BlendingOperation;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

class Stats extends Sprite implements IDisplay
{
	var font:Font;

	public function new()
	{
		super();
		
		Assets.loadFont("arial", function(_font:Font):Void
		{
			font = _font;
		});

		//alwaysRender = true;
	}

	override public function render(graphics:Graphics): Void
	{
		graphics.color = 0xFFFFFFFF;
		graphics.fillRect(0, 0, 130, 50);
		
		if (font != null){
			//trace("graphics.pipeline = " + graphics.pipeline);
			
			graphics.font = font;
			graphics.color = 0xFF000000;
			graphics.fontSize = 16;
			graphics.drawString("fps: " + Kea.current.performance.fps.value, 4, 4);
			var percentage:String = Std.string(Math.floor(Kea.current.performance.frameBudget.value * 100));
			if (percentage.length == 1) percentage = "0" + percentage;
			graphics.drawString("frame budget: " + percentage + "%", 4, 24);
			graphics.color = 0xFFFFFFFF;
		}
		
		
	}
}
