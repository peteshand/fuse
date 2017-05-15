package kea.logic.displaylist;

import flash.display.BitmapData;
import kea.display.DisplayObject;
import kea.display.IDisplay;
import kea.display.Sprite;
import kea.display._private.Background;
import kea.texture.Texture;
import kha.graphics2.Graphics;

@:access(kea.Kea)
class DisplayList
{	
	static var updateHierarchy:Bool = false;
	
	public var renderList:Array<IDisplay> = [];
	var renderMap:Map<IDisplay, Bool> = new Map<IDisplay, Bool>();
	
	//public var justAdded:Array<IDisplay> = [];
	//public var lowestChange:Int = 1073741823;
	
	var layerIndicesMap = new Map<Int, Int>();
	//public var background:Background;
	public var layerIndices:Array<Int> = [];
	
	public function new() {
		
	}
	
	public function init() 
	{
		//background = new Background();
		//add(background);
	}

	//public function add(index:Int, display:IDisplay):Void
	//{
		//if (display.parent != null) return;
		//
		//if (index >= renderList.length) pushToRenderList(display);
		//else insertToRenderList(index, display);
		//
		////justAdded.push(display);
		//if (lowestChange > index-1){
			//lowestChange = index-1;
			//
		//}
		////trace("lowestChange = " + lowestChange);
		////changeAvailable = true;
	//}
//
	//public inline function pushToRenderList(display:IDisplay):Void
	//{
		//renderList.push(display);
	//}
//
	//public inline function insertToRenderList(index:Int, display:IDisplay):Void
	//{
		//renderList[index].previous = display;
		//renderList[index]._renderIndex++;
		//renderList.insert(index, display);
	//}
	//
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
		if (DisplayList.updateHierarchy) {
			DisplayList.updateHierarchy = false;
			renderList = [];
			renderMap = new Map<IDisplay, Bool>();
			Kea.current.stage.buildHierarchy();
		}
		
		Kea.calcTransformIndex = -1;
		Kea.current.stage.calcTransform(graphics);
		
		//trace("renderList.length = " + renderList.length);
	}
	
	public function add(display:IDisplay) 
	{
		if (!renderMap.exists(display)) {
			renderMap.set(display, true);
			renderList.push(display);
		}
	}
	
	/*public function remove(display:IDisplay) 
	{
		if (renderMap.exists(display)) {
			renderMap.remove(display);
			var i:Int = renderList.length-1;
			while (i >= 0) 
			{
				if (renderList[i] == display) {
					renderList.splice(i, 1);
					return;
				}
				i--;
			}
			
		}
	}*/
}