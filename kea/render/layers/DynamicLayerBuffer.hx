package kea.render.layers;

import kea.display.IDisplay;
import kea.notify.Notifier;
import kha.graphics2.Graphics;

class DynamicLayerBuffer implements ILayerBuffer
{
	public var staticCount:Null<Int> = null;
	public var startIndex = new Notifier<Null<Int>>();
	public var endIndex = new Notifier<Null<Int>>();
	public var active = new Notifier<Null<Bool>>();
	public var drawIndex = new Notifier<Int>();
	public var next:ILayerBuffer;
	
	var index:Int;

	public function new(index:Int)
	{
		this.index = index;
	}

	public function reset():Void
	{

	}

	public function draw(graphics:Graphics, display:IDisplay, i:Int):Int
	{
		while (i < endIndex.value){
			i = drawDisplay(graphics, display, i);
		}
		return i + 1;
	}

	public function drawDisplay(graphics:Graphics, display:IDisplay, i:Int):Int
	{
		display.prerender(graphics);
		display.render(graphics);
		display.postrender(graphics);

		drawIndex.value = i;
		return i + 1;
	}

	public function copy(graphics:Graphics):Void
	{

	}
}
