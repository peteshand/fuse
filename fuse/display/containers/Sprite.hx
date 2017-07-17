package fuse.display.containers;

import fuse.display.containers.DisplayObject;
import fuse.display.containers.IDisplay;
import kha.graphics2.Graphics;
import fuse.Kea;

@:access(kha)
class Sprite extends DisplayObject implements IDisplay
{
	public function new() {
		super();
		children = [];
	}

	public function addChild(child:IDisplay):Void
	{
		addChildAt(child, -1);
	}
	
	public function addChildAt(child:IDisplay, index:Int):Void
	{
		if (children == null) children = [];
		
		
		
		//if (child.base == null || child.base.data != null){
			child.stage = stage;
			child.parent = this;
			
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
	
	function removeChild(child:IDisplay):Void
	{
		// unlink from child
		//child.next.previous = child.previous;
		
		//Kea.current.logic.displayList.remove(index + 1, child);
		
		child.stage = null;
		child.parent = null;
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
	
	override function get_totalNumChildren():Int
	{ 
		_totalNumChildren = 0;
		for (i in 0...children.length){
			_totalNumChildren++;
			_totalNumChildren += children[i].totalNumChildren;
		}
		return _totalNumChildren;
	}

	//override public function render(graphics:Graphics):Void
	//{	
		///*prerender(graphics);
		//for (i in 0...children.length){
			//children[i].render(graphics);
		//}
		//postrender(graphics);*/
	//}

	/*override private function get_changeAvailable():Bool
	{
		var returnVal:Bool = _changeAvailable;
		for (i in 0...children.length){
			if (children[i].changeAvailable) returnVal = true;
		}
		_changeAvailable = false;
		return returnVal;
	}*/
	
}
