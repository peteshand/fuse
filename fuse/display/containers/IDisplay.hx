package fuse.display.containers;

import fuse.core.front.memory.data.displayData.IDisplayData;
import fuse.display.containers.Stage;
import fuse.Color;
import msignal.Signal.Signal0;

interface IDisplay
{
	var objectId:Int;
	var renderId:Int;
	var parentId:Int;
	var parent(default, set):IDisplay;
	
	var children:Array<IDisplay>;
	var name:String;
	var onAdd:Signal0;
	var stage(get, set):Stage;
	var displayData:IDisplayData;
	
	var x(get, set):Float;
	var y(get, set):Float;
	var width(get, set):Float;
	var height(get, set):Float;
	var pivotX(get, set):Float;
	var pivotY(get, set):Float;
	var rotation(get, set):Float;
	var scaleX(get, set):Float;
	var scaleY(get, set):Float;
	var color(get, set):Color;
	var alpha(get, set):Float;
	//var blendMode(get, set):BlendMode;
	var layerIndex(get, set):Null<Int>;
	
	//var isStatic(get, set):Int;
	var applyPosition(get, set):Int;
	var applyRotation(get, set):Int;
	
	private function forceRedraw():Void;
}
