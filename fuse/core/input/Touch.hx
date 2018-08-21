package fuse.core.input;
import fuse.display.DisplayObject;

/**
 * @author P.J.Shand
 */
typedef Touch =
{
	index:Int,
	id:String,
	?type:String,
	?x:Float,
	?y:Float,
	?collisionId:Null<Int>,
	?target:DisplayObject,
	?targetId:Int
}