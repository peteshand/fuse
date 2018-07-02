package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.InteractiveObject;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayObjectContainer extends InteractiveObject
{
	public var children:Array<DisplayObject>;
	public var numChildren(get, never):Int;
	
	public function new() 
	{
		super();
		displayType = DisplayType.DISPLAY_OBJECT;
		children = [];
	}
	
	
	public function addChild(child:DisplayObject):Void
	{
		addChildAt(child, -1);
	}
	
	public function addChildAt(child:DisplayObject, index:Int):Void
	{
		if (children == null) children = [];
		
		
		
		//if (child.base == null || child.base.data != null){
			child.setParent(this);
			
			if (index >= 0 && index < children.length) {
				children.insert(index, child);
			}
			else {
				children.push(child);
			}
			
			//child.drawToBackBuffer();
			
			//applyPosition = 1;
			//applyRotation = 1;
			//updateAll = true;
			updatePosition = true;
			updateRotation = true;
			updateStaticBackend();
			//isStatic = 0;
		/*}
		else {
			//trace("Wait for upload");
			TextureHelper.register(child, this, index);
		}*/
	}
	
	public function removeChild(child:DisplayObject):Void
	{
		// unlink from child
		//child.next.previous = child.previous;
		
		//Kea.current.logic.displayList.remove(index + 1, child);
		
		child.setStage(null);
		child.setParent(null);
		var i:Int = children.length - 1;
		while (i >= 0) 
		{
			if (children[i] == child) {
				children.splice(i, 1);
			}
			i--;
		}
		//isStatic = 0;
	}
	
	override function setParent(value:DisplayObjectContainer):Void 
	{
		super.setParent(value);
		
		if (parent != null) {
			for (i in 0...children.length) children[i].setParent(this);
		}
		else {
			for (i in 0...children.length) children[i].setParent(null);
		}
	}
	
	public function getChildAt(index:Int):DisplayObject
	{
		if (children.length <= index) return null;
		return children[index];
	}
	
	function get_numChildren():Int 
	{
		if (children == null) return 0;
		return children.length;
	}
	
	override function set_mask(value:Image):Image 
	{
		for (i in 0...children.length) 
		{
			children[i].mask = value;
		}
		return value;
	}
}