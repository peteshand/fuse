package kea.logic.layerConstruct;

import kea2.Kea;
import kea.logic.displaylist.DisplayList;
import kea.logic.renderer.Renderer;
import kea2.display.containers.IDisplay;
import kea2.utils.Notifier;
import kea2.display.containers.DisplayObject;

class LayerConstruct
{	
	var layerOrders = new LayerOrders();
	var layers:Array<LayerDefinition>;
	
	public function new() { }
	
	@:access(kea.logic.renderer.Renderer)
	public function update():Void
	{
		if (Kea.current.model.keaConfig.useCacheLayers == true) {
			
			var pre:Bool = Renderer.layerStateChangeAvailable;
			
			checkStatic();
			
			if (Renderer.layerStateChangeAvailable) {
				
				//trace("pre                                = " + pre);
				//trace("Renderer.layerStateChangeAvailable = " + Renderer.layerStateChangeAvailable);
				
				//var orderedList:Array<IDisplay> = orderLayers(Kea.current.updateList.renderList);
				orderLayers(Kea.current.logic.displayList);
				//trace("Renderer.layerStateChangeAvailable = " + Renderer.layerStateChangeAvailable);
				layers = layerOrders.findOrder(Kea.current.logic.displayList.renderList);
				
				/*for (i in 0...layers.length) 
				{
					if (layers[i].isStatic) {
						Kea.current.updateList.renderList[layers[i].startIndex].nextNonStaticIndex;
					}
				}*/
				//trace("layerDefinitions.length = " + layers.length);
			}
			
			Kea.current.logic.renderer.layers = layers;
		}
		else {
			var directLayer:LayerDefinition = {
				index:0,
				isStatic:false,
				startIndex:0,
				endIndex:Kea.current.logic.displayList.renderList.length,
				length:Kea.current.logic.displayList.renderList.length
			}
			Kea.current.logic.renderer.layers = [directLayer];
		}
	}
	
	function orderLayers(displayList:DisplayList) 
	{
		displayList.layerIndices.sort(function(l1:Int, l2:Int):Int
		{
			if (l1 > l2) return 1;
			if (l1 < l2) return -1;
			else return 0;
		});
		
		var maxLayer:Int = 0;
		var orderedList:Array<IDisplay> = [];
		for (j in 0...displayList.layerIndices.length) 
		{
			
			for (i in 0...displayList.renderList.length) 
			{
				if (displayList.renderList[i].layerIndex == j) {
					//trace([displayList.renderList[i], displayList.renderList[i].layerIndex]);
					orderedList.push(displayList.renderList[i]);
				}
			}
			
		}
		displayList.renderList = orderedList;
	}
	
	function checkStatic() 
	{
		for (i in 0...Kea.current.logic.displayList.renderList.length) 
		{
			Kea.current.logic.displayList.renderList[i].checkStatic();
			//trace([i, Kea.current.logic.displayList.renderList[i].isStatic]);
		}
	}
}

@:access(kea.logic.renderer.Renderer)
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
			currentLayerDefinition = { index:layerDefinitions.length, startIndex:renderIndex, isStatic:changeAvailable.value };
		}
	}
	
	function CloseLayer(offset:Int = 0) 
	{
		if (currentLayerDefinition.isStatic) { // only push static 
			currentLayerDefinition.endIndex = renderIndex + offset;
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
	
	@:access(kea2.utils.Notifier)
	@:access(kea2.display.containers.DisplayObject)
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
				//changeAvailable.value = renderList[i].isStatic2.value;
				renderList[i].isStatic = 1;
				renderList[i].layerDefinition = currentLayerDefinition;
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
			CloseLayer(1);
		}
		
		optimize();
		
		return layerDefinitions;
	}
	
	function optimize() 
	{
		if (layerDefinitions.length == 0) {
			layerDefinitions = [ { index:0, startIndex:startIndex, endIndex:endIndex, isStatic:false } ];
			return;
		}
		
		/*trace("///////////////////////");
		for (i in 0...layerDefinitions.length) 
		{
			trace([layerDefinitions[i].index, layerDefinitions[i].length, layerDefinitions[i].startIndex, layerDefinitions[i].endIndex, layerDefinitions[i].isStatic]);
		}
		layerDefinitions.sort(function(l1:LayerDefinition, l2:LayerDefinition):Int
		{
			if (l1.length > l2.length) return 1;
			if (l1.length < l2.length) return -1;
			else return 0;
		});
		trace("||||||||||||||||||||");
		for (i in 0...layerDefinitions.length) 
		{
			trace([layerDefinitions[i].index, layerDefinitions[i].length, layerDefinitions[i].startIndex, layerDefinitions[i].endIndex, layerDefinitions[i].isStatic]);
		}
		trace("-----------");
		return;*/
		
		/*trace("///////////////////////");
		for (i in 0...layerDefinitions.length) 
		{
			trace([layerDefinitions[i].index, layerDefinitions[i].length, layerDefinitions[i].startIndex, layerDefinitions[i].endIndex, layerDefinitions[i].isStatic]);
		}*/
		
		
		var topLayers:Array<LayerDefinition> = [];
		if (layerDefinitions[0].startIndex != 0) {
			topLayers.push( { index:0, startIndex:0, endIndex:layerDefinitions[0].startIndex, length:layerDefinitions[0].startIndex, isStatic:false } );
		}
		for (i in 0...layerDefinitions.length) 
		{
			layerDefinitions[i].index = topLayers.length;
			topLayers.push( layerDefinitions[i] );
			
			var _endIndex:Int = endIndex;
			if (i < layerDefinitions.length - 1) _endIndex = layerDefinitions[i + 1].startIndex;
			if (layerDefinitions[i].endIndex != _endIndex){
				topLayers.push( { index:topLayers.length, startIndex:layerDefinitions[i].endIndex, endIndex:_endIndex, length:_endIndex-layerDefinitions[i].endIndex, isStatic:false } );
			}
		}
		
		
		layerDefinitions = topLayers;
		/*trace("||||||||||||||||||||");
		for (i in 0...layerDefinitions.length) 
		{
			trace([layerDefinitions[i].index, layerDefinitions[i].length, layerDefinitions[i].startIndex, layerDefinitions[i].endIndex, layerDefinitions[i].isStatic]);
		}
		trace("-----------");*/
		return;
		
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
			
			if (topLayers.length == 1 && len == 1 && topLayers[0].endIndex == endIndex) {
				// All Static
			}
			else {
				while (j < len) 
				{
					if (j < len - 1) {
						dunamicEnd = layerDefinitions[j+1].startIndex;
						topLayers.push(layerDefinitions[j]);
						dynamicStart = layerDefinitions[j].endIndex;
					}
					else dunamicEnd = endIndex;
					
					topLayers.push({ index:topLayers.length, startIndex:dynamicStart, endIndex:dunamicEnd, isStatic:false });
					
					j++;
				}
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
	index:Int,
	isStatic:Bool,
	startIndex:Int,
	?endIndex:Int,
	?length:Int,
	?top:Bool
	//displays:Array<IDisplay>,
}