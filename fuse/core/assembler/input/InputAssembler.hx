package fuse.core.assembler.input;

import fuse.core.backend.display.CoreInteractiveObject;
import fuse.input.TouchType;
import fuse.core.utils.Calc;
import fuse.display.geometry.Bounds;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.Core;
import fuse.input.Touch;
import fuse.utils.GcoArray;
import fuse.core.backend.displaylist.DisplayType;

import openfl.events.MouseEvent;

/**
 * ...
 * @author P.J.Shand
 */
class InputAssembler
{
	public static var input = new GcoArray<Touch>([]);
	public static var collisions = new GcoArray<Touch>([]);
	static var objects = new Array<InputAssemblerObject>();
	
	public static function add(touch:Touch) 
	{
		input.push(touch);
	}
	
	static public function build() 
	{
		collisions.clear();
		for (i in 0...input.length) 
		{
			getInput(input[i].index).test(input[i]);
		}
		
		input.clear();
	}
	
	static private function getInput(index:Int):InputAssemblerObject
	{
		for (i in 0...objects.length) 
		{
			if (objects[i].index == index) return objects[i];
		}
		var object:InputAssemblerObject = new InputAssemblerObject(index);
		objects.push(object);
		return object;
	}
	
}

class InputAssemblerObject
{
	public var index:Int;
	
	public function new(index:Int)
	{
		this.index = index;
	}
	
	public function test(touch:Touch):Void
	{
		if (Touchables.requireRebuild == true){
			Touchables.requireRebuild = false;
			Touchables.flattened = [];
			for (i in 0...Touchables.touchables.length) {
				var display:CoreDisplayObject = untyped Touchables.touchables[i];
				display.addToArray(display, Touchables.flattened);
			}
		}
		// TODO: only sort when needed
		Touchables.flattened.sort(sortTouchables);

		var j:Int = Touchables.flattened.length - 1;
		while (j >= 0)
		{
			if (testDisplay(Touchables.flattened[j], touch)) {
				// hit display
				j = -1;
			}
			j--;
		}
		testDisplay(Touchables.stage, touch);
	}

	function testDisplay(display:CoreDisplayObject, touch:Touch):Bool
	{
		if (display == null) return false;
		if (display.absoluteVis() == false) return false;
		var touchDisplay:CoreDisplayObject = display.touchDisplay;
		if (touchDisplay == null) return false;

		if (touchDisplay.displayType != DisplayType.STAGE) {
			
			var _withinBound:Bool = display.withinBounds(touch.type == TouchType.PRESS, touch.x, touch.y);
			
			if (_withinBound){
				if (display.touchable == false) return false;
				if (touch.targetId == null) {
					var displayTouch = touchDisplay.onOver(touch.index);
					displayTouch.index = touch.index;
					displayTouch.x = touch.x;
					displayTouch.y = touch.y;
					addTouch(displayTouch);
					//trace("OVER");
				}
			} else {
				if (touch.targetId == touchDisplay.objectId) {
					touch.targetId = null;
					var displayTouch = touchDisplay.onOut(touch.index);
					displayTouch.index = touch.index;
					displayTouch.x = touch.x;
					displayTouch.y = touch.y;
					addTouch(displayTouch);
					//trace("OUT");
					
				}
				return false;
			}
		}

		var displayTouch:Touch = getDisplayTouch(touchDisplay, touch);
		addTouch(displayTouch);
		

		if (touchDisplay.clickThrough == true) return false;
		return true;
	}

	inline function addTouch(touch:Touch)
	{
		if (InputAssembler.collisions.indexOf(touch) == -1){
			InputAssembler.collisions.push(touch);
		}
	}

	function getDisplayTouch(display:CoreDisplayObject, touch:Touch):Touch
	{
		var displayTouch:Touch = null;
		switch touch.type {
			case TouchType.MOVE: displayTouch = display.onMove(touch.index);
			case TouchType.PRESS: displayTouch = display.onPress(touch.index);	
			case TouchType.RELEASE: displayTouch = display.onRelease(touch.index);
			default: displayTouch = null;
		}
		
		if (displayTouch == null) return null;

		displayTouch.index = touch.index;
		displayTouch.x = touch.x;
		displayTouch.y = touch.y;

		if (display.displayType != 0) {
			touch.targetId = display.objectId;
		}
		
		return displayTouch;
	}
	
	function sortTouchables(i1:CoreDisplayObject, i2:CoreDisplayObject):Int
	{
		if (i1.renderIndex > i2.renderIndex) return 1;
		else if (i1.renderIndex < i2.renderIndex) return -1;
		else if (i1.hierarchyIndex > i2.hierarchyIndex) return 1;
		else if (i1.hierarchyIndex < i2.hierarchyIndex) return -1;
		else return 0;
	}
}