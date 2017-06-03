package kea.util;

import kea2.display.containers.IDisplay;
import kea.notify.Notifier;
import kea.render.layers.ILayerBuffer;

class RenderUtils
{
	//public static var changeIndices:Array<Int> = [];
	public static var changedDisplays:Array<IDisplay> = [];

	static var count:Int = 0;
	static var layerCount:Int = 0;
	static var layerbuffers:Array<ILayerBuffer>;
	
	static var onChange = new Notifier<Null<Bool>>(null);
	static var layerValues:Array<LayerValue>;
	static var currentLayerValue:LayerValue;
	
	public function new() {
		
	}

	public static function __init__():Void
	{
		
	}
	
	public static function addToChangeList(display:IDisplay):Void
	{
		changedDisplays.push(display);
	}

	static function onValuechange():Void
	{
		if (currentLayerValue != null){
			if (currentLayerValue.startIndex != count){
				currentLayerValue = new LayerValue(count);
				layerValues.push(currentLayerValue);
			}
		}
		else {
			currentLayerValue = new LayerValue(count);
			layerValues.push(currentLayerValue);
		}
		
		currentLayerValue.startIndex = count;
		currentLayerValue.changeAvailable = onChange.value;
		
	}

	public static function calculateIndices(root:IDisplay, _layerbuffers:Array<ILayerBuffer>):Void
	{
		//trace("changedDisplays.length = " + changedDisplays.length);
		if (changedDisplays.length == 0){
			return;
		}

		layerbuffers = _layerbuffers;

		//trace("changedDisplays.length = " + changedDisplays.length);
		//trace("changedDisplays.length = " + changedDisplays.length);

		changedDisplays.sort(function(d1:IDisplay, d2:IDisplay):Int
		{
			if (d1.renderIndex > d2.renderIndex) return 1;
			else if (d1.renderIndex < d2.renderIndex) return -1;
			else return 0;
		});
		
		/*for (i in 0...changedDisplays.length){
			trace("changedDisplays[" + i + "].renderIndex = " + changedDisplays[i].renderIndex + " name = " + changedDisplays[i].name);
		}*/

		currentLayerValue = null;
		layerValues = [];
		onChange.remove(onValuechange);
		onChange.value = null;
		onChange.add(onValuechange);
		count = 0;

		if (root.stage.layerRenderer.renderList[0].staticCount.value == 0){
			onChange.value = true;
		}
		else {
			onChange.value = false;
		}
		//onChange.value = root.stage.layerRenderer.renderList[0].transformAvailable.value;

		for (m in 0...changedDisplays.length)
		{
			count = changedDisplays[m].renderIndex;
			onChange.value = true;
			
			if (m < changedDisplays.length-1){
				if (changedDisplays[m+1].renderIndex != count+1){
					onChange.value = false;
					count++;
				}
			}
		}

		var lastRenderIndex:Int = changedDisplays[changedDisplays.length-1].renderIndex;
		//trace("lastRenderIndex = " + lastRenderIndex);
		var nextRenderIndex:Int = lastRenderIndex + 1;
		if (nextRenderIndex < root.stage.layerRenderer.renderList.length){
			nextRenderIndex = root.stage.layerRenderer.renderList.length-1;
		
			count = nextRenderIndex;
			
			if (root.stage.layerRenderer.renderList[nextRenderIndex].staticCount.value == 0){
				onChange.value = true;
			}
			else {
				onChange.value = false;
			}
			//onChange.value = root.stage.layerRenderer.renderList[nextRenderIndex].transformAvailable.value;
		}
		
		var h:Int = layerValues.length-1;
		layerValues[h].endIndex = root.stage.layerRenderer.renderList.length-1;
		//trace("layerValues[h].endIndex = " + layerValues[h].endIndex);
		//trace("layerValues[h].index    = " + layerValues[h].index);
		h--;

		while (h >= 0){
			layerValues[h].endIndex = layerValues[h+1].startIndex - 1;
			//trace("layerValues[h].endIndex = " + layerValues[h].endIndex);
			//trace("layerValues[h].index    = " + layerValues[h].index);
			
			h--;
		}

		if (layerValues[0].changeAvailable == false){
			var layerValue:LayerValue = new LayerValue(0);
			layerValue.changeAvailable = true;
			layerValue.startIndex = -1;
			layerValue.endIndex = -1;
			layerValues.unshift(layerValue);
		}

		for (i in 0...layerValues.length){
			//trace("layerValues[i].index, layerValues[i].length");
			//trace([layerValues[i].index, layerValues[i].length]);
			if (layerValues[i].changeAvailable == true){
				layerbuffers[i].staticCount = 1;
			}
			else {
				layerbuffers[i].staticCount = 0;
			}
			
			layerbuffers[i].startIndex.value = layerValues[i].startIndex;
			layerbuffers[i].endIndex.value = layerValues[i].endIndex;
			
			/*var a:Array<Dynamic> = [
				layerValues[i].startIndex,
				layerValues[i].endIndex,
				layerbuffers[i].staticCount
			];
			trace(a);*/
		}
		//trace("---");
		
		for (m in layerValues.length...layerbuffers.length){
			//trace(m);
			layerbuffers[m].reset();
			layerbuffers[m].startIndex.value = null;
			layerbuffers[m].endIndex.value = null;
			
		}

		changedDisplays = [];
	}
}

class LayerValue
{
	public var index:Int;
	public var startIndex:Null<Int>;
	public var endIndex:Null<Int>;
	public var changeAvailable:Null<Bool>;
	public var length(get, null):Int;
	
	public function new(index:Int)
	{
		this.index = index;
	}

	public function get_length():Int
	{
		trace("startIndex = " + startIndex);
		trace("endIndex = " + endIndex);
		
		return endIndex - startIndex;
	}
}