package kea.render.layers;

import kea.display.IDisplay;
import kha.Image;
import kea.notify.Notifier;
import kha.graphics2.Graphics;

class LayerBuffer implements ILayerBuffer
{
	public var staticCount:Null<Int> = null;
	public var startIndex = new Notifier<Null<Int>>();
	public var endIndex = new Notifier<Null<Int>>();
	public var active = new Notifier<Null<Bool>>();
	public var drawIndex = new Notifier<Int>();
	public var next:ILayerBuffer;
	
	var index:Int;
	var image:Image;
	var lastEndIndex:Null<Int>;
	
	var g2:Graphics;
	var copying = new Notifier<Null<Bool>>();

	public function new(index:Int)
	{
		this.index = index;
		image = Image.createRenderTarget(1024, 1024);
		g2 = image.g2;

		active.add(OnActiveChange);
		copying.add(OnCopyingChange);
		startIndex.add(OnStartIndexChange);
		endIndex.add(OnEndIndexChange);
	}

	public function reset():Void
	{
		active.value = null;
		//staticCount = null;
		copying.value = null;
		//startIndex.value = null;
		//endIndex.value = null;
	}
	
	function OnStartIndexChange():Void
	{
		if (startIndex.value != null) {
			//trace("startIndex.value " + startIndex.value);
			staticCount = 0;
		}
		drawIndex.value = startIndex.value;
	}

	function OnEndIndexChange():Void
	{
		if (endIndex.value != null) {
			if (lastEndIndex > endIndex.value){
				staticCount = 0;
			}
			lastEndIndex = endIndex.value;
		}
	}
	
	function OnCopyingChange():Void
	{
		if (copying.value == true){
			g2.begin(false);
			//trace(["skip clear", "index = " + index]);
		}
		else if (copying.value == false){
			g2.end();
		}
	}
	
	function OnActiveChange():Void
	{
		if (staticCount <= 5){
			if (active.value == true){
				g2.begin(true, 0x00000000);
				//trace(["clear", "index = " + index]);
			}
			else if (active.value == false){
				g2.end();
			}
		}
	}
	
	public function draw(graphics:Graphics, display:IDisplay, i:Int):Int
	{
		//trace("drawIndex.value = " + drawIndex.value);
		//trace("staticCount = " + staticCount);
		if (staticCount <= 5){
			//trace(["Draw: i = " + i, "index = " + index]);
			return drawDisplay(display, i);
		}
		else {
			if (i < drawIndex.value){
				//trace(["Skip to: " + Math.floor(drawIndex.value), "index = " + index]);
				return drawIndex.value;
			}
			else {
				//trace(["Copy: i = " + i, "index = " + index]);
				copying.value = true;
				var r = drawDisplay(display, i);
				if (i + 1 >= endIndex.value){
					copying.value = false;
				}
				return r;
			}
		}
	}

	public function drawDisplay(display:IDisplay, i:Int):Int
	{
		display.prerender(g2);
		display.render(g2);
		display.postrender(g2);

		drawIndex.value = i;
		return i + 1;
	}

	public function copy(graphics:Graphics):Void
	{
		if (active.value != null){
			//trace("layer index = " + index);

			graphics.drawImage(image, 0, 0);
		}
	}
}