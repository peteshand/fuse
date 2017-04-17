package kea.core.render;

import kea.display.IDisplay;

class UpdateList
{	
	public var renderList:Array<IDisplay> = [];
	//public var justAdded:Array<IDisplay> = [];
	public var lowestChange:Int = 1073741823;

	public function new() {
		
	}

	public function add(index:Int, display:IDisplay):Void
	{
		
		if (display.parent != null) return;

		if (index >= renderList.length) pushToRenderList(display);
		else insertToRenderList(index, display);

		//justAdded.push(display);
		if (lowestChange > index-1){
			lowestChange = index-1;
			
		}
		//trace("lowestChange = " + lowestChange);
		//changeAvailable = true;
	}

	public inline function pushToRenderList(display:IDisplay):Void
	{
		renderList.push(display);
	}

	public inline function insertToRenderList(index:Int, display:IDisplay):Void
	{
		renderList[index].previous = display;
		renderList[index]._renderIndex++;
		renderList.insert(index, display);
	}
}
