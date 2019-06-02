package fuse.display;

import fuse.input.Touch;
import signal.Signal1;
import fuse.core.backend.displaylist.DisplayType;
import fuse.display.InteractiveObject;
import fuse.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayObjectContainer extends InteractiveObject {
	public var children:Array<DisplayObject>;
	public var numChildren(get, never):Int;

	public function new() {
		super();
		displayType = DisplayType.DISPLAY_OBJECT;
		children = [];
	}

	public function addChild(child:DisplayObject):Void {
		addChildAt(child, -1);
	}

	public function addChildAt(child:DisplayObject, index:Int):Void {
		if (children == null)
			children = [];

		// if (child.common == null || child.common.data != null){
		child.setParent(this);

		if (index >= 0 && index < children.length) {
			children.insert(index, child);
		} else {
			children.push(child);
		}
		if (this.renderLayer != null && child.renderLayer == null) {
			child.renderLayer = this.renderLayer;
		}

		// child.drawToBackBuffer();

		// applyPosition = 1;
		// applyRotation = 1;
		// updateAll = true;
		updatePosition = true;
		updateRotation = true;
		updateStaticBackend();
		// isStatic = 0;
		/*}
			else {
				//trace("Wait for upload");
				TextureHelper.register(child, this, index);
		}*/
	}

	public function removeChild(child:DisplayObject):Void {
		if (child == null)
			return;
		// unlink from child
		// child.next.previous = child.previous;

		// Kea.current.logic.displayList.remove(index + 1, child);

		child.setStage(null);
		child.setParent(null);
		var i:Int = children.length - 1;
		while (i >= 0) {
			if (children[i] == child) {
				children.splice(i, 1);
			}
			i--;
		}
		// isStatic = 0;
	}

	public function setChildIndex(child:DisplayObject, index:Int):Void {
		this.updatePosition = true;
		this.updateRotation = true;
		Fuse.current.workerSetup.setChildIndex(child, index, this);
	}

	override function setParent(value:DisplayObjectContainer):Void {
		super.setParent(value);
		if (parent != null) {
			for (i in 0...children.length)
				children[i].setParent(this);
		} else {
			for (i in 0...children.length)
				children[i].setParent(null);
		}
	}

	public function getChildAt(index:Int):DisplayObject {
		if (children.length <= index)
			return null;
		return children[index];
	}

	function get_numChildren():Int {
		if (children == null)
			return 0;
		return children.length;
	}

	override function set_mask(value:Image):Image {
		for (i in 0...children.length) {
			children[i].mask = value;
		}
		return value;
	}

	override function set_renderLayer(value:Null<Int>):Null<Int> {
		for (i in 0...children.length) {
			children[i].renderLayer = value;
		}
		return renderLayer = value;
	}

	override public function dispose():Void {
		super.dispose();
		for (i in 0...children.length) {
			children[i].dispose();
		}
	}

	override function get_bounds():Rectangle {
		// only hald implemented
		var low:Rectangle = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, 0, 0);
		var high:Rectangle = new Rectangle(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, 0, 0);

		for (i in 0...children.length) {
			if (low.x > children[i].bounds.x)
				low.x = children[i].bounds.x;
			if (high.x < children[i].bounds.x)
				high.x = children[i].bounds.x;
			if (low.y > children[i].bounds.y)
				low.y = children[i].bounds.y;
			if (high.y < children[i].bounds.y)
				high.y = children[i].bounds.y;
		}

		bounds.x = low.x;
		bounds.y = high.y;
		bounds.width = high.x - low.x;
		bounds.height = high.y - low.y;

		return bounds;
	}
	/*override function get_onPress():Signal1<Touch> 
		{
			var onPress = super.get_onPress();
			for (i in 0...children.length) children[i].onPress.add(onPress.dispatch);
			return onPress;
		}

		override function get_onMove():Signal1<Touch>
		{
			var onMove = super.get_onMove();
			for (i in 0...children.length) children[i].onMove.add(onMove.dispatch);
			return onMove;
		}

		override function get_onRelease():Signal1<Touch>
		{
			var onRelease = super.get_onRelease();
			for (i in 0...children.length) children[i].onRelease.add(onRelease.dispatch);
			return onRelease;
		}

		override function get_onRollover():Signal1<Touch>
		{
			var onRollover = super.get_onRollover();
			for (i in 0...children.length) children[i].onRollover.add(onRollover.dispatch);
			return onRollover;
		}

		override function get_onRollout():Signal1<Touch>
		{
			var onRollout = super.get_onRollout();
			for (i in 0...children.length) children[i].onRollout.add(onRollout.dispatch);
			return onRollout;
	}*/
}
