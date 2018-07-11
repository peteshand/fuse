package fuse.core.backend.display;

import fuse.core.utils.Calc;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class CoreStage extends CoreInteractiveObject
{

	public function new() 
	{
		super();
		setUpdates(false);
	}
	
	override public function clone():CoreDisplayObject
	{
		return null;
	}
	
	override public function recursiveReleaseToPool()
	{
		
	}
	
	override public function insideBounds(x:Float, y:Float) 
	{
		return true;
	}
}