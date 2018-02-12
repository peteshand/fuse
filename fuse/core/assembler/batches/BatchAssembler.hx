package fuse.core.assembler.batches;

import fuse.core.assembler.atlas.sheet.AtlasSheets;
import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.AtlasSheet;
import fuse.core.assembler.batches.batch.AtlasBatch;
import fuse.core.assembler.batches.batch.BatchType;
import fuse.core.assembler.batches.batch.DirectBatch;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.assembler.batches.batch.CacheBakeBatch;
import fuse.core.assembler.layers.LayerBufferAssembler;
import fuse.core.assembler.layers.generate.GenerateLayers;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.assembler.layers.sort.SortLayers;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.display.CoreImage;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;

/**
    This class is called every frame and is responsible for splitting the data that is feed into the stage3d.
**/
class BatchAssembler
{
	static private var currentBatch:IBatch;
	static private var currentBatchType:BatchType;
	static public var batches = new GcoArray<IBatch>([]);
	
	static private function clear() 
	{
		currentBatch = null;
		batches.clear();
		Pool.atlasBatches.forceReuse();
		Pool.cacheBakeBatches.forceReuse();
		Pool.directBatches.forceReuse();
		//Pool.cacheDrawBatches.forceReuse();
	}
	
	static public function build() 
	{
		//if (!GenerateLayers.changed) return;
		
		clear();
		
		addAtlasRenderables();
		addLayerRenderables();
		addDirectRenderables();
		
		closeBatch();
		
		
		//trace("batches.length = " + batches.length);
		//for (k in 0...batches.length) 
		//{
			//trace(batches[k]);
		//}
	}
	
	static private function addAtlasRenderables() 
	{
		if (AtlasSheets.partitions.length > 0 && AtlasSheets.active){
			currentBatchType = BatchType.ATLAS;
			
			for (j in 0...AtlasSheets.partitions.length) 
			{
				var atlasPartition:AtlasPartition = AtlasSheets.partitions[j];
				addRenderable(atlasPartition, atlasPartition.coreTexture.textureData.atlasTextureId);
			}
		}
	}
	
	static private function addLayerRenderables() 
	{
		//if (LayerBufferAssembler.STATE == LayerState.BAKE){
			if (GenerateLayers.layersGenerated == true && SortLayers.layers.length > 0){
				currentBatchType = BatchType.CACHE_BAKE;  // draws renderables to render texture
				for (j in 0...SortLayers.layers.length) {
					//if (SortLayers.layers[j].hasChanged){
						addRenderables(SortLayers.layers[j].renderables, SortLayers.layers[j].renderTarget);
					//}
				}
			}
		//}
	}
	
	static private function addDirectRenderables() 
	{
		if (GenerateLayers.layers.length > 0) {
			for (i in 0...GenerateLayers.layers.length) {
				currentBatchType = BatchType.DIRECT;  // draws renderables directly to back buffer
				addRenderables(GenerateLayers.layers[i].renderables, GenerateLayers.layers[i].renderTarget);
			}
		}
	}
	
	static private function addRenderables(renderables:GcoArray<ICoreRenderable>, renderTarget:Int) 
	{
		for (j in 0...renderables.length)
		{
			addRenderable(renderables[j], renderTarget);
		}
	}
	
	static private function addRenderable(renderable:ICoreRenderable, renderTarget:Int)
	{
		if (currentBatch == null) getNewBatch();
		
		var added:Bool = currentBatch.add(renderable, renderTarget, currentBatchType);
		if (added) return;
		
		getNewBatch();
		addRenderable(renderable, renderTarget);
	}
	
	static private function getNewBatch() 
	{
		closeBatch();
		
		switch currentBatchType {
			case BatchType.ATLAS:		currentBatch = Pool.atlasBatches.request();
			case BatchType.CACHE_BAKE:	currentBatch = Pool.cacheBakeBatches.request();
			case BatchType.DIRECT:		currentBatch = Pool.directBatches.request();
			//case BatchType.CACHE_DRAW:	currentBatch = Pool.cacheDrawBatches.request();
		}
		currentBatch.init(batches.length);
	}
	
	static inline function closeBatch() 
	{
		if (currentBatch == null) return;
		if (currentBatch.renderables.length > 0) {
			currentBatch.updateHasChanged();
			batches.push(currentBatch);
		}
	}
	
	public static inline function findMaxNumTextures() 
	{
		var highestNumTextures:Int = 0;
		for (i in 0...batches.length) 
		{
			if (batches[i].batchData.skip == 0) {
				if (highestNumTextures < batches[i].batchData.numTextures) {
					highestNumTextures = batches[i].batchData.numTextures;
				}
			}
		}
		
		Fuse.current.conductorData.highestNumTextures = highestNumTextures;
	}
}