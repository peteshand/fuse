package fuse.core.backend.layerCache;

import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.core.backend.layerCache.groups.LayerGroups;
import fuse.core.backend.layerCache.groups.StaticLayerGroup;
import fuse.core.front.layers.LayerCacheBuffers;
import fuse.pool.Pool;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreDisplayObject.StaticDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class LayerCaches
{
	public static var OBJECT_COUNT:Int = 0;
	
	var layerGroups:LayerGroups;
	
	public var allLayerGroups(get, null):GcoArray<LayerGroup>;
	public var movingLayerGroups(get, null):GcoArray<LayerGroup>;
	public var drawToStaticLayerGroups(get, null):GcoArray<LayerGroup>;
	//public var alreadyAddedLayerGroups(get, null):GcoArray<LayerGroup>;
	
	//public var staticLayerGroups(get, null):GcoArray<LayerGroup>;
	//public var nonStaticLayerGroups(get, null):GcoArray<LayerGroup>;
	
	var currentStaticGroup:StaticLayerGroup;
	var change(get, null):Bool;
	
	//public var currentIsStatic = new Notifier<Null<Int>>();
	//public var groups = new GcoArray<StaticLayerGroup>([]);
	public var activeGroups:Array<LayerCache> = [];
	//public var minGroupSize:Int = 0;
	
	//public var indexOffset:Int = 6;
	public var maxLayers:Int = 2;
	public var currentIndex:Int = 0;
	
	public function new() 
	{
		for (i in 0...maxLayers) 
		{
			var layerCache:LayerCache = new LayerCache(LayerCacheBuffers.startIndex + i);
			layerCache.index = i;
			activeGroups.push(layerCache);
		}
		layerGroups = new LayerGroups(activeGroups, maxLayers);
	}
	
	public inline function begin():Void
	{
		layerGroups.begin();
	}
	
	public inline function build(coreDisplay:CoreDisplayObject) 
	{
		layerGroups.build(coreDisplay);
	}
	
	public inline function end():Void
	{
		layerGroups.end();
		currentIndex = 0;
	}
	
	public function checkRenderTarget(staticDef:StaticDef) 
	{
		if (currentIndex < activeGroups.length && activeGroups[currentIndex].active) {
			if (LayerCaches.OBJECT_COUNT < activeGroups[currentIndex].start) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = LayerGroupState.MOVING;
				staticDef.index = -1;
			}
			else if (LayerCaches.OBJECT_COUNT > activeGroups[currentIndex].end) {
				staticDef.layerCacheRenderTarget = -1;
				staticDef.state = LayerGroupState.MOVING;
				staticDef.index = -1;
				currentIndex++;
			}
			else {
				staticDef.layerCacheRenderTarget = activeGroups[currentIndex].textureId;
				staticDef.state = activeGroups[currentIndex].state.value;
				staticDef.index = currentIndex;
				LayerCaches.OBJECT_COUNT++;
				return activeGroups[currentIndex];
			}
		}
		else {
			staticDef.layerCacheRenderTarget = -1;
			staticDef.state = LayerGroupState.MOVING;
			staticDef.index = -1;
		}
		LayerCaches.OBJECT_COUNT++;
		return null;
	}
	
	function get_allLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.allLayerGroups;
	}
	
	function get_movingLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.movingLayerGroups;
	}
	
	function get_drawToStaticLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.drawToStaticLayerGroups;
	}
	
	/*function get_alreadyAddedLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.alreadyAddedLayerGroups;
	}*/
	
	function get_change():Bool 
	{
		return layerGroups.change;
	}
}