package kea2.worker.thread.layerCache;
import kea2.worker.thread.layerCache.groups.LayerGroup;
import kea2.worker.thread.layerCache.groups.LayerGroup.LayerGroupState;
import kea2.worker.thread.layerCache.groups.LayerGroups;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.pool.Pool;
import kea2.utils.GcoArray;
import kea2.utils.Notifier;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplay.StaticDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class LayerCaches
{
	var layerGroups:LayerGroups;
	
	public var allLayerGroups(get, null):GcoArray<LayerGroup>;
	//public var staticLayerGroups(get, null):GcoArray<LayerGroup>;
	//public var nonStaticLayerGroups(get, null):GcoArray<LayerGroup>;
	
	var currentStaticGroup:StaticLayerGroup;
	var change(get, null):Bool;
	
	//public var currentIsStatic = new Notifier<Null<Int>>();
	//public var groups = new GcoArray<StaticLayerGroup>([]);
	public var activeGroups:Array<LayerCache> = [];
	//public var minGroupSize:Int = 0;
	
	public var indexOffset:Int = 6;
	public var maxLayers:Int = 2;
	public var currentIndex:Int = 0;
	
	public function new() 
	{
		for (i in 0...maxLayers) 
		{
			var layerCache:LayerCache = new LayerCache(indexOffset + i);
			layerCache.index = i;
			activeGroups.push(layerCache);
		}
		layerGroups = new LayerGroups(activeGroups, maxLayers);
	}
	
	public inline function begin():Void
	{
		layerGroups.begin();
	}
	
	public inline function build(workerDisplay:WorkerDisplay) 
	{
		layerGroups.build(workerDisplay);
	}
	
	public inline function end():Void
	{
		layerGroups.end();
		currentIndex = 0;
	}
	
	public function checkRenderTarget(staticDef:StaticDef) 
	{
		if (currentIndex < activeGroups.length && activeGroups[currentIndex].active) {
			if (VertexData.OBJECT_POSITION < activeGroups[currentIndex].start) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = LayerGroupState.MOVING;
				staticDef.index = -1;
			}
			else if (VertexData.OBJECT_POSITION > activeGroups[currentIndex].end) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = LayerGroupState.MOVING;
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
			staticDef.state = LayerGroupState.MOVING;
			staticDef.index = -1;
		}
		VertexData.OBJECT_POSITION++;
		return null;
	}
	
	function get_allLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.allLayerGroups;
	}
	
	function get_change():Bool 
	{
		return layerGroups.change;
	}
}