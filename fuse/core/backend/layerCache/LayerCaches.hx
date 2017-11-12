package fuse.core.backend.layerCache;

import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.core.backend.layerCache.groups.LayerGroups;
import fuse.core.backend.layerCache.groups.StaticLayerGroup;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.utils.Pool;
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
	static var layerGroups:LayerGroups;
	static var currentStaticGroup:StaticLayerGroup;
	static var change(get, null):Bool;
	
	public static var OBJECT_COUNT:Int;
	public static var allLayerGroups(get, null):GcoArray<LayerGroup>;
	public static var movingLayerGroups(get, null):GcoArray<LayerGroup>;
	public static var drawToStaticLayerGroups(get, null):GcoArray<LayerGroup>;
	public static var activeGroups:Array<LayerCache>;
	public static var maxLayers:Int;
	public static var currentIndex:Int;
	
	static public function __init__() 
	{
		OBJECT_COUNT = 0;
		activeGroups = [];
		maxLayers = 2;
		currentIndex = 0;
		
		for (i in 0...maxLayers) 
		{
			var layerCache:LayerCache = new LayerCache(LayerCacheBuffers.startIndex + i);
			layerCache.index = i;
			activeGroups.push(layerCache);
		}
		
		layerGroups = new LayerGroups(activeGroups, maxLayers);
	}
	
	public static inline function begin():Void
	{
		layerGroups.begin();
	}
	
	public static inline function build(coreDisplay:CoreDisplayObject) 
	{
		layerGroups.build(coreDisplay);
	}
	
	public static inline function end():Void
	{
		layerGroups.end();
		currentIndex = 0;
	}
	
	public static function checkRenderTarget(staticDef:StaticDef) 
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
	
	static function get_allLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.allLayerGroups;
	}
	
	static function get_movingLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.movingLayerGroups;
	}
	
	static function get_drawToStaticLayerGroups():GcoArray<LayerGroup> 
	{
		return layerGroups.drawToStaticLayerGroups;
	}
	
	static function get_change():Bool 
	{
		return layerGroups.change;
	}
}