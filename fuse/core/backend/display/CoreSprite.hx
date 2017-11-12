package fuse.core.backend.display;

import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
class CoreSprite extends CoreInteractiveObject
{

	public function new() 
	{
		super();
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreSprite = Pool.sprites.request();
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
		Pool.sprites.release(this);
	}
}