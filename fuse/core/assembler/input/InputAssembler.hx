package fuse.core.assembler.input;

import fuse.display.geometry.Bounds;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.display.CoreImage;
import fuse.core.input.FrontMouseInput;
import fuse.core.backend.Core;
import fuse.core.input.Touch;
import fuse.utils.GcoArray;

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
	
	public function new() 
	{
		
	}
	
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
	var over:Touch;
	var out:Touch;
	
	public function new(index:Int)
	{
		this.index = index;
		over = { index:index, type:MouseEvent.MOUSE_OVER };
		out = { index:index, type:MouseEvent.MOUSE_OUT };
	}
	
	public function test(touch:Touch):Void
	{
		var j:Int = Touchables.touchables.length - 1;
		while (j >= 0) 
		{
			var display:CoreImage = Touchables.touchables[j];
			
			// TODO: non visible displays should not be in the touchables array //trace(display.visible);
			if (display.visible)
			{
				var distance:Float = getDistance(display, touch);
				
				if (distance < display.diagonal * 0.5) {
					var triangleSum:Float = getTriangleSum(display, touch);
					if (triangleSum <= display.area + 1) {
						
						//if (display.visible){
							// inside
							
							if (touch.targetId != display.objectId) {						
								if (touch.targetId != -1) {
									//trace("Out");
									DispatchOut(touch.targetId, touch);	
									
								}
								touch.targetId = display.objectId;
								//trace("Over");
								DispatchOver(display.objectId, touch);
								
							}
							
							touch.collisionId = display.objectId;
							InputAssembler.collisions.push(touch);
							return;
							//j = -1;
						//}
					}
					else if (touch.targetId == display.objectId){
						// outside
						//trace("Out");
						DispatchOut(display.objectId, touch);					
					}
				}
				else if (touch.targetId == display.objectId){
					// outside
					//trace("Out");
					DispatchOut(display.objectId, touch);
				}
			}
			j--;
		}
	}
	
	function getDistance(display:CoreImage, touch:Touch) 
	{
		return Math.sqrt(
			Math.pow(display.quadData.middleX - pixelToScreenX(touch.x), 2) + 
			Math.pow(display.quadData.middleY - pixelToScreenY(touch.y), 2)
		);
	} 
	
	inline function pixelToScreenX(pixelValue:Float):Float
	{
		return ((pixelValue / Fuse.current.stage.stageWidth) - 0.5) * 2;
	}
	
	inline function pixelToScreenY(pixelValue:Float):Float
	{
		return ((pixelValue / Fuse.current.stage.stageHeight) - 0.5) * -2;
	}
	
	function getTriangleSum(display:CoreImage, touch:Touch) 
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
	
	function DispatchOver(displayObjectId:Int, touch:Touch) 
	{
		over.x = touch.x;
		over.y = touch.y;
		over.collisionId = displayObjectId;
		InputAssembler.collisions.push(over);
	}
	
	function DispatchOut(displayObjectId:Int, touch:Touch) 
	{
		touch.targetId = -1;
		out.x = touch.x;
		out.y = touch.y;
		out.collisionId = displayObjectId;
		InputAssembler.collisions.push(out);
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