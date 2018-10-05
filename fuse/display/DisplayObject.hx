package fuse.display;

import fuse.core.input.TouchType;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.input.Touch;
import fuse.display.Stage;
import fuse.utils.Align;
import fuse.utils.Color;
import fuse.Fuse;
import fuse.utils.drag.DragUtil;
import msignal.Signal.Signal1;
import fuse.utils.ObjectId;

@:access(fuse)
class DisplayObject
{
	static var objectIdCount:Int = 0;
	public var objectId:ObjectId;
	public var displayData:IDisplayData;
	public var name:String;
	
	//public var onAdd = new Signal0();
	
	public var onAdd = new Signal1<DisplayObject>();
	public var onRemove = new Signal1<DisplayObject>();
	public var onAddToStage = new Signal1<DisplayObject>();
	public var onRemoveFromStage = new Signal1<DisplayObject>();
	
	@:isVar public var touchable(get, set):Bool = false;
	public var onPress(get, null):Signal1<Touch>;
	public var onMove(get, null):Signal1<Touch>;
	public var onRelease(get, null):Signal1<Touch>;
	public var onRollover(get, null):Signal1<Touch>;
	public var onRollout(get, null):Signal1<Touch>;
	
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
	@:isVar public var mask(default, set):Image;
	@:isVar public var renderLayer(default, set):Null<Int>;
	//@:isVar public var blendMode(get, set):BlendMode;
	public var displayType:DisplayType = DisplayType.DISPLAY_OBJECT;
	
	// var updateUVs:Bool = false;
	var updateTexture:Bool = false; // only used for Images
	// var updateMask:Bool = false;
	//var updateAll:Bool = true;
	var updatePosition:Bool = true;
	var updateRotation:Bool = true;
	var updateColour:Bool = true;
	var updateVisible:Bool = true;
	var updateAlpha:Bool = true;
	
	var horizontalAlign:Align;
	var verticalAlign:Align;
	var dragUtil:DragUtil;
	
	public function new()
	{
		stage = Fuse.current.stage;
		//isRotating.add(OnRotationChange);
		//isMoving.add(OnMovingChange);
		//isStatic.add(OnStaticChange);
		
		var id:Int = DisplayObject.objectIdCount++;
		//displayData = new WorkerDisplayData(id);
		displayData = CommsObjGen.getDisplayData(id);
		//isMoving = 1;
		//isRotating = 1;
		
		objectId = id;
		scaleX = 1;
		scaleY = 1;
		color = 0x00000000;
		alpha = 1;
		visible = true;
		
		displayData.textureId = -1;
		
		//isStatic = 0;
		
		
	}
	
	
	public function resetMovement() 
	{
		updatePosition = false;
		updateRotation = false;
		updateColour = false;
		updateVisible = false;
		updateAlpha = false;
	}
	
	//function OnRotationChange() 
	//{
		//if (isRotating == 1) isMoving = 1;
		//SendToBackend();
	//}
	//
	//function OnMovingChange() 
	//{
		//if (isStatic == 1) isStatic = 0;
		//SendToBackend();
	//}
	//
	//function OnStaticChange() 
	//{
		//if (isStatic == 0) {
			//Fuse.current.conductorData.frontIsStatic = 0;
		//}
		//SendToBackend();
	//}
	//
	//function SendToBackend() 
	//{
		//Fuse.current.workerSetup.setStatic(this);
	//}
	
	
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
	function get_color():Color { return colorTL; }
	inline function get_colorTL():Color { return colorTL; }
	inline function get_colorTR():Color { return colorTR; }
	inline function get_colorBL():Color { return colorBL; }
	inline function get_colorBR():Color { return colorBR; }
	
