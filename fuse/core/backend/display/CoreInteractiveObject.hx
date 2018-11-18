package fuse.core.backend.display;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class CoreInteractiveObject extends CoreDisplayObject
{
	public var children:Array<CoreDisplayObject> = [];
	public var numChildren(get, null):Int;
	
	public function new() 
	{
		super();
		
	}
	
	public function addChildAt(child:CoreDisplayObject, index:Int):Void
	{
		if (index == -1) {	
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
	
	override public function buildTransformActions() // new verion of buildHierarchy
	{
		visible = (Graphics.parent.visible && (displayData.visible == 1));

		if (this.visible) {
			hierarchyIndex = HierarchyAssembler.transformActions.length;
			HierarchyAssembler.transformActions.push(calculateTransform);
			for (i in 0...children.length) children[i].buildTransformActions();
			HierarchyAssembler.transformActions.push(popTransform);
		}
	}
	
	override public function buildHierarchy()
	{
		if (displayData.visible == 1) {
			for (i in 0...children.length) children[i].buildHierarchy();
		}
	}

	override public function withinBounds(debug:Bool=false, x:Float, y:Float):Bool
	{
		for (i in 0...children.length) {
			if (children[i].absoluteVis()){
				if (children[i].withinBounds(debug, x, y)){
					return true;
				}
			}
		}
		return false;
	}

	override public function addToArray(touchDisplay:CoreDisplayObject, flattened:Array<CoreDisplayObject>)
	{
		//if (touchable != false){
			for (i in 0...children.length) {
				children[i].addToArray(touchDisplay, flattened);
			}
		//}
	}
}