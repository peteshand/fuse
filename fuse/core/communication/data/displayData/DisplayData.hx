package fuse.core.communication.data.displayData;

import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */

class DisplayData
{
	public var x:Float = 0;
	public var y:Float = 0;
	public var width:Float = 0;
	public var height:Float = 0;
	public var pivotX:Float = 0;
	public var pivotY:Float = 0;
	public var scaleX:Float = 0;
	public var scaleY:Float = 0;
	public var rotation:Float = 0;
	public var alpha:Float = 0;
	public var color:UInt = 0;
	public var colorTL:UInt = 0;
	public var colorTR:UInt = 0;
	public var colorBL:UInt = 0;
	public var colorBR:UInt = 0;
	public var textureId:Int = 0;
	public var renderLayer:Int = 0;
	
	public var visible:Int = 0;
	public var blendMode:Int = 0;
	
	public var shaderId:Int = 0;

	public var isStatic:Int = 0;
	public var isMoving:Int = 0;
	public var isRotating:Int = 0;
	
	public var objectId:ObjectId;
	
	public function new(objectOffset:Null<Int>)
	{
		objectId = objectOffset;
	}
}