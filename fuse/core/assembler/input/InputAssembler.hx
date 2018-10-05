package fuse.core.assembler.input;

import fuse.core.input.TouchType;
import fuse.core.utils.Calc;
import fuse.display.geometry.Bounds;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.Core;
import fuse.core.input.Touch;
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
	
	//static var objects = new Map<Int, InputAssemblerObject>();
	static var objects = new Array<InputAssemblerObject>();
	
	public function new() { }
	
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
		
		//var object:InputAssemblerObject = objects.get(index);
		//if (object == null) {
			//object = new InputAssemblerObject(index);
			//objects.set(index, object);
		//}
		//return object;
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
		var triangleSum:Float = getTriangleSum(display, touch);
		if (triangleSum > display.area + 1) { 
			// if outside bounds return only if not stage
			if (display.displayType != 0) {
				if (touch.targetId == display.objectId) {
					touch.targetId = null;
					display.onOut.index = touch.index;
					display.onOut.x = touch.x;
					display.onOut.y = touch.y;
					InputAssembler.collisions.push(display.onOut);
				}
				return false; 
			}
		}
		
		if (display.displayType != 0) {
			if (touch.targetId == null) {
				display.onOver.index = touch.index;
				display.onOver.x = touch.x;
				display.onOver.y = touch.y;
				InputAssembler.collisions.push(display.onOver);
			}
		}
		var displayTouch:Touch = getDisplayTouch(display, touch);
		InputAssembler.collisions.push(displayTouch);
		return true;
	}

	/*function testDisplay(display:CoreDisplayObject, touch:Touch)
	{
		if (display == null) return;
		// TODO: non visible displays should not be in the touchables array //trace(display.visible);
		if (display.visible == true)
		{
			var releaseOutside:Bool = touch.type == "mouseUp" && touch.targetId == display.objectId;
			
			var triangleSum:Float = getTriangleSum(display, touch);
			if (display.displayType == 0 || triangleSum <= display.area + 1 || releaseOutside) {
				if (touch.targetId != display.objectId) {						
					if (touch.targetId != -1) {
						//trace("Out");
						DispatchOut(display, touch.targetId, touch);	
						
					}
					touch.targetId = display.objectId;
					//trace("Over");
					DispatchOver(display,display.objectId, touch);
					
				}
				
				//touch.collisionId = display.objectId;
				
				var displayTouch:Touch = getDisplayTouch(display, touch);

				InputAssembler.collisions.push(displayTouch);
				return;
			}
			else if (touch.targetId == display.objectId){
				// outside
				//trace("Out");
				DispatchOut(display, display.objectId, touch);					
			}
		}
	}*/

	function getDisplayTouch(display:CoreDisplayObject, touch:Touch):Touch
	{
		var displayTouch:Touch = null;
		switch touch.type {
			case TouchType.MOVE: displayTouch = display.onMove;
			case TouchType.PRESS: displayTouch = display.onPress;	
			case TouchType.RELEASE: displayTouch = display.onRelease;
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
		if (i1.hierarchyIndex > i2.hierarchyIndex) return 1;
		else if (i1.hierarchyIndex < i2.hierarchyIndex) return -1;
		else return 0;
	}
	
	function getDistance(display:CoreDisplayObject, touch:Touch) 
	{
		return Math.sqrt(
			Math.pow(display.quadData.middleX - Calc.pixelToScreenX(touch.x), 2) + 
			Math.pow(display.quadData.middleY - Calc.pixelToScreenY(touch.y), 2)
		);
	} 
	
	
	
	function getTriangleSum(display:CoreDisplayObject, touch:Touch) 
	{
		var t1:Float = triangleArea(touch,
			display.quadData.bottomLeftX, display.quadData.bottomLeftY,
			display.quadData.topLeftX, display.quadData.topLeftY
		);
		var t2:Float = triangleArea(touch,
			display.quadData.topLeftX, display.quadData.topLeftY,
			display.quadData.topRightX, display.quadData.topRightY
		);
		var t3:Float = triangleArea(touch,
			display.quadData.topRightX, display.quadData.topRightY,
			display.quadData.bottomRightX, display.quadData.bottomRightY
		);
		var t4:Float = triangleArea(touch,
			display.quadData.bottomRightX, display.quadData.bottomRightY,
			display.quadData.bottomLeftX, display.quadData.bottomLeftY
		);
		
		return t1 + t2 + t3 + t4;
	}
	
	function triangleArea(touch:Touch, bx:Float, by:Float, cx:Float, cy:Float):Float
	{
		var ax:Float = touch.x;
		var ay:Float = touch.y;
		
		bx = (bx + 1) / 2 * Core.STAGE_WIDTH;
		by = (1 - by) / 2 * Core.STAGE_HEIGHT;
		cx = (cx + 1) / 2 * Core.STAGE_WIDTH;
		cy = (1 - cy) / 2 * Core.STAGE_HEIGHT;
		
		var a:Float = Math.sqrt(Math.pow(ax - bx, 2) + Math.pow(ay - by, 2));
		var b:Float = Math.sqrt(Math.pow(bx - cx, 2) + Math.pow(by - cy, 2));
		var c:Float = Math.sqrt(Math.pow(cx - ax, 2) + Math.pow(cy - ay, 2));
		var p:Float = (a + b + c) / 2;
		return Math.sqrt(p * (p - a) * (p - b) * (p - c));
	}
	
	function withinBounds(bounds:Bounds, touch:Touch) 
	{
		if ((touch.x / Core.STAGE_WIDTH * 2) - 1 > bounds.left && 
			(touch.x / Core.STAGE_WIDTH * 2) - 1 < bounds.right && 
			1 - (touch.y / Core.STAGE_HEIGHT * 2) < bounds.top && 
			1 - (touch.y / Core.STAGE_HEIGHT * 2) > bounds.bottom) {
				return true;
		}
		return false;
	}
}