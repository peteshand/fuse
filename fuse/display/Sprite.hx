package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObject;
import fuse.Fuse;

@:access(kha)
class Sprite extends DisplayObjectContainer
{
	public var children:Array<DisplayObject>;
	public var numChildren(get, null):Int;
	
	public function new() {
		super();
		displayType = DisplayType.SPRITE;
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
			child.setStage(stage);
			child.setParent(this);
			
			if (index >= 0 && index < children.length) {
				children.insert(index, child);
			}
			else {
				children.push(child);
			}
			
			//child.drawToBackBuffer();
			
			child.onAdd.dispatch();
			
			applyPosition = 1;
			applyRotation = 1;
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
	
	function get_numChildren():Int 
	{
		if (children == null) return 0;
		return children.length;
	}
	
	public function getChildAt(index:Int):DisplayObject
	{
		return children[index];
	}
	
	override function forceRedraw():Void
	{
		super.forceRedraw();
		if (children != null){
			for (i in 0...children.length) 
			{
				children[i].forceRedraw();
			}		
		}
	}
}
