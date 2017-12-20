package fuse.core.input;
import fuse.display.DisplayObject;

/**
 * @author P.J.Shand
 */
typedef InputData =
{
	index:Int,
	?type:String,
	?x:Float,
	?y:Float,
	?collisionId:Null<Int>,
	?target:DisplayObject
}