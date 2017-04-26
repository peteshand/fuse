package kea.display;

import kha.graphics2.Graphics;
import kea.Kea;

class Sprite extends DisplayObject implements IDisplay
{
	public function new() {
		super();
		children = [];
	}

	function addChild(child:IDisplay):Void
	{
		if (children == null) children = [];
		
		var parentIndex:Int = this.renderIndex;
		//stage.renderList.insert(parentIndex + children.length + 1, child);
		
		var index:Int = parentIndex + totalNumChildren;
		//child.previous = stage.layerRenderer.renderList[index];
		
		//stage.layerRenderer.add(index + 1, child);
		child.previous = Kea.current.logic.displayList.renderList[index];
		Kea.current.logic.displayList.add(index + 1, child);
		
		child.stage = stage;
		child.parent = this;
		children.push(child);
		//child.drawToBackBuffer();
		
		child.onAdd.dispatch();
	}
	
	function removeChild(child:IDisplay):Void
	{
		// unlink from child
		child.next.previous = child.previous;
		
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
