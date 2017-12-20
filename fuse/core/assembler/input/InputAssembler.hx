package fuse.core.assembler.input;
import fuse.core.input.FrontMouseInput;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreImage;
import fuse.core.input.InputData;
import fuse.display.geometry.Bounds;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.utils.Rect;
import openfl.events.MouseEvent;

/**
 * ...
 * @author P.J.Shand
 */
class InputAssembler
{
	public static var input = new GcoArray<InputData>([]);
	public static var collisions = new GcoArray<InputData>([]);
	
	static var objects = new Map<Int, InputAssemblerObject>();
	
	public function new() 
	{
		
	}
	
	public static function add(mouseData:InputData) 
	{
		input.push(mouseData);
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
		var object:InputAssemblerObject = objects.get(index);
		if (object == null) {
			object = new InputAssemblerObject(index);
			objects.set(index, object);
		}
		return object;
	}
	
}

class InputAssemblerObject
{
	var index:Int;
	var over:InputData;
	var out:InputData;
	
	public function new(index:Int)
	{
		this.index = index;
		over = { index:index, type:MouseEvent.MOUSE_OVER };
		out = { index:index, type:MouseEvent.MOUSE_OUT };
	}
	
	public function test(mouseData:InputData):Void
	{
		var j:Int = HierarchyAssembler.hierarchy.length - 1;
		while (j >= 0) 
		{
			var display:CoreImage = HierarchyAssembler.hierarchy[j];
			var distance:Float = getDistance(display, mouseData);
			
			if (distance < display.diagonal) {
				var triangleSum:Float = getTriangleSum(display, mouseData);
				if (triangleSum <= display.area + 1) {
					// inside
					if (!display.over) {
						display.over = true;
						DispatchOver(display.objectId, mouseData);
					}
					
					mouseData.collisionId = display.objectId;
					
					InputAssembler.collisions.push(mouseData);
					j = -1;
				}
				else if (display.over){
					// outside
					display.over = false;
					DispatchOut(display.objectId, mouseData);					
				}
			}
			else if (display.over){
				// outside
				display.over = false;
				DispatchOut(display.objectId, mouseData);
			}
			
			j--;
		}
	}
	
	function getDistance(display:CoreImage, mouseData:InputData) 
	{
		return Math.sqrt(Math.pow(display.displayData.x - mouseData.x, 2) + Math.pow(display.displayData.y - mouseData.y, 2));
	}
	
	function getTriangleSum(display:CoreImage, mouseData:InputData) 
	{
		var t1:Float = triangleArea(mouseData,
			display.quadData.bottomLeftX, display.quadData.bottomLeftY,
			display.quadData.topLeftX, display.quadData.topLeftY
		);
		var t2:Float = triangleArea(mouseData,
			display.quadData.topLeftX, display.quadData.topLeftY,
			display.quadData.topRightX, display.quadData.topRightY
		);
		var t3:Float = triangleArea(mouseData,
			display.quadData.topRightX, display.quadData.topRightY,
			display.quadData.bottomRightX, display.quadData.bottomRightY
		);
		var t4:Float = triangleArea(mouseData,
			display.quadData.bottomRightX, display.quadData.bottomRightY,
			display.quadData.bottomLeftX, display.quadData.bottomLeftY
		);
		
		return t1 + t2 + t3 + t4;
	}
	
	function triangleArea(mouseData:InputData, bx:Float, by:Float, cx:Float, cy:Float):Float
	{
		var ax:Float = mouseData.x;
		var ay:Float = mouseData.y;
		
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
	
	function DispatchOver(displayObjectId:Int, mouseData:InputData) 
	{
		over.x = mouseData.x;
		over.y = mouseData.y;
		over.collisionId = displayObjectId;
		InputAssembler.collisions.push(over);
	}
	
	function DispatchOut(displayObjectId:Int, mouseData:InputData) 
	{
		out.x = mouseData.x;
		out.y = mouseData.y;
		out.collisionId = displayObjectId;
		InputAssembler.collisions.push(out);
	}
	
	function withinBounds(bounds:Bounds, mouseData:InputData) 
	{
		if ((mouseData.x / Core.STAGE_WIDTH * 2) - 1 > bounds.left && 
			(mouseData.x / Core.STAGE_WIDTH * 2) - 1 < bounds.right && 
			1 - (mouseData.y / Core.STAGE_HEIGHT * 2) < bounds.top && 
			1 - (mouseData.y / Core.STAGE_HEIGHT * 2) > bounds.bottom) {
				return true;
		}
		return false;
	}
}