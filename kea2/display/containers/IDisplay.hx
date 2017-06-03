package kea2.display.containers;

import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.layerConstruct.LayerConstruct;
import kea.texture.Texture;
import kea2.core.memory.data.displayData.DisplayData;

import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kha.Color;
import kha.FastFloat;
import kha.graphics2.Graphics;
import msignal.Signal.Signal0;

import kea2.display.containers.Stage;
import kea2.display.containers.DisplayObject;
import kea.notify.Notifier;

interface IDisplay
{
	var objectId:Int;
	var renderId:Int;
	var parentId:Int;
	var parent(default, set):IDisplay;
	
	//var atlas(default, set):AtlasObject;
	var atlasItem(default, set):AtlasItem;
	var base:Texture;
	//var previous:IDisplay;
	
	//var isStatic:Null<Bool>;
	//var isStatic(default, set):Null<Bool>;
	var isStatic(default, set):Null<Bool>;
	var isStatic2:Notifier<Null<Bool>>;
	var children:Array<IDisplay>;
	var name:String;
	var onAdd:Signal0;
	//var renderable:Bool;
	
	var stage(get, set):Stage;
	
	//var displayData:DisplayData;
	//var vectexDataAccess:VectexDataAccess;
	var displayData:DisplayData;
	
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
	var layerIndex(default, set):Null<Int>;
	
	var totalNumChildren(get, null):Int;

	//@:allow(kea)
	//private var _renderIndex:Null<Int>;
	//var renderIndex(get, null):Null<Int>;

	function update():Void;
	
	
	function buildHierarchy():Void;
	var calcTransform:Graphics->Void;
	function pushTransform(graphics:Graphics):Void;
	function popTransform(graphics:Graphics):Void;
	
	function render(graphics:Graphics):Void;
	
	function checkStatic():Void;
	
	var layerDefinition:LayerDefinition;
	
	//function addChild(display:IDisplay):Void;
	//function removeChild(display:IDisplay):Void;
}
