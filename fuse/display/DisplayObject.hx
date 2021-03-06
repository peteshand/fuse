package fuse.display;

import openfl.events.EventDispatcher;
import fuse.input.TouchType;
import fuse.core.backend.displaylist.DisplayType;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.input.Touch;
import fuse.display.Stage;
import fuse.utils.Align;
import fuse.utils.Color;
import fuse.Fuse;
import fuse.utils.drag.DragUtil;
import signals.Signal1;
import fuse.utils.ObjectId;
import openfl.geom.Rectangle;

@:access(fuse)
class DisplayObject extends EventDispatcher {
	static var objectIdCount:Int = 0;

	public var objectId:ObjectId;
	public var displayData:IDisplayData;
	public var name:String;
	// public var onAdd = new Signal0();
	public var onAdd = new Signal1<DisplayObject>();
	public var onRemove = new Signal1<DisplayObject>();
	public var onAddToStage = new Signal1<DisplayObject>();
	public var onRemoveFromStage = new Signal1<DisplayObject>();
	@:isVar public var touchable(get, set):Null<Bool> = null;
	@:isVar public var clickThrough(get, set):Null<Bool> = null;
	public var _onPress:Signal1<Touch>;
	public var _onMove:Signal1<Touch>;
	public var _onRelease:Signal1<Touch>;
	public var _onRollover:Signal1<Touch>;
	public var _onRollout:Signal1<Touch>;
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
	// @:isVar public var blendMode(get, set):BlendMode;
	@:isVar public var bounds(get, never):Rectangle = new Rectangle();
	public var displayType:DisplayType;

	// var updateUVs:Bool = false;
	var updateTexture:Bool = false; // only used for Images
	// var updateMask:Bool = false;
	// var updateAll:Bool = true;
	var updatePosition:Bool = true;
	var updateRotation:Bool = true;
	var updateColour:Bool = true;
	var updateVisible:Bool = true;
	var updateAlpha:Bool = true;
	var updateUVs:Bool = true;
	var updateTouchable:Bool = true;
	var horizontalAlign:Align;
	var verticalAlign:Align;

	public var dragUtil(get, null):DragUtil;

	public function new() {
		displayType = DisplayType.DISPLAY_OBJECT;
		stage = Fuse.current.stage;

		var id:Int = DisplayObject.objectIdCount++;
		displayData = CommsObjGen.getDisplayData(id);

		objectId = id;
		scaleX = 1;
		scaleY = 1;
		color = 0x00000000;
		alpha = 1;
		visible = true;

		displayData.textureId = -1;
		super();
	}

	public function resetMovement() {
		updatePosition = false;
		updateRotation = false;
		updateColour = false;
		updateVisible = false;
		updateAlpha = false;
		updateUVs = false;
		updateTouchable = false;
	}

	inline function get_touchable():Null<Bool> {
		return touchable;
	}

	inline function get_clickThrough():Null<Bool> {
		return clickThrough;
	}

	inline function get_x():Float {
		return x;
	}

	inline function get_y():Float {
		return y;
	}

	function get_width():Float {
		return width;
	}

	function get_height():Float {
		return height;
	}

	function get_pivotX():Float {
		return pivotX;
	}

	function get_pivotY():Float {
		return pivotY;
	}

	inline function get_rotation():Float {
		return rotation;
	}

	inline function get_scaleX():Float {
		return scaleX;
	}

	inline function get_scaleY():Float {
		return scaleY;
	}

	function get_color():Color {
		return colorTL;
	}

	inline function get_colorTL():Color {
		return colorTL;
	}

	inline function get_colorTR():Color {
		return colorTR;
	}

	inline function get_colorBL():Color {
		return colorBL;
	}

	inline function get_colorBR():Color {
		return colorBR;
	}

	inline function get_alpha():Float {
		return alpha;
	}

	function get_visible():Bool {
		return visible;
	}

	inline function set_touchable(value:Null<Bool>):Null<Bool> {
		if (touchable != value) {
			touchable = value;
			Fuse.current.workerSetup.setTouchable(this, touchable, clickThrough);
		}
		return value;
	}

	inline function set_clickThrough(value:Null<Bool>):Null<Bool> {
		if (clickThrough != value) {
			clickThrough = value;
			Fuse.current.workerSetup.setTouchable(this, touchable, clickThrough);
		}
		return value;
	}

