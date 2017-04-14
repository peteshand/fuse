package kea.display.text;

import kha.Font;
import kha.graphics2.Graphics;
import kha.Assets;

class TextField extends DisplayObject implements IDisplay
{
	private var format:TextFormat = TextFormat.defaultFormat;
	public var text:Null<String> = null;
	var font:Font;

	public function new() {
		super();

		Assets.loadFont("arial", function(_font:Font):Void
		{
			font = _font;
		});
	}

	override public function render(graphics:Graphics): Void
	{
		if (font != null && text != null){
			
			graphics.font = font;
			graphics.fontSize = format.fontSize;
			graphics.color = format.color;
			graphics.drawString(text, 0, 0);
			graphics.color = 0xFFFFFFFF;
		}
	}
}
