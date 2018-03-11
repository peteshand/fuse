package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.input.Touch;
import fuse.display.Stage;
import fuse.utils.Color;
import fuse.Fuse;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import openfl.events.MouseEvent;

@:access(fuse)
class DisplayObject
{
	static var objectIdCount:Int = 0;
	public var objectId:Int;
	public var displayData:IDisplayData;
	public var name:String;
	
	//public var onAdd = new Signal0();
	
	
	public var onAdd = new Signal1<DisplayObject>();
	public var onRemove = new Signal1<DisplayObject>();
	public var onAddToStage = new Signal1<DisplayObject>();
	public var onRemoveFromStage = new Signal1<DisplayObject>();
	
	@:isVar public var touchable(get, set):Bool = false;
	public var onPress = new Signal1<Touch>();
	public var onMove = new Signal1<Touch>();
	public var onRelease = new Signal1<Touch>();
	public var onRollover = new Signal1<Touch>();
	public var onRollout = new Signal1<Touch>();
	
	@:isVar public var parent(default, null):DisplayObjectContainer;
	@:isVar public var stage(default, null):Stage;
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
	@:isVar public var colorTL(get, set):Color = 0x0;
	@:isVar public var colorTR(get, set):Color = 0x0;
	@:isVar public var colorBL(get, set):Color = 0x0;
	@:isVar public var colorBR(get, set):Color = 0x0;
	@:isVar public var alpha(get, set):Float = 0;
	@:isVar public var visible(get, set):Bool = false;
	
	//@:isVar public var blendMode(get, set):BlendMode;
	@:isVar public var layerIndex(get, set):Null<Int> = null;
	@:isVar public var isStatic(get, set):Int;
	public var displayType:DisplayType = DisplayType.DISPLAY_OBJECT;
	
	public function new()
	{
		var id:Int = DisplayObject.objectIdCount++;
		//displayData = new WorkerDisplayData(id);
		displayData = untyped CommsObjGen.getDisplayData(id);
		displayData.isMoving = 1;
		displayData.isRotating = 1;
		
		objectId = id;
		
		scaleX = 1;
		scaleY = 1;
		color = 0x00000000;
		alpha = 1;
		visible = true;
		
		displayData.textureId = -1;
		
		layerIndex = 0;
		
		isStatic = 0;
	}
	
	
	inline function get_touchable():Bool { return touchable; }
	inline function get_x():Float { return x; }
	inline function get_y():Float { return y; }
	function get_width():Float { return width; }
	function get_height():Float { return height; }
	inline function get_pivotX():Float { return pivotX; }
	inline function get_pivotY():Float { return pivotY; }
	inline function get_rotation():Float { return rotation; }
	inline function get_scaleX():Float { return scaleX; }
	inline function get_scaleY():Float { return scaleY; }
	inline function get_color():Color { return colorTL; }
	inline function get_colorTL():Color { return colorTL; }
	inline function get_colorTR():Color { return colorTR; }
	inline function get_colorBL():Color { return colorBL; }
	inline function get_colorBR():Color { return colorBR; }
	
	inline function get_alpha():Float { return alpha; }
	function get_visible():Bool { return visible; }
	
	//inline function get_blendMode():BlendMode { return blendMode; }
	inline function get_layerIndex():Null<Int> { return layerIndex; }
	inline function get_isStatic():Int { return isStatic; }
	
	
	
	inline function set_touchable(value:Bool):Bool 
	{
		if (touchable != value){
			touchable = value;
			Fuse.current.workerSetup.setTouchable(this, value);
			//isStatic = 0;
		}
		return value;
	}
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			displayData.x = x = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			displayData.y = y = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	function set_width(value:Float):Float { 
		if (width != value){
			displayData.width = width = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	function set_height(value:Float):Float { 
		if (height != value){
			displayData.height = height = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			displayData.pivotX = pivotX = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			displayData.pivotY = pivotY = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			displayData.rotation = rotation = value;
			displayData.isMoving = 1;
			displayData.isRotating = 1;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			displayData.scaleX = scaleX = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			displayData.scaleY = scaleY = value;
			displayData.isMoving = 1;
			isStatic = 0;
		}
		return value;
	}
	
	function set_color(value:Color):Color { 
		if (color != value){
			displayData.color = color = colorTL = colorTR = colorBL = colorBR = value;
			isStatic = 0;
		}
		return value;
	}
	
	function set_colorTL(value:Color):Color { 
		if (colorTL != value){
			displayData.colorTL = colorTL = value;
			isStatic = 0;
		}
		return value;
	}
	
	function set_colorTR(value:Color):Color { 
		if (colorTR != value){
			displayData.colorTR = colorTR = value;
			isStatic = 0;
		}
		return value;
	}
	
	function set_colorBL(value:Color):Color { 
		if (colorBL != value){
			displayData.colorBL = colorBL = value;
			isStatic = 0;
		}
		return value;
	}
	
	function set_colorBR(value:Color):Color { 
		if (colorBR != value){
			displayData.colorBR = colorBR = value;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			displayData.alpha = alpha = value;
			isStatic = 0;
		}
		return value;
	}
	
	function set_visible(value:Bool):Bool 
	{
		if (this.visible != value){
			this.visible = value;
			if (this.visible)	displayData.visible = 1;
			else				displayData.visible = 0;
			isStatic = 0;
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
	
	inline function set_isStatic(value:Int):Int 
	{
		//if (isStatic != value) {
			displayData.isStatic = isStatic = value;
			if (value == 0) {
				Fuse.current.isStatic = 0;
			}
		//}
		return isStatic;
	}
	
	function setStage(value:Stage):Stage 
	{
		if (stage != value) {
			if (stage != null && value == null) {
				stage.onDisplayRemoved.dispatch(this);
			}
			stage = value;
			
			if (stage != null) {
				stage.onDisplayAdded.dispatch(this);
				onAddToStage.dispatch(this);
			}
			else onRemoveFromStage.dispatch(this);
		}
		return stage;
	}
	
	function setParent(parent:DisplayObjectContainer):Void 
	{
		if (this.parent == parent) return;
		this.parent = parent;
		
		if (parent != null && parent.stage != null) {
			Fuse.current.workerSetup.addChild(this, parent);
			onAdd.dispatch(this);
		}
		else {
			Fuse.current.workerSetup.removeChild(this);
			onRemove.dispatch(this);
		}
		
		if (parent == null) setStage(null);
		else setStage(parent.stage);
	}
	
	function forceRedraw():Void
	{
		this.isStatic = 0;
	}
	
	public function dispose():Void
	{
		
	}
	
	function dispatchInput(touch:Touch) 
	{
		switch(touch.type) {
			case MouseEvent.MOUSE_DOWN:	onPress.dispatch(touch);
			case MouseEvent.MOUSE_MOVE:	onMove.dispatch(touch);
			case MouseEvent.MOUSE_UP:	onRelease.dispatch(touch);
			case MouseEvent.MOUSE_OVER:	onRollover.dispatch(touch);
			case MouseEvent.MOUSE_OUT:	onRollout.dispatch(touch);
		}
	}
}