	inline function get_alpha():Float { return alpha; }
	function get_visible():Bool { return visible; }
	
	
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
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			displayData.y = y = value;
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_width(value:Float):Float { 
		if (width != value){
			displayData.width = width = value;
			updateAlignmentX();
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_height(value:Float):Float { 
		if (height != value){
			displayData.height = height = value;
			updateAlignmentY();
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			displayData.pivotX = pivotX = value;
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			displayData.pivotY = pivotY = value;
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			displayData.rotation = rotation = value;
			//trace("rotation = " + value);
			
			updatePosition = true;
			updateRotation = true;
			//isRotating = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			displayData.scaleX = scaleX = value;
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			displayData.scaleY = scaleY = value;
			updatePosition = true;
			//isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_color(value:Color):Color { 
		if (color != value){
			displayData.color = color = colorTL = colorTR = colorBL = colorBR = value;
			updateColour = true;
			//isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_colorTL(value:Color):Color { 
		if (colorTL != value){
			displayData.colorTL = colorTL = value;
			updateColour = true;
			//isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_colorTR(value:Color):Color { 
		if (colorTR != value){
			displayData.colorTR = colorTR = value;
			updateColour = true;
			//isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_colorBL(value:Color):Color { 
		if (colorBL != value){
			displayData.colorBL = colorBL = value;
			updateColour = true;
			//isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_colorBR(value:Color):Color { 
		if (colorBR != value){
			displayData.colorBR = colorBR = value;
			updateColour = true;
			//isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}
	
	function set_alpha(value:Float):Float { 
		value = Math.round(value * 100) / 100;
		if (value < 0) value = 0;
		if (value > 1) value = 1;
		if (alpha != value) {
			//trace(["send update: " + alpha, value]);	
			displayData.alpha = alpha = value;
			
			//if (isStatic != 0) {
				//trace([this, "alpha = " + alpha]);
			//}
			updateAlpha = true;
			//isStatic = 0;
			updateStaticBackend();
			
		}
		return value;
	}
	
	function set_visible(value:Bool):Bool 
	{
		if (this.visible != value){
			this.visible = value;
			if (this.visible)	{
				displayData.visible = 1;
			}
			else				{
				displayData.visible = 0;
			}
			updateVisible = true;
			updatePosition = true; // incase the position was changed while invisible
			updateRotation = true; // incase the rotation was changed while invisible
			updateStaticBackend();
			Fuse.current.workerSetup.visibleChange(this, displayData.visible == 1);
			//isStatic = 0;
		}
		return value;
	}
	
	function setStage(value:Stage):Stage 
	{
		if (stage != null && value == null) {
			stage.onDisplayRemoved.dispatch(this);
		}
		stage = value;
		
		if (stage != null) {
			stage.onDisplayAdded.dispatch(this);
			onAddToStage.dispatch(this);
			//this.isRotating = 1; // set isRotating, isMoving and isStatic
		}
		else onRemoveFromStage.dispatch(this);
		return stage;
	}
	
	function setParent(parent:DisplayObjectContainer):Void 
	{
		if (this.parent == parent) {
			Fuse.current.workerSetup.removeChild(this);
			onRemove.dispatch(this);
		}
		this.parent = parent;
		if (parent != null && parent.stage != null) {
			if (this != parent){
				Fuse.current.workerSetup.addChild(this, parent);
				onAdd.dispatch(this);
			}
		}
		else {
			Fuse.current.workerSetup.removeChild(this);
			onRemove.dispatch(this);
		}
		
		if (parent == null) {
			setStage(null);
		}
		else {
			setStage(parent.stage);
		}
	}
	
	//function forceRedraw():Void
	//{
		//this.isStatic = 0;
	//}
	
	public function dispose():Void
	{
		this.touchable = false;
	}
	
	function dispatchInput(touch:Touch) 
	{
		// TODO: combine Touch and Mouse keys
		/*switch(touch.type) {
			case TouchEvent.TOUCH_BEGIN:onPress.dispatch(touch);
			case TouchEvent.TOUCH_MOVE:	onMove.dispatch(touch);
			case TouchEvent.TOUCH_END:	onRelease.dispatch(touch);
			case MouseEvent.MOUSE_DOWN:	onPress.dispatch(touch);
			case MouseEvent.MOUSE_MOVE:	onMove.dispatch(touch);
			case MouseEvent.MOUSE_UP:	onRelease.dispatch(touch);
			case MouseEvent.MOUSE_OVER:	onRollover.dispatch(touch);
			case MouseEvent.MOUSE_OUT:	onRollout.dispatch(touch);
		} */

		if (touch.type == TouchType.MOVE)			onMove.dispatch(touch);
		else if (touch.type == TouchType.PRESS)		onPress.dispatch(touch);
		else if (touch.type == TouchType.RELEASE)	onRelease.dispatch(touch);
		else if (touch.type == TouchType.OVER)		onRollover.dispatch(touch);
		else if (touch.type == TouchType.OUT)		onRollout.dispatch(touch);
		
		/*switch(touch.type) {
			case TouchType.PRESS:	onPress.dispatch(touch);
			case TouchType.MOVE:	onMove.dispatch(touch);
			case TouchType.RELEASE:	onRelease.dispatch(touch);
			case TouchType.OVER:	onRollover.dispatch(touch);
			case TouchType.OUT:		onRollout.dispatch(touch);
		}*/
		
	}
	
	inline function updateStaticBackend():Void
	{
		Fuse.current.workerSetup.setStatic(this);
	}
	
	function set_mask(value:Image):Image 
	{
		return value;
	}

	function set_renderLayer(value:Null<Int>):Null<Int> 
	{
		return renderLayer = value;
	}
	
	public function alignPivot(horizontalAlign:Align = Align.CENTER, verticalAlign:Align = Align.CENTER) 
	{
		this.verticalAlign = verticalAlign;
		this.horizontalAlign = horizontalAlign;
		updateAlignment();
	}
	
	public function alignPivotX(horizontalAlign:Align = Align.CENTER) 
	{
		this.horizontalAlign = horizontalAlign;
		updateAlignment();
	}
	
	public function alignPivotY(verticalAlign:Align = Align.CENTER) 
	{
		this.verticalAlign = verticalAlign;
		updateAlignment();
	}
	
	function updateAlignment() 
	{
		updateAlignmentX();
		updateAlignmentY();
	}

	function updateAlignmentX() 
	{
		if (horizontalAlign != null) {
			if (horizontalAlign == Align.LEFT) pivotX = 0;
			if (horizontalAlign == Align.RIGHT) pivotX = width;
			if (horizontalAlign == Align.CENTER) pivotX = Math.round(width / 2);
		}
	}

	function updateAlignmentY() 
	{
		if (verticalAlign != null) {
			if (verticalAlign == Align.TOP) pivotY = 0;
			if (verticalAlign == Align.BOTTOM) pivotY = height;
			if (verticalAlign == Align.CENTER) pivotY = Math.round(height / 2);
		}
	}
	
	
	public function startDrag() 
	{
		if (dragUtil == null) dragUtil = new DragUtil(this);
		dragUtil.startDrag();
	}
	
	public function stopDrag() 
	{
		dragUtil.stopDrag();
	}
	
	function get_onPress():Signal1<Touch> 
	{
		if (onPress == null) onPress = new Signal1<Touch>();
		return onPress;
	}
	
	function get_onMove():Signal1<Touch> 
	{
		if (onMove == null) onMove = new Signal1<Touch>();
		return onMove;
	}
	
	function get_onRelease():Signal1<Touch> 
	{
		if (onRelease == null) onRelease = new Signal1<Touch>();
		return onRelease;
	}
	
	function get_onRollover():Signal1<Touch> 
	{
		if (onRollover == null) onRollover = new Signal1<Touch>();
		return onRollover;
	}
	
	function get_onRollout():Signal1<Touch> 
	{
		if (onRollout == null) onRollout = new Signal1<Touch>();
		return onRollout;
	}
}