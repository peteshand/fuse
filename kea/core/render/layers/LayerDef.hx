package kea.core.render.layers;

import kea.display.IDisplay;
import kea.notify.Notifier;

class LayerDef
{	
	var layerOrders = new LayerOrders();
	var currentLayers:Array<LayerDefinition>;
	
	public function new() { }
	
	@:access(kea.core.render.Renderer)
	public function calc():Array<LayerDefinition>
	{
		checkStatic();
		if (Renderer.layerStateChangeAvailable) {
			//trace("Renderer.layerStateChangeAvailable = " + Renderer.layerStateChangeAvailable);
			currentLayers = layerOrders.findOrder(Kea.current.updateList.renderList);
			//trace("layerDefinitions.length = " + currentLayers.length);
			Renderer.layerStateChangeAvailable = false;	
		}
		
		return currentLayers;
	}
	
	function checkStatic() 
	{
		for (i in 0...Kea.current.updateList.renderList.length) 
		{
			Kea.current.updateList.renderList[i].checkStatic();
		}
	}
}

@:access(kea.core.render.Renderer)
class LayerOrders
{
	var renderIndex:Int = 0;
	var layerDefinitions:Array<LayerDefinition> = [];
	var topLayers:Array<LayerDefinition> = [];
	var currentLayerDefinition:LayerDefinition;
	var changeAvailable = new Notifier<Null<Bool>>();
	var startIndex:Int;
	var endIndex:Int;
	var max:Int;
	
	public function new()
	{
		max = Renderer.maxLayers - 1;
		changeAvailable.add(onChangeAvailable);
	}
	
	function onChangeAvailable():Void
	{
		// close current
		if (currentLayerDefinition != null) CloseLayer();
		
		// start new
		if (changeAvailable.value) {
			currentLayerDefinition = { startIndex:renderIndex, isStatic:changeAvailable.value };
		}
	}
	
	function CloseLayer() 
	{
		if (currentLayerDefinition.isStatic) { // only push static 
			currentLayerDefinition.endIndex = renderIndex;
			currentLayerDefinition.length = currentLayerDefinition.endIndex - currentLayerDefinition.startIndex;
			addTop();
		}
		currentLayerDefinition = null;
	}
	
	function addTop()
    {
		if (layerDefinitions.length < max) {
			layerDefinitions.push(currentLayerDefinition);
			return;
		}
		
		var dif:Int = 0;
		var index:Int = -1;
		for (j in 0...layerDefinitions.length) 
		{
			if (currentLayerDefinition.length - layerDefinitions[j].length > dif) {
				dif = currentLayerDefinition.length - layerDefinitions[j].length;
				index = j;
				//trace("dif = " + dif);
				
			}
		}
		if (index != -1) {
			layerDefinitions.splice(index, 1);
			layerDefinitions.push(currentLayerDefinition);
			//return;
		}
    }
	
	@:access(kea.notify.Notifier)
	@:access(kea.display.DisplayObject)
	public function findOrder(renderList:Array<IDisplay>):Array<LayerDefinition>
	{
		startIndex = 0;// renderList[0].renderIndex;
		endIndex = renderList.length;// renderList[renderList.length - 1].renderIndex;
		
		layerDefinitions = [];
		currentLayerDefinition = null;
		changeAvailable._value = null;
		
		for (i in 0...renderList.length) 
		{
			//if (renderList[i].renderable){
				renderIndex = i;
				//trace(i + " name = " + renderList[i].name);
				//trace("renderList[" + i + "].isStatic2.value = " + renderList[i].isStatic2.value);
				changeAvailable.value = renderList[i].isStatic2.value;
				renderList[i].isStatic = true;
				/*if (renderList[i].staticCount.value <= 0) {
					changeAvailable.value = false;
				}
				else {
					changeAvailable.value = true;
				}*/
			//}
		}
		
		// close last layer
		if (currentLayerDefinition != null) {
			CloseLayer();
		}
		
		optimize();
		
		return layerDefinitions;
	}
	
	function optimize() 
	{
		if (layerDefinitions.length == 0) {
			layerDefinitions = [ { startIndex:startIndex, endIndex:endIndex, isStatic:false } ];
			return;
		}
		
		var topLayers:Array<LayerDefinition> = [];// layerDefinitions.concat([]);
		
		var dynamicStart:Null<Int>;
		var dunamicEnd:Null<Int>;
		//var firstStaticLayer:LayerDefinition = topLayers[0];
		
		// Starts with static layer
		//if (firstStaticLayer != null && firstStaticLayer.startIndex == startIndex) {
			//trace("dgdsfgfd");
			//dynamicStart = firstStaticLayer.endIndex;
			////dunamicEnd = topLayers[0].endIndex;
			//var j:Int = 0;
			//var len:Int = layerDefinitions.length;
			//while (j < len) 
			//{
				//if (j < len - 1) dunamicEnd = layerDefinitions[j+1].startIndex;
				//else dunamicEnd = endIndex;
				//
				//var layerDefinition = { /*index:0,*/ startIndex:dynamicStart, endIndex:dunamicEnd, isStatic:false };
				//topLayers.insert((j * 2) + 1, layerDefinition);
				//dynamicStart = layerDefinitions[j].endIndex;
				//j++;
			//}
		//}
		//else { // Starts with non-static layer
			
			
			var j:Int = 0;
			var len:Int = layerDefinitions.length;
			if (layerDefinitions[0].startIndex == startIndex) {
				topLayers.push(layerDefinitions[0]);
				dynamicStart = layerDefinitions[0].endIndex;
			}
			else {
				dynamicStart = startIndex;
			}
			
			while (j < len) 
			{
				if (j < len - 1) {
					dunamicEnd = layerDefinitions[j+1].startIndex;
					topLayers.push(layerDefinitions[j]);
					dynamicStart = layerDefinitions[j].endIndex;
				}
				else dunamicEnd = endIndex;
				
				topLayers.push({ startIndex:dynamicStart, endIndex:dunamicEnd, isStatic:false });
				
				j++;
			}
			
		//}
		
		layerDefinitions = topLayers;
	}
	
	
	/*function findTopX(output:Array<LayerDefinition>, sortArray:Array<LayerDefinition>, findTopNum:Int, findStart = 0)
    {
        if (sortArray.length > findStart) {
            // count the number of element that larger 
            // than the element at start position
            var count:Int = 0;     
            for (i in (findStart + 1)...sortArray.length) {
				if (sortArray[findStart].length < sortArray[i].length) count++;
            }
            // if there are more than [findTopNum] number of element
            // that is larger than this element
            // it cannot be in the [findTopNum] largest number
            if (count >= findTopNum) {
                sortArray[findStart].top = false;
            } else {
                sortArray[findStart].top = true;
				output.push(sortArray[findStart]);
                findTopNum -= 1;
            }
            // continue to next element
            findTopX(output, sortArray, findTopNum, findStart + 1);
        }
		
		return output;
    }*/
	
}

typedef LayerDefinition =
{
	//index:Int,
	isStatic:Bool,
	startIndex:Int,
	?endIndex:Int,
	?length:Int,
	?top:Bool
	//displays:Array<IDisplay>,
}