	function set_x(value:Float):Float {
		if (floatHasChanged(x, value)) {
			displayData.x = x = value;
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_y(value:Float):Float {
		if (floatHasChanged(y, value)) {
			displayData.y = y = value;
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_width(value:Float):Float {
		if (floatHasChanged(width, value)) {
			displayData.width = width = value;
			updateAlignmentX();
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_height(value:Float):Float {
		if (floatHasChanged(height, value)) {
			displayData.height = height = value;
			updateAlignmentY();
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_pivotX(value:Float):Float {
		if (floatHasChanged(pivotX, value)) {
			displayData.pivotX = pivotX = value;
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_pivotY(value:Float):Float {
		if (floatHasChanged(pivotY, value)) {
			displayData.pivotY = pivotY = value;
			updatePosition = true;
			// isMoving = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_rotation(value:Float):Float {
		if (floatHasChanged(rotation, value, 100)) {
			displayData.rotation = rotation = value;
			// trace("rotation = " + value);

			updatePosition = true;
			updateRotation = true;
			// isRotating = 1;
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleX(value:Float):Float {
		if (scaleX != value) {
			displayData.scaleX = scaleX = value;
			updatePosition = true;
			// isMoving = 1;

			updateAlignmentX();
			updateStaticBackend();
		}
		return value;
	}

	function set_scaleY(value:Float):Float {
		if (scaleY != value) {
			displayData.scaleY = scaleY = value;
			updatePosition = true;
			// isMoving = 1;

			updateAlignmentY();
			updateStaticBackend();
		}
		return value;
	}

	function set_color(value:Color):Color {
		if (color != value) {
			displayData.color = color = colorTL = colorTR = colorBL = colorBR = value;
			updateColour = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_colorTL(value:Color):Color {
		if (colorTL != value) {
			displayData.colorTL = colorTL = value;
			updateColour = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_colorTR(value:Color):Color {
		if (colorTR != value) {
			displayData.colorTR = colorTR = value;
			updateColour = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_colorBL(value:Color):Color {
		if (colorBL != value) {
			displayData.colorBL = colorBL = value;
			updateColour = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_colorBR(value:Color):Color {
		if (colorBR != value) {
			displayData.colorBR = colorBR = value;
			updateColour = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_alpha(value:Float):Float {
		value = Math.round(value * 100) / 100;
		if (value < 0)
			value = 0;
		if (value > 1)
			value = 1;
		if (alpha != value) {
			// trace(["send update: " + alpha, value]);
			displayData.alpha = alpha = value;

			// if (isStatic != 0) {
			// trace([this, "alpha = " + alpha]);
			// }
			updateAlpha = true;
			// isStatic = 0;
			updateStaticBackend();
		}
		return value;
	}

	function set_visible(value:Bool):Bool {
		if (this.visible != value) {
			this.visible = value;
			if (this.visible) {
				displayData.visible = 1;
			} else {
				displayData.visible = 0;
			}
			updateVisible = true;
			updatePosition = true; // incase the position was changed while invisible
			updateRotation = true; // incase the rotation was changed while invisible
			updateStaticBackend();
			Fuse.current.workerSetup.visibleChange(this, displayData.visible == 1);
			// isStatic = 0;
		}
		return value;
	}

	function get_bounds():Rectangle {
		return bounds;
	}

	function setStage(value:Stage):Stage {
		if (stage != null && value == null) {
			stage.onDisplayRemoved.dispatch(this);
		}
		if (value == null) {
			onRemoveFromStage.dispatch(this);
		}
		stage = value;

		if (stage != null) {
			stage.onDisplayAdded.dispatch(this);
			onAddToStage.dispatch(this);
			// this.isRotating = 1; // set isRotating, isMoving and isStatic
		}
		return stage;
	}

	function setParent(parent:DisplayObjectContainer):Void {
		if (this.parent == parent) {
			Fuse.current.workerSetup.removeChild(this);
			onRemove.dispatch(this);
		}
		this.parent = parent;
		if (parent != null && parent.stage != null) {
			if (this != parent) {
				Fuse.current.workerSetup.addChild(this, parent);
				onAdd.dispatch(this);
			}
		} else {
			Fuse.current.workerSetup.removeChild(this);
			onRemove.dispatch(this);
		}

		if (parent == null) {
			setStage(null);
		} else {
			setStage(parent.stage);
		}
	}

	public function dispose():Void {
		this.touchable = false;
	}

	function dispatchInput(touch:Touch) {
		if (touch.type == TouchType.MOVE)
			onMove.dispatch(touch);
		else if (touch.type == TouchType.PRESS)
			onPress.dispatch(touch);
		else if (touch.type == TouchType.RELEASE)
			onRelease.dispatch(touch);
		else if (touch.type == TouchType.OVER)
			onRollover.dispatch(touch);
		else if (touch.type == TouchType.OUT)
			onRollout.dispatch(touch);
	}

	inline function updateStaticBackend():Void {
		Fuse.current.workerSetup.setStatic(this);
	}

	function set_mask(value:Image):Image {
		return value;
	}

	function set_renderLayer(value:Null<Int>):Null<Int> {
		return renderLayer = value;
	}

	public function alignPivot(horizontalAlign:Align = Align.CENTER, verticalAlign:Align = Align.CENTER) {
		this.verticalAlign = verticalAlign;
		this.horizontalAlign = horizontalAlign;
		updateAlignment();
	}

	public function alignPivotX(horizontalAlign:Align = Align.CENTER) {
		this.horizontalAlign = horizontalAlign;
		updateAlignment();
	}

	public function alignPivotY(verticalAlign:Align = Align.CENTER) {
		this.verticalAlign = verticalAlign;
		updateAlignment();
	}

	function updateAlignment() {
		updateAlignmentX();
		updateAlignmentY();
	}

	function updateAlignmentX() {
		if (horizontalAlign != null) {
			pivotX = Math.round(scaleX * Math.abs(width) * cast(horizontalAlign, Float));
		}
	}

	function updateAlignmentY() {
		if (verticalAlign != null) {
			pivotY = Math.round(scaleY * Math.abs(height) * cast(verticalAlign, Float));
		}
	}

	public function startDrag(xAxis:Bool = true, yAxis:Bool = true) {
		dragUtil.startDrag(xAxis, yAxis);
	}

	public function stopDrag() {
		dragUtil.stopDrag();
	}

	function get_onPress():Signal1<Touch> {
		if (_onPress == null) {
			_onPress = new Signal1<Touch>();
			updateTouchable = true;
			updateStaticBackend();
		}
		return _onPress;
	}

	function get_onMove():Signal1<Touch> {
		if (_onMove == null) {
			_onMove = new Signal1<Touch>();
			updateTouchable = true;
			updateStaticBackend();
		}
		return _onMove;
	}

	function get_onRelease():Signal1<Touch> {
		if (_onRelease == null) {
			_onRelease = new Signal1<Touch>();
			updateTouchable = true;
			updateStaticBackend();
		}
		return _onRelease;
	}

	function get_onRollover():Signal1<Touch> {
		if (_onRollover == null) {
			_onRollover = new Signal1<Touch>();
			updateTouchable = true;
			updateStaticBackend();
		}
		return _onRollover;
	}

	function get_onRollout():Signal1<Touch> {
		if (_onRollout == null) {
			_onRollout = new Signal1<Touch>();
			updateTouchable = true;
			updateStaticBackend();
		}
		return _onRollout;
	}

	function checkTouchable() {
		var numListeners:Int = 0;
		if (_onPress != null)
			numListeners += _onPress.numListeners;
		if (_onMove != null)
			numListeners += _onMove.numListeners;
		if (_onRelease != null)
			numListeners += _onRelease.numListeners;
		if (_onRollover != null)
			numListeners += _onRollover.numListeners;
		if (_onRollout != null)
			numListeners += _onRollout.numListeners;
		// trace("touchable = " + touchable);
		// trace("numListeners = " + numListeners);
		// trace(this.objectId);
		// if (numListeners == 0) touchable = false;
		// else touchable = true;
	}

	inline function floatHasChanged(current:Float, _new:Float, decimalPlaces:Int = 10):Bool {
		if (current == _new)
			return false;
		return Math.floor(Math.abs(current - _new) * decimalPlaces) > 0;
	}

	function get_dragUtil():DragUtil {
		if (dragUtil == null)
			dragUtil = new DragUtil(this);
		return dragUtil;
	}
}
