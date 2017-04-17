package kea.display;

import kha.Color;
import kha.Image;
import kha.FastFloat;
import kha.graphics2.Graphics;
import msignal.Signal.Signal0;

import kea.display.Stage;
import kea.display.DisplayObject;
import kea.atlas.AtlasObject;
import kea.notify.Notifier;

interface IDisplay
{
	var objectId:Int;
	var stage:Stage;
	var parent:DisplayObject;
	//var atlas:AtlasObject;
	var atlas(default, set):AtlasObject;
	var base:Image;
	var previous:IDisplay;
	//var transformAvailable:Notifier<Bool>;
	//var staticCount:Notifier<Int>;
	var isStatic:Null<Bool>;
	var isStatic2:Notifier<Null<Bool>>;
	var children:Array<IDisplay>;
	var name:String;
	var onAdd:Signal0;
	var renderable:Bool;
	
	var x(default, set):Float;
	var y(default, set):Float;
	var width(default, set):Float;
	var height(default, set):Float;
	var pivotX(default, set):Float;
	var pivotY(default, set):Float;
	var rotation(default, set):FastFloat;
	var scaleX(default, set):FastFloat;
	var scaleY(default, set):FastFloat;
	var color(default, set):Color;
	var alpha(default, set):Float;
	var totalNumChildren(get, null):Int;

	@:allow(kea)
	private var _renderIndex:Null<Int>;
	var renderIndex(get, null):Null<Int>;

	function prerender(graphics:Graphics):Void;
	function render(graphics:Graphics):Void;
	function postrender(graphics:Graphics):Void;
	
	function checkStatic():Void;
}
