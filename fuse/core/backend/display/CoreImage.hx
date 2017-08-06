package fuse.core.backend.display;

import fuse.core.communication.data.displayData.IDisplayData;
import fuse.pool.Pool;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
class CoreImage extends CoreDisplayObject
{

	public function new() 
	{
		super();
	}
	
	override public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = Pool.images.request();
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
		Pool.images.release(this);
	}
}