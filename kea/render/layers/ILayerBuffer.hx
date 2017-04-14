package kea.render.layers;

import kea.display.IDisplay;
import kea.notify.Notifier;
import kha.graphics2.Graphics;

interface ILayerBuffer
{
	var staticCount:Null<Int>;
	var startIndex:Notifier<Null<Int>>;
	var endIndex:Notifier<Null<Int>>;
	var active:Notifier<Null<Bool>>;
	var drawIndex:Notifier<Int>;
	var next:ILayerBuffer;
	
	function reset():Void;
	function draw(graphics:Graphics, display:IDisplay, i:Int):Int;
	//function drawDisplay(display:IDisplay, i:Int):Int;
	function copy(graphics:Graphics):Void;
}
