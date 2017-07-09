package kea2.worker.thread.layerCache;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.pool.Pool;
import kea2.utils.GcoArray;
import kea2.utils.Notifier;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplay.StaticDef;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup.StaticGroupState;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class LayerCaches
{
	var currentStaticGroup:StaticLayerGroup;
	var change:Bool;
	
	public var currentIsStatic = new Notifier<Null<Int>>();
	public var groups = new GcoArray<StaticLayerGroup>([]);
	public var activeGroups:Array<LayerCache> = [];
	public var minGroupSize:Int = 0;
	
	public var indexOffset:Int = 6;
	public var maxLayers:Int = 2;
	public var currentIndex:Int = 0;
	
	public function new() 
	{
		for (i in 0...maxLayers) 
		{
			var layerCache:LayerCache = new LayerCache(indexOffset + i);
			layerCache.index = i;
			layerCache.state.add(OnStateChange);
			activeGroups.push(layerCache);
		}
		currentIsStatic.add(OnIsStaticChange);
	}
	
	function OnStateChange() 
	{
		//change = true;
	}
	
	public function begin():Void
	{
		currentIsStatic.value = 0;
		groups.clear();
	}
	
	function OnIsStaticChange():Void
	{
		closeGroup();
		
		if (currentIsStatic.value == 1) {
			currentStaticGroup = Pool.staticLayerGroup.request();
			currentStaticGroup.start = VertexData.OBJECT_POSITION;
			currentStaticGroup.index = groups.length;
			
		}
	}
	
	function closeGroup() 
	{
		if (currentStaticGroup != null){
			currentStaticGroup.end = VertexData.OBJECT_POSITION - 1;
			if (currentStaticGroup.length >= minGroupSize){
				groups.push(currentStaticGroup);
			}
			else {
				Pool.staticLayerGroup.release(currentStaticGroup);
			}
			currentStaticGroup = null;
		}
	}
	
	public function end():Void
	{
		if (currentIsStatic.value == 1) {
			closeGroup();
		}
		
		for (i in 0...groups.length) 
		{
			Pool.staticLayerGroup.release(groups[i]);
		}
		
		if (groups.length > 0){
			BubbleSort.sortLength(groups);
			if (groups.length > maxLayers) {
				groups.length = maxLayers;
			}
			BubbleSort.sortIndex(groups);
		}
		
		change = false;
		for (j in 0...maxLayers) 
		{
			if (j < groups.length) {
				activeGroups[j].active = true;
				if (activeGroups[j].start == groups[j].start) {
					if (activeGroups[j].end == groups[j].end) {
						activeGroups[j].state.value = StaticGroupState.ALREADY_ADDED;
					}
					else {
						//activeGroups[j].state.value = StaticGroupState.ADD_TO_LAYER;
						activeGroups[j].state.value = StaticGroupState.DRAW_TO_LAYER;
						change = true;
					}
				}
				else {
					activeGroups[j].state.value = StaticGroupState.DRAW_TO_LAYER;
					change = true;
				}
				
				activeGroups[j].start = groups[j].start;
				activeGroups[j].end = groups[j].end;
				//trace("Static Group: " + activeGroups[j]);
			}
			else {
				//activeGroups[j].state.value = StaticGroupState.NO_CHANGE;
				activeGroups[j].active = false;
			}
		}
		
		//trace("change = " + change);
		if (change) {
			WorkerCore.textureBuildRequiredCount = 0;
			//WorkerCore.
		}
		
		currentIndex = 0;
	}
	
	public function checkRenderTarget(staticDef:StaticDef) 
	{
		if (currentIndex < activeGroups.length && activeGroups[currentIndex].active) {
			if (VertexData.OBJECT_POSITION < activeGroups[currentIndex].start) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = StaticGroupState.MOVING;
				staticDef.index = -1;
			}
			else if (VertexData.OBJECT_POSITION > activeGroups[currentIndex].end) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = StaticGroupState.MOVING;
				staticDef.index = -1;
				currentIndex++;
			}
			else {
				staticDef.layerCacheRenderTarget = activeGroups[currentIndex].textureId;
				staticDef.state = activeGroups[currentIndex].state.value;
				staticDef.index = currentIndex;
				VertexData.OBJECT_POSITION++;
				return activeGroups[currentIndex];
			}
		}
		else {
			staticDef.layerCacheRenderTarget = -1;
			staticDef.state = StaticGroupState.MOVING;
			staticDef.index = -1;
		}
		VertexData.OBJECT_POSITION++;
		return null;
	}
}


class BubbleSort
{
	public static function sortLength(groups:GcoArray<StaticLayerGroup>):Void
	{
		var swapping = false;
		var temp:StaticLayerGroup;
		while (!swapping) {
			swapping = true;
			for (i in 0...groups.length-1) {
				if (groups[i].length < groups[i+1].length) {
					temp = groups[i+1];
					groups[i+1] = groups[i];
					groups[i] = temp;
					swapping = false;
				}
			}
		}
	}
	
	public static function sortIndex(groups:GcoArray<StaticLayerGroup>):Void
	{
		var swapping = false;
		var temp:StaticLayerGroup;
		while (!swapping) {
			swapping = true;
			for (i in 0...groups.length-1) {
				if (groups[i].index > groups[i+1].index) {
					temp = groups[i+1];
					groups[i+1] = groups[i];
					groups[i] = temp;
					swapping = false;
				}
			}
		}
	}
}