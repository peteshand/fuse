package kea.logic.displaylist;

import kea.display.IDisplay;
import kha.graphics2.Graphics;

@:access(kea.Kea)
class DisplayList
{	
	public var renderList:Array<IDisplay> = [];
	//public var justAdded:Array<IDisplay> = [];
	public var lowestChange:Int = 1073741823;
	
	var layerIndicesMap = new Map<Int, Int>();
	public var layerIndices:Array<Int> = [];
	
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
	
	public function removeLayerIndex(layerIndex:Null<Int>) 
	{
		if (layerIndicesMap.exists(layerIndex)) {
			var newValue:Int = layerIndicesMap.get(layerIndex) - 1;
			if (newValue > 0) layerIndicesMap.set(layerIndex, newValue);
			else {
				var i:Int = layerIndices.length - 1;
				while (i >= 0) 
				{
					if (layerIndices[i] == layerIndex) layerIndices.splice(i, 1);
					i--;
				}
				layerIndicesMap.remove(layerIndex);
			}
		}
	}
	
	public function addLayerIndex(layerIndex:Null<Int>) 
	{
		if (!layerIndicesMap.exists(layerIndex)) {
			layerIndicesMap.set(layerIndex, 0);
			layerIndices.push(layerIndex);
		}
		else {
			layerIndicesMap.set(layerIndex, layerIndicesMap.get(layerIndex) + 1);
		}
	}
	
	public function update(graphics:Graphics) 
	{
		Kea.calcTransformIndex = -1;
		Kea.current.stage.calcTransform(graphics);
	}
}
