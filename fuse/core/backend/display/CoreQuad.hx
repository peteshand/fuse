package fuse.core.backend.display;
import fuse.pool.Pool;

/**
 * ...
 * @author P.J.Shand
 */
class CoreQuad extends CoreDisplayObject
{

	public function new() 
	{
		super();
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = Pool.quads.request();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		for (i in 0...children.length) 
		{
			_clone.children.push(children[i].clone());
		}
		return _clone;
	}
	
	override public function recursiveReleaseToPool()
	{
		while (children.length > 0)
		{
			children[0].recursiveReleaseToPool();
			children.shift();
		}
		Pool.quads.release(this);
	}
}