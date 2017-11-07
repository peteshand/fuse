package fuse.core.backend.display;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class CoreInteractiveObject extends CoreDisplayObject
{
	var children:Array<CoreDisplayObject> = [];
	public var numChildren(get, null):Int;
	
	public function new() 
	{
		super();
		
	}
	
	public function addChildAt(child:CoreDisplayObject, index:Int):Void
	{
		if (index == -1){
			children.push(child);
		}
		else {
			children.insert(index, child);
		}
		child.parent = this;
	}
	
	public function removeChild(child:CoreDisplayObject):Void
	{
		children.remove(child);
		child.parent = null;
	}
	
	override public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		for (i in 0...children.length) children[i].buildHierarchy();
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
	}
	
	override function setChildrenIsStatic(value:Bool) 
	{
		super.setChildrenIsStatic(value);
		
		for (i in 0...children.length) 
		{
			children[i].setChildrenIsStatic(true);
		}
	}
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreInteractiveObject = Pool.interactiveObject.request();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		for (i in 0...children.length) 
		{
			_clone.children.push(children[i].clone());
		}
		return _clone;
	}
	
	override public function copyTo(destination:CoreDisplayObject) 
	{
		destination.displayData = this.displayData;
		destination.objectId = this.objectId;
		for (i in 0...children.length) 
		{
			var clonedChild:CoreDisplayObject = children[i].clone();
			children[i].copyTo(clonedChild);
			if (Std.is(destination, CoreInteractiveObject)) {
				var d:CoreInteractiveObject = untyped destination;
				d.addChildAt(clonedChild, d.children.length);
			}	
		}
	}
	
	override public function recursiveReleaseToPool() 
	{
		while (children.length > 0)
		{
			children[0].recursiveReleaseToPool();
			children.shift();
		}
		Pool.interactiveObject.release(this);
	}
	
	public function getChildAt(index:Int):CoreDisplayObject
	{
		return children[index];
	}
	
	function get_numChildren():Int 
	{
		return numChildren;
	}
}