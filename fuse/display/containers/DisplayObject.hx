package fuse.display.containers;

import fuse.core.memory.data.conductorData.ConductorData;
import fuse.core.memory.data.displayData.DisplayData;
import fuse.display._private.PrivateDisplayBase;
import fuse.display.effects.BlendMode;
import fuse.display.containers.Stage;
import fuse.utils.Notifier;
import kha.Color;
import kha.graphics4.PipelineState;
import msignal.Signal.Signal0;

import fuse.Kea;

@:access(fuse)
class DisplayObject extends PrivateDisplayBase implements IDisplay
{
	public var name:String;
	
	@:isVar public var parent(default, set):IDisplay;
	public var onAdd = new Signal0();
	public var totalNumChildren(get, null):Int;
	public var children:Array<IDisplay>;
	
	var renderable:Bool = false;
	
	@:isVar public var stage(get, set):Stage;
	
	@:isVar public var x(get, set):Float = 0;
	@:isVar public var y(get, set):Float = 0;
	@:isVar public var width(get, set):Float = 0;
	@:isVar public var height(get, set):Float = 0;
	@:isVar public var pivotX(get, set):Float = 0;
	@:isVar public var pivotY(get, set):Float = 0;
	@:isVar public var rotation(get, set):Float = 0;
	@:isVar public var scaleX(get, set):Float = 0;
	@:isVar public var scaleY(get, set):Float = 0;
	@:isVar public var color(get, set):Color = 0x0;
	@:isVar public var alpha(get, set):Float = 0;
	//@:isVar public var blendMode(get, set):BlendMode;
	@:isVar public var layerIndex(get, set):Null<Int> = null;
	//@:isVar public var isStatic(get, set):Int;
	
	@:isVar public var applyPosition(get, set):Int;
	@:isVar public var applyRotation(get, set):Int;
	
	var _totalNumChildren:Int;
	var _renderIndex:Null<Int> = 0x3FFFFFFF;
	var popAlpha:Bool = false;
	
	public function new()
	{
		super();
		var id:Int = PrivateDisplayBase.objectIdCount++;
		displayData = new DisplayData(id);
		objectId = id;
		
		
		scaleX = 1;
		scaleY = 1;
		color = 0xFFFFFFFF;
		alpha = 1;
		
		displayData.textureId = -1;
		
		layerIndex = 0;
		applyPosition = 1;
		applyRotation = 1;
		
		//isStatic = 0;
	}
	
	inline function get_x():Float { return x; }
	inline function get_y():Float { return y; }
	inline function get_width():Float { return width; }
	inline function get_height():Float { return height; }
	inline function get_pivotX():Float { return pivotX; }
	inline function get_pivotY():Float { return pivotY; }
	inline function get_rotation():Float { return rotation; }
	inline function get_scaleX():Float { return scaleX; }
	inline function get_scaleY():Float { return scaleY; }
	inline function get_color():Color { return color; }
	inline function get_alpha():Float { return alpha; }
	//inline function get_blendMode():BlendMode { return blendMode; }
	inline function get_layerIndex():Null<Int> { return layerIndex; }
	inline function get_applyPosition():Int { return applyPosition; }
	inline function get_applyRotation():Int { return applyRotation; }
	//inline function get_isStatic():Int { return isStatic; }
	
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			displayData.x = x = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			displayData.y = y = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			displayData.width = width = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			displayData.height = height = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			displayData.pivotX = pivotX = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			displayData.pivotY = pivotY = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			displayData.rotation = rotation = value;
			applyRotation = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			displayData.scaleX = scaleX = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			displayData.scaleY = scaleY = value;
			applyPosition = 1;
			//isStatic = 0;
		}
		return value;
	}
	
	function set_color(value:Color):Color { 
		if (color != value){
			displayData.color = color = value;
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			displayData.alpha = alpha = value;
			//isStatic = 0;
		}
		return value;
	}
	
	//inline function set_blendMode(value:BlendMode):BlendMode { 
		//if (blendMode != value){
			///*displayData.blendMode =*/ blendMode = value;
			//shaderPipeline = BlendModeUtil.applyBlend(blendMode);
			//isStatic = 0;
		//}
		//return value;
	//}
	
	//override function set_objectId(value:Int):Int 
	//{
		//return displayData.objectId = value;
	//}
	
	inline function set_layerIndex(value:Null<Int>):Null<Int> { 
		if (layerIndex != value){
			//if (layerIndex != null) Kea.current.logic.displayList.removeLayerIndex(layerIndex);
			layerIndex = value;
			//Kea.current.logic.displayList.addLayerIndex(layerIndex);
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_applyPosition(value:Int):Int 
	{
		//if (applyPosition != value) {
			displayData.applyPosition = applyPosition = value;
			if (value == 1) {
				Kea.current.isStatic = 0;
			}
		//}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Int):Int 
	{
		//if (applyRotation != value) {
			displayData.applyRotation = applyRotation = value;
			if (value == 1) {
				Kea.current.isStatic = 0;
			}
		//}
		return applyRotation;
	}
	
	//inline function set_isStatic(value:Int):Int 
	//{
		////if (isStatic != value) {
			//isStatic = value;
			////trace("isStatic = " + isStatic);
			//displayData.isStatic = isStatic;
			//if (value == 0){
				//Kea.current.isStatic = 0;
			//}
		////}
		//return value;
	//}
	
	///////////////////////////////////////////////////////////////
	
	function get_totalNumChildren():Int
	{ 
		return 0;
	}
	
	function get_stage():Stage 
	{
		return stage;
	}
	
	function set_stage(value:Stage):Stage 
	{
		if (stage != value) {
			//DisplayList.updateHierarchy = true;
			stage = value;
		}
		
		// TODO, move this to render loop
		if (value == null) {
			/*if (renderable) {
				Kea.current.logic.displayList.remove(this);
			}*/
			//Kea.current.logic.atlasBuffer.remove(this);
		}
		else {
			/*if (renderable) {
				Kea.current.logic.displayList.add(this);
			}*/
			//Kea.current.logic.atlasBuffer.add(this);
		}
		
		
		return stage;
	}
	
	function set_parent(value:IDisplay):IDisplay 
	{
		parent = value;
		
		if (parent == null) {
			//displayData.parentId = -1;
			Kea.current.workers.removeChild(this);
		}
		else {
			//displayData.parentId = parent.objectId;
			Kea.current.workers.addChild(this, parent);
		}
		return parent = value;
	}
}

