package kea.display.text;

import kha.Image;
import kha.Font;
import kha.graphics2.Graphics;
import kha.Assets;

class TextField extends DisplayObject implements IDisplay
{
	private static var baseImages = new Map<String, kha.Image>();
	private var format:TextFormat = TextFormat.defaultFormat;
	@:isVar public var text(default, set):String;
	
	public function new()
	{
		//this.renderable = true;
		//Assets.loadEverything(OnLoadComplete);
		//updateBase();
		
		super();
	}
	
	/*function OnLoadComplete() 
	{
		staticCount.value = 0;
		font = Assets.fonts.arial;
		updateBase();
	}*/
	
	function set_text(value:String):String 
	{
		clearCurrent();
		text = value;
		updateBase();
		//staticCount.value = 0;
		isStatic = false;
		return text = value;
	}
	
	function clearCurrent() 
	{
		if (text == null) return;
		if (baseImages.exists(text)) {
			var _base:kha.Image = baseImages.get(text);
			/*if (_base != null) {
				_base.unload();
			}*/
			baseImages.remove(text);
			// TODO, remove atals
		}
	}
	
	function updateBase() 
	{
		return;
		
		if (text == null) return;
		/*if (font == null) {
			return;
		}*/
		if (!baseImages.exists(text))
		{	
			var baseImage:Image = Image.createRenderTarget(400, 400);
			baseImage.g2.begin(true, 0x00000000);
			baseImage.g2.font = Assets.fonts.arial;
			baseImage.g2.fontSize = format.fontSize;
			baseImage.g2.color = format.color;
			baseImage.g2.drawString(text, 0, 0);
			baseImage.g2.end();
			
			baseImages.set(text, baseImage);
		}
		this.base = baseImages.get(text);
		drawWidth = base.width;
		drawHeight = base.height;
	}
	
	/*override function renderImage(graphics:Graphics): Void
	{
		if (base != null) graphics.drawImage(base, -pivotX, -pivotY);
	}*/
	
	override public function render(graphics:Graphics): Void
	{
		graphics.font = Assets.fonts.arial;
		graphics.fontSize = format.fontSize;
		graphics.color = format.color;
		graphics.drawString(text, 0, 0);
		return;
		
		if (base != null) {
			graphics.drawImage(base, -pivotX, -pivotY);
		}
	}
}
