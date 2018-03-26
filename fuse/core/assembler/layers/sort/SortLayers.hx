package fuse.core.assembler.layers.sort;
import fuse.core.assembler.layers.generate.GenerateLayers;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.assembler.layers.layer.LayerCacheRenderable;
import fuse.core.assembler.layers.sort.CustomSort.SortType;
import fuse.core.backend.display.CoreCacheLayerImage;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class SortLayers
{
	public static var layers = new GcoArray<LayerBuffer>([]);
	
	static var cacheLayerImages:Array<CoreCacheLayerImage>;
	static private var newDirectLayers = new GcoArray<LayerBuffer>([]);
	
	static var SortByStatic2:LayerBuffer -> LayerBuffer -> Int;
	static var SortByNumberOfStaticItems2:LayerBuffer -> LayerBuffer -> Int;
	static var SortBackToLayerIndex2:LayerBuffer -> LayerBuffer -> Int;
	static var customSort:CustomSort<LayerBuffer>;
	
	static function __init__() 
	{
		cacheLayerImages = [];
		
		SortByStatic2 = SortByStatic;
		SortByNumberOfStaticItems2 = SortByNumberOfStaticItems;
		SortBackToLayerIndex2 = SortBackToLayerIndex;
		
		customSort = new CustomSort<LayerBuffer>();
	}
	
	static public function init() 
	{
		
		for (i in 0...LayerCacheBuffers.numBuffers) 
		{
			cacheLayerImages.push(new CoreCacheLayerImage(LayerCacheBuffers.startIndex + i));
		}
	}
	
	static private function clear() 
	{
		SortLayers.layers.clear();
	}
	
	static public function build() 
	{
		if (!GenerateLayers.layersGenerated) return;
		
		if (cacheLayerImages.length == 0) init();
		clear();
		
		//TestTrace();
		//
		// Find largest static layers
		// * Sort by static
		//GenerateLayers.layers.sort(SortByStatic2);
		customSort.sort(GenerateLayers.layers, "isStatic", SortType.DESCENDING);
		
		//TestTrace();
		// * Sort by length
		//GenerateLayers.layers.sort(SortByNumberOfStaticItems2);
		customSort.sort(GenerateLayers.layers, "numRenderables", SortType.DESCENDING);
		//TestTrace();
		// * Set active static based on position
		if (GenerateLayers.drawCacheLayers){
			SetActiveBasedOnPosition();
		}
		//TestTrace();
		
		// Sort back to index
		//GenerateLayers.layers.sort(SortBackToLayerIndex2);
		customSort.sort(GenerateLayers.layers, "index", SortType.ASCENDING);
		//TestTrace();
		
		CombineInactive();
		//TestTrace();
		//trace("||||||||||||||||||||||||||");
	}
	
	static private function TestTrace() 
	{
		//var layers:GcoArray<LayerBuffer> = GenerateLayers.layers;
		//for (i in 0...layers.length) 
		//{
			//trace(["image.index = " + layers[i].index, layers[i].isStatic, layers[i].renderables.length, layers[i].isCacheLayer, layers[i].objectIds()]);
		//}
		//trace("-------");
	}
	
	static inline function SortByStatic(l1:LayerBuffer, l2:LayerBuffer):Int 
	{
		//0 1 = -1
		//1 0 = 1
		//0 0 = 0
		//1 1 = 0
		//
		//false true
		//true false
		//false false
		//true true
		
		var a:Int = 0;
		var b:Int = 0;
		if (l1.updateAll) a = 1;
		if (l2.updateAll) b = 1;
		
		
		return Math.floor(b - a);
	}
	
	static inline function SortByNumberOfStaticItems(a:LayerBuffer, b:LayerBuffer):Int
	{
		return Math.floor(b.renderables.length - a.renderables.length);
	}
	
	static inline function SetActiveBasedOnPosition() 
	{
		var count:Int = 0;
		for (i in 0...GenerateLayers.layers.length) 
		{
			if (count >= LayerCacheBuffers.numBuffers) break;
			
			
			if (GenerateLayers.layers[i].updateAll) break;
			
			
			GenerateLayers.layers[i].isCacheLayer = true;
			
			var activeLayer:LayerBuffer = GenerateLayers.layers[i];
			var offset:Int = LayerCacheBuffers.startIndex + SortLayers.layers.length;
			
			
			var cacheLayer:LayerBuffer = activeLayer.clone();
			cacheLayer.renderTarget = -1;
			//cacheLayer.renderables.push(new LayerCacheRenderable(offset));
			
			var coreCacheLayerImage:CoreCacheLayerImage = cacheLayerImages[count];
			coreCacheLayerImage.update();
			cacheLayer.renderables.push(coreCacheLayerImage);
			
			//trace("LayerBufferAssembler.staticCount = " + LayerBufferAssembler.staticCount);
			
			// Move layer to top of render que
			if (GenerateLayers.layersGenerated == true) {
				activeLayer.index = SortLayers.layers.length;
				activeLayer.renderTarget = offset; // TODO: replace with correct textureId	
				SortLayers.layers.push(activeLayer);
			}
			
			
			GenerateLayers.layers[i] = cacheLayer;
			
			//var activeLayer:LayerBuffer = GenerateLayers.layers[i].clone();
			//activeLayer.index = SortLayers.layers.length;
			//activeLayer.renderTarget = 7; // TODO: replace with correct textureId
			
			count++;
		}
	}
	
	static inline function SortBackToLayerIndex(a:LayerBuffer, b:LayerBuffer):Int
	{
		return Math.floor(a.index - b.index);
	}
	
	static private function CombineInactive() 
	{
		newDirectLayers.clear();
		var currentInactiveLayer:LayerBuffer = null;
		for (i in 0...GenerateLayers.layers.length) 
		{
			var layer:LayerBuffer = GenerateLayers.layers[i];
			if (layer.isCacheLayer) {
				currentInactiveLayer = null;
				newDirectLayers.push(layer);
			}
			else if (currentInactiveLayer == null) {
				currentInactiveLayer = layer;
				newDirectLayers.push(layer);
			}
			
			if (currentInactiveLayer != null && currentInactiveLayer != layer) {
				for (j in 0...layer.renderables.length) 
				{
					currentInactiveLayer.renderables.push(layer.renderables[j]);
				}
			}
		}
		
		GenerateLayers.layers.clear();
		for (k in 0...newDirectLayers.length) GenerateLayers.layers.push(newDirectLayers[k]);
	}
}