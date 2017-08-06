package fuse.core.backend.display;

import fuse.pool.Pool;

/**
 * ...
 * @author P.J.Shand
 */
class CoreStage extends CoreDisplayObject
{

	public function new() 
	{
		super();
	}
	
	override public function clone():CoreDisplayObject
	{
		return null;
	}
	
	override public function recursiveReleaseToPool()
	{
		
	}
}