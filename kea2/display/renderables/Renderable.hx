package kea2.display.renderables;
import kea2.display._private.PrivateDisplayBase;
import kea2.display.containers.DisplayObject;

/**
 * ...
 * @author P.J.Shand
 */
class Renderable extends DisplayObject
{
	public inline function new():Void
	{	
		super();
		this.renderId = PrivateDisplayBase.renderIdCount++;
	}
	
	/*override function set_renderId(value:Int):Int 
	{
		return displayDataAccess.renderId = value;
	}*/
}