package fuse.display.renderables;
import fuse.display._private.PrivateDisplayBase;
import fuse.display.containers.DisplayObject;

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
}