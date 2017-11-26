package fuse.core.assembler.layers.sort;
import fuse.core.assembler.layers.generate.GenerateLayers;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.assembler.layers.sort.CustomSort.SortType;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class SortLayers
{
	static var numLayers:Int = 2;
	static private var newDirectLayers = new GcoArray<LayerBuffer>([]);
	
	static var SortByStatic2:LayerBuffer -> LayerBuffer -> Int;
	static var SortByNumberOfStaticItems2:LayerBuffer -> LayerBuffer -> Int;
	static var SortBackToLayerIndex2:LayerBuffer -> LayerBuffer -> Int;
	static var customSort:CustomSort<LayerBuffer>;
	
	static function __init__() 
	{
		SortByStatic2 = SortByStatic;
		SortByNumberOfStaticItems2 = SortByNumberOfStaticItems;
		SortBackToLayerIndex2 = SortBackToLayerIndex;
		
		customSort = new CustomSort<LayerBuffer>();
	}
	
	static public function build() 
	{
		//TestTrace();
		//
		// Find largest static layers
		// * Sort by static
		//LayerBufferAssembler.directLayers.sort(SortByStatic2);
		customSort.sort(LayerBufferAssembler.directLayers, "isStatic", SortType.DESCENDING);
		
		//TestTrace();
		// * Sort by length
		//LayerBufferAssembler.directLayers.sort(SortByNumberOfStaticItems2);
		customSort.sort(LayerBufferAssembler.directLayers, "numRenderables", SortType.DESCENDING);
		//TestTrace();
		// * Set active static based on position
		SetActiveBasedOnPosition();
		//TestTrace();
		
		// Sort back to index
		//LayerBufferAssembler.directLayers.sort(SortBackToLayerIndex2);
		customSort.sort(LayerBufferAssembler.directLayers, "index", SortType.ASCENDING);
		//TestTrace();
		
		CombineInactive();
		//TestTrace();
		//trace("||||||||||||||||||||||||||");
	}
	
	static private function TestTrace() 
	{
		var layers:GcoArray<LayerBuffer> = LayerBufferAssembler.directLayers;
		for (i in 0...layers.length) 
		{
			trace(["image.index = " + layers[i].index, layers[i].isStatic, layers[i].renderables.length, layers[i].active]);
		}
		trace("-------");
	}
	
	static inline function SortByStatic(a:LayerBuffer, b:LayerBuffer):Int 
	{
		return Math.floor(b.isStatic - a.isStatic);
	}
	
	static inline function SortByNumberOfStaticItems(a:LayerBuffer, b:LayerBuffer):Int
	{
		return Math.floor(b.renderables.length - a.renderables.length);
	}
	
	static inline function SetActiveBasedOnPosition() 
	{
		var count:Int = 0;
		for (i in 0...LayerBufferAssembler.directLayers.length) 
		{
			if (count >= numLayers) break;
			if (LayerBufferAssembler.directLayers[i].isStatic == 0) break;
			
			count++;
			LayerBufferAssembler.directLayers[i].active = true;
			
			var activeLayer:LayerBuffer = LayerBufferAssembler.directLayers[i].clone();
			activeLayer.index = LayerBufferAssembler.activeLayers.length;
			activeLayer.renderTarget = 7; // TODO: replace with correct textureId
			LayerBufferAssembler.activeLayers.push(activeLayer);
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
		for (i in 0...LayerBufferAssembler.directLayers.length) 
		{
			var layer:LayerBuffer = LayerBufferAssembler.directLayers[i];
			if (layer.active) {
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
		
		LayerBufferAssembler.directLayers.clear();
		for (k in 0...newDirectLayers.length) LayerBufferAssembler.directLayers.push(newDirectLayers[k]);
	}
}