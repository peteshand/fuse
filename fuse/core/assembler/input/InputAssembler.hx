package fuse.core.assembler.input;

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
		Touchables.touchables.sort(sortTouchables);
		
		var j:Int = Touchables.touchables.length - 1;
		while (j >= 0)
		{
			//trace([Touchables.touchables[j].objectId, Touchables.touchables[j].renderIndex, Touchables.touchables[j].hierarchyIndex]);

			if (testDisplay(Touchables.touchables[j], touch)) {
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
		if (display.displayType != DisplayType.STAGE) {
			var _withinBound:Bool = display.withinBounds(touch.x, touch.y);
			if (_withinBound){
				if (touch.targetId == null) {
					var displayTouch = display.onOver(touch.index);
					displayTouch.index = touch.index;
					displayTouch.x = touch.x;
					displayTouch.y = touch.y;
					InputAssembler.collisions.push(displayTouch);
					//trace("OVER");
				}
			} else {
				if (touch.targetId == display.objectId) {
					touch.targetId = null;
					var displayTouch = display.onOut(touch.index);
					displayTouch.index = touch.index;
					displayTouch.x = touch.x;
					displayTouch.y = touch.y;
					InputAssembler.collisions.push(displayTouch);
					//trace("OUT");
					
				}
				return false;
			}
		}

		var displayTouch:Touch = getDisplayTouch(display, touch);
		InputAssembler.collisions.push(displayTouch);
		return true;
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
		
		// TODO: take into account renderLayerIndex
		/*if (i1.renderIndex > i2.renderIndex) return 1;
		else if (i1.renderIndex < i2.renderIndex) return -1;
		else */if (i1.hierarchyIndex > i2.hierarchyIndex) return 1;
		else if (i1.hierarchyIndex < i2.hierarchyIndex) return -1;
		else return 0;
	}
	
	/*function getDistance(display:CoreDisplayObject, touch:Touch) 
	{
		return Math.sqrt(
			Math.pow(display.quadData.middleX - Calc.pixelToScreenX(touch.x), 2) + 
			Math.pow(display.quadData.middleY - Calc.pixelToScreenY(touch.y), 2)
		);
	}*/
}