package fuse.core.communication.data.displayData;
import fuse.utils.Color;


/**
 * @author P.J.Shand
 */

//interface IDisplayData 
//{
	//public var x(get, set):Float;
	//public var y(get, set):Float;
	//public var width(get, set):Float;
	//public var height(get, set):Float;
	//public var pivotX(get, set):Float;
	//public var pivotY(get, set):Float;
	//public var scaleX(get, set):Float;
	//public var scaleY(get, set):Float;
	//public var rotation(get, set):Float;
	//public var alpha(get, set):Float;
	//public var color(get, set):UInt;
	//public var colorTL(get, set):UInt;
	//public var colorTR(get, set):UInt;
	//public var colorBL(get, set):UInt;
	//public var colorBR(get, set):UInt;
	//public var objectId(get, never):Int;
	//public var textureId(get, set):Int;
	//public var renderLayer(get, set):Int;
	//public var visible(get, set):Int;
	//public var isStatic(get, set):Int;
//}

typedef IDisplayData =
{
	x:Float,
	y:Float,
	width:Float,
	height:Float,
	pivotX:Float,
	pivotY:Float,
	scaleX:Float,
	scaleY:Float,
	rotation:Float,
	alpha:Float,
	color:UInt,
	colorTL:UInt,
	colorTR:UInt,
	colorBL:UInt,
	colorBR:UInt,
	objectId:Int,
	textureId:Int,
	renderLayer:Int,
	visible:Int/*,
	isStatic:Int,
	isMoving:Int,
	isRotating:Int*/
}