package kea.core.render.layers;

import kea.display.IDisplay;
import kea.notify.Notifier;

class LayerDef
{	
	var layerOrders = new LayerOrders();
	var changedDisplaysMap = new Map<IDisplay, IDisplay>();
	var changedDisplays:Array<IDisplay> = [];
	var lastChangedDisplays:Array<IDisplay> = [];
	
	public function new() {
		
	}

	public function add(display:IDisplay):Void
	{
		changedDisplaysMap.set(display, display);
		return;

		/*for (i in 0...changedDisplays.length){
			//trace([changedDisplays[i].name, display.name]);
			if (changedDisplays[i] == display){
				return;
			}
		}
		//trace("renderIndex = " + display.renderIndex);
		changedDisplays.push(display);*/
	}

	public function calc():Array<LayerDefinition>
	{
		changedDisplays.splice(0, changedDisplays.length);
		for (display in changedDisplaysMap.iterator()){
			changedDisplays.push(display);
			//trace(display.name);
		}
		//trace(changedDisplays.length);
		changedDisplaysMap = new Map<IDisplay, IDisplay>();

		orderArray();
		
		var layerDefinitions:Array<LayerDefinition> = layerOrders.findOrder(changedDisplays);
		
		reset();
		
		return layerDefinitions;
	}

	public function orderArray():Void
	{
		var arrayHasChanged:Bool = checkForChange();
		if (!arrayHasChanged) {
			changedDisplays = lastChangedDisplays.copy();
			return;
		}

		changedDisplays.sort(function(d1:IDisplay, d2:IDisplay):Int
		{
			if (d1.renderIndex > d2.renderIndex) return 1;
			else if (d1.renderIndex < d2.renderIndex) return -1;
			else return 0;
		});

		lastChangedDisplays.splice(0, lastChangedDisplays.length);
		for (i in 0...changedDisplays.length){
			//trace(changedDisplays[i].name);
			lastChangedDisplays.push(changedDisplays[i]);
		}
	}

	function checkForChange():Bool
	{
		if (lastChangedDisplays.length == changedDisplays.length) {
			return false;
		}
		if (changedDisplays.length == 0) {
			return true;
		}
		if (lastChangedDisplays.length > 0) {
			if (changedDisplays[0] != lastChangedDisplays[0]) {
				return true;
			}
		}
		
		var matchFound:Bool;
		var matchCount:Int = 0;
		
		

		for (i in 0...changedDisplays.length){
			matchFound = false;
			for (j in 0...lastChangedDisplays.length){
				if (changedDisplays[i] == lastChangedDisplays[j]){
					matchFound = true;
					break;
				}
			}
			if (matchFound){
				matchCount++;
			}
		}
		if (matchCount == changedDisplays.length) {
			//trace("nothing has changed");
			return false;
		}
		
		//trace("sort");
		return true;
	}

	function reset():Void
	{
		var renderList:Array<IDisplay> = Kea.current.updateList.renderList;
		if (renderList.length > 0){
			renderList[0].staticCount.value++;
			//trace("renderList[0] = " + renderList[0].staticCount.value);
		}

		for (i in 0...changedDisplays.length){
			changedDisplays[i].staticCount.value ++;
		}

		changedDisplays.splice(0, changedDisplays.length);
	}
}

class LayerOrders
{
	var currentDisplay:IDisplay;
	var renderIndex:Int = 0;
	var changeAvailable = new Notifier<Null<Bool>>();
	var layerDefinitions:Array<LayerDefinition> = [];

	public function new()
	{
		changeAvailable.add(onChangeAvailableChange);
	}

	public function findOrder(changedDisplays:Array<IDisplay>):Array<LayerDefinition>
	{
		layerDefinitions = [];
		
		//if (changedDisplays.length == 0) return layerDefinitions;
		
		findStartIndex(changedDisplays);
		findEndActiveIndex();
		findLastEndActiveIndex();
		findLastIndex();
		findDisplays();
		
		return layerDefinitions;
	}
	@:access(kea.notify.Notifier)
	inline function findStartIndex(changedDisplays:Array<IDisplay>):Void
	{
		//trace("changedDisplays.length = " + changedDisplays.length);
		renderIndex = 0;
		currentDisplay = changedDisplays[0];
		//changeAvailable.remove(onChangeAvailableChange);
		changeAvailable._value = null;
		//changeAvailable.add(onChangeAvailableChange);
		
		changeAvailable.value = true;
		
		for (i in 0...changedDisplays.length){
			currentDisplay = changedDisplays[i];
			renderIndex = changedDisplays[i].renderIndex;
			//trace("staticCount = " + changedDisplays[i].staticCount.value);
			//trace("name = " + changedDisplays[i].name);
			//trace("renderIndex = " + changedDisplays[i].renderIndex);
			
			if (changedDisplays[i].staticCount.value == 0){
				// Direct Renderer
				changeAvailable.value = false;
			}
			else {
				// Cache Renderer
					// Render Into Cache
					// Render From Cache
				changeAvailable.value = true;
			}
			
		}
	}
	
	inline function findEndActiveIndex():Void
	{
		if (layerDefinitions.length == 0) return;
		for (i in 0...layerDefinitions.length-1){
			layerDefinitions[i].endIndex = layerDefinitions[i+1].startIndex - 1;
		}
	}
	
	inline function findLastEndActiveIndex():Void
	{
		
		var lastDef = layerDefinitions[layerDefinitions.length-1];
		for (i in lastDef.startIndex...Kea.current.updateList.renderList.length){
			if (Kea.current.updateList.renderList[i].staticCount.value <= 0){
				lastDef.endIndex = i;
			}
		}
	}
	
	inline function findLastIndex():Void
	{
		var lastDef = layerDefinitions[layerDefinitions.length-1];
		if (lastDef.endIndex != Kea.current.updateList.renderList.length-1){
			layerDefinitions.push({startIndex:lastDef.endIndex + 1, endIndex:Kea.current.updateList.renderList.length-1 ,isStatic:true});
		}
	}
	
	inline function findDisplays():Void
	{
		for (i in 0...layerDefinitions.length){
			var layerDefinition:LayerDefinition = layerDefinitions[i];
			layerDefinition.displays = [];
			for (j in layerDefinition.startIndex...layerDefinition.endIndex+1){
				layerDefinition.displays.push(Kea.current.updateList.renderList[j]);
			}
		}
	}
	
	function onChangeAvailableChange():Void
	{
		for (i in 0...layerDefinitions.length){
			if (layerDefinitions[i].startIndex == renderIndex){
				layerDefinitions[i].isStatic = changeAvailable.value;
				return;
			}
		}
		layerDefinitions.push({startIndex:renderIndex, isStatic:changeAvailable.value});
	}
}

typedef LayerDefinition =
{
	isStatic:Bool,
	startIndex:Int,
	?endIndex:Int,
	?displays:Array<IDisplay>,
}