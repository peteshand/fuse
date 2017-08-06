package fuse.core.backend.display;

import fuse.core.communication.data.displayData.IDisplayData;
import fuse.pool.Pool;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
class CoreSprite extends CoreDisplayObject
{

	public function new() 
	{
		super();
	}
	
	override public function setAtlasTextures() 
	{
		
	}
	
	override public function checkLayerCache() 
	{
		
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = Pool.sprites.request();
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