package fuse.core.backend.layerCache.groups;

import fuse.core.communication.data.indices.IndicesData;
import fuse.core.backend.Core;
import fuse.core.backend.layerCache.LayerCache;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.utils.Notifier)
class LayerGroups
{
	static var OBJECT_POSITION:Int = 0;
	var currentLayerGroup:LayerGroup;
	public var currentIsStatic = new Notifier<Null<Int>>();
	
	public var allLayerGroups = new GcoArray<LayerGroup>([]);
	public var staticLayerGroups = new GcoArray<LayerGroup>([]);
	public var nonStaticLayerGroups = new GcoArray<LayerGroup>([]);
	
	public var movingLayerGroups = new GcoArray<LayerGroup>([]);
	public var drawToStaticLayerGroups = new GcoArray<LayerGroup>([]);
	//public var alreadyAddedLayerGroups = new GcoArray<LayerGroup>([]);
	
	//public var inactiveLayerGroups = new GcoArray<LayerGroup>([]);
	//public var activeLayerGroups = new GcoArray<LayerGroup>([]);
	
	public var activeGroups:Array<LayerCache> = [];
	
	public var minGroupSize:Int = 0;
	public var maxLayers:Int;
	public var change:Bool = true;
	
	public function new(activeGroups:Array<LayerCache>, maxLayers:Int) 
	{
		this.activeGroups = activeGroups;
		this.maxLayers = maxLayers;
		for (i in 0...activeGroups.length) 
		{
			activeGroups[i].state.add(OnStateChange);
		}
		currentIsStatic.add(OnIsStaticChange);
	}
	
	function OnStateChange() 
	{
		change = true;
	}
	
	public function begin() 
	{
		LayerGroups.OBJECT_POSITION = 0;
		//currentIsStatic.remove(OnIsStaticChange);
		currentIsStatic._value = -1;
		//currentIsStatic.add(OnIsStaticChange);
		allLayerGroups.clear();
		staticLayerGroups.clear();
		
		movingLayerGroups.clear();
		drawToStaticLayerGroups.clear();
		//alreadyAddedLayerGroups.clear();
		
		
	}
	
	public function build(coreDisplay:CoreDisplayObject) 
	{
		currentIsStatic.value = coreDisplay.isStatic;
		coreDisplay.layerGroup = currentLayerGroup;
		LayerGroups.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
	}
	
	function OnIsStaticChange():Void
	{
		closeGroup();
		
		currentLayerGroup = Pool.layerGroup.request();
		if (currentLayerGroup.start != LayerGroups.OBJECT_POSITION) {
			currentLayerGroup.state.value = null;
		}
		currentLayerGroup.start = LayerGroups.OBJECT_POSITION;
		currentLayerGroup.index = allLayerGroups.length;
		currentLayerGroup.staticIndex = staticLayerGroups.length;
		currentLayerGroup.isStatic = currentIsStatic.value;
	}
	
	function closeGroup() 
	{
		if (currentLayerGroup != null){
			if (currentLayerGroup.end != LayerGroups.OBJECT_POSITION - 1) {
				currentLayerGroup.state.value = null;
			}
			currentLayerGroup.end = LayerGroups.OBJECT_POSITION - 1;
			allLayerGroups.push(currentLayerGroup);
			
			if (currentLayerGroup.length >= minGroupSize && currentLayerGroup.isStatic == 1){
				staticLayerGroups.push(currentLayerGroup);
			}
			/*else {
				Pool.staticLayerGroup.release(currentLayerGroup);
			}*/
			currentLayerGroup = null;
		}
	}
	
	public function end() 
	{
		closeGroup();
		
		var i:Int = allLayerGroups.length - 1;
		while (i >= 0)
		{
			Pool.layerGroup.release(allLayerGroups[i]);
			i--;
		}
		
		if (staticLayerGroups.length > 0){
			SortLength(staticLayerGroups);
			if (staticLayerGroups.length > maxLayers) {
				staticLayerGroups.length = maxLayers;
			}
			SortIndex(staticLayerGroups);
		}
		
		if (staticLayerGroups.length > 0) {
			change = false;
		}
		
		for (j in 0...maxLayers) 
		{
			if (j < staticLayerGroups.length) {
				activeGroups[j].active = true;
				if (activeGroups[j].start != staticLayerGroups[j].start) {
					change = true;
				}
				if (activeGroups[j].end != staticLayerGroups[j].end) {
					change = true;
				}
				
				if (activeGroups[j].start == staticLayerGroups[j].start) {
					if (activeGroups[j].end == staticLayerGroups[j].end) {
						activeGroups[j].state.value = LayerGroupState.ALREADY_ADDED;
					}
					else {
						//activeGroups[j].state.value = LayerGroupState.ADD_TO_LAYER;
						activeGroups[j].state.value = LayerGroupState.DRAW_TO_LAYER;
						change = true;
					}
				}
				else {
					activeGroups[j].state.value = LayerGroupState.DRAW_TO_LAYER;
					change = true;
				}
				
				activeGroups[j].start = staticLayerGroups[j].start;
				activeGroups[j].end = staticLayerGroups[j].end;
				//trace("Static Group: " + activeGroups[j]);
			}
			else {
				//activeGroups[j].state.value = LayerGroupState.NO_CHANGE;
				activeGroups[j].active = false;
			}
		}
		
		for (b in 0...allLayerGroups.length) 
		{
			if (allLayerGroups[b].isStatic == 0) {
				allLayerGroups[b].state.value = LayerGroupState.MOVING;
				movingLayerGroups.push(allLayerGroups[b]);
			}
			else {
				if (allLayerGroups[b].state.value == LayerGroupState.DRAW_TO_LAYER || allLayerGroups[b].state.value == LayerGroupState.ALREADY_ADDED) {
					allLayerGroups[b].state.value = LayerGroupState.ALREADY_ADDED;
					//alreadyAddedLayerGroups.push(allLayerGroups[b]);
					movingLayerGroups.push(allLayerGroups[b]);
				}
				else {
					allLayerGroups[b].state.value = LayerGroupState.DRAW_TO_LAYER;
					drawToStaticLayerGroups.push(allLayerGroups[b]);
				}
			}
			//trace("allLayerGroups[" + b + "] = " + allLayerGroups[b]);
			/*allLayerGroups[b].staticDef.index = allLayerGroups[b].staticIndex;
			allLayerGroups[b].staticDef.layerCacheRenderTarget = allLayerGroups[b].textureId;
			allLayerGroups[b].staticDef.state = allLayerGroups[b].state.value;*/
			
		}
		
		/*for (k in 0...staticLayerGroups.length) 
		{
			trace("staticLayerGroups[" + k + "] = " + staticLayerGroups[k]);
		}*/
		
		
		
		//trace("change = " + change);
		if (change) {
			//Core.textureBuildRequiredCount = 0;
		}
	}
	
	
	///////////////////////////////////////////////////////////////////
	
	function SortLength(groups:GcoArray<LayerGroup>):Void
	{
		var swapping = false;
		var temp:LayerGroup;
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
	
	function SortIndex(groups:GcoArray<LayerGroup>):Void
	{
		var swapping = false;
		var temp:LayerGroup;
		while (!swapping) {
			swapping = true;
			for (i in 0...groups.length-1) {
				if (groups[i].staticIndex > groups[i+1].staticIndex) {
					temp = groups[i+1];
					groups[i+1] = groups[i];
					groups[i] = temp;
					swapping = false;
				}
			}
		}
	}
}