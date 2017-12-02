package fuse.core.assembler.batches;

import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.AtlasSheet;
import fuse.core.assembler.batches.batch.AtlasBatch;
import fuse.core.assembler.batches.batch.BatchType;
import fuse.core.assembler.batches.batch.DirectBatch;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.assembler.batches.batch.CacheBakeBatch;
import fuse.core.assembler.layers.LayerBufferAssembler;
import fuse.core.assembler.layers.layer.LayerBuffer;
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
		Pool.cacheDrawBatches.forceReuse();
		
		
	}
	
	static public function build() 
	{
		clear();
		
		addAtlasRenderables();
		addLayerRenderables();
		addDirectAndCacheRenderables();
		
		closeBatch();
		
		//trace("batches.length = " + batches.length);
		//for (k in 0...batches.length) 
		//{
			//trace(batches[k]);
		//}
	}
	
	static private function addAtlasRenderables() 
	{
		if (AtlasSheet.activePartitions.length > 0 && AtlasSheet.active){
			currentBatchType = BatchType.ATLAS;
			
			for (j in 0...AtlasSheet.activePartitions.length) 
			{
				var atlasPartition:AtlasPartition = AtlasSheet.activePartitions[j];
				addRenderable(atlasPartition, atlasPartition.atlasTextureId);
			}
		}
	}
	
	static private function addLayerRenderables() 
	{
		if (LayerBufferAssembler.staticCount <= 1 && LayerBufferAssembler.activeLayers.length > 0){
			currentBatchType = BatchType.CACHE_BAKE;  // draws renderables to render texture
			for (j in 0...LayerBufferAssembler.activeLayers.length) 
				addRenderables(LayerBufferAssembler.activeLayers[j].renderables, LayerBufferAssembler.activeLayers[j].renderTarget);
		}
	}
	
	static private function addDirectAndCacheRenderables() 
	{
		if (LayerBufferAssembler.directLayers.length > 0){
			for (i in 0...LayerBufferAssembler.directLayers.length) {
				if (LayerBufferAssembler.directLayers[i].active) {
					currentBatchType = BatchType.CACHE_DRAW; // draws a single quad to the back buffer
				}
				else {
					currentBatchType = BatchType.DIRECT;  // draws renderables directly to back buffer
				}
				addRenderables(LayerBufferAssembler.directLayers[i].renderables, LayerBufferAssembler.directLayers[i].renderTarget);
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
			case BatchType.CACHE_DRAW:	currentBatch = Pool.cacheDrawBatches.request();
		}
		currentBatch.init(batches.length);
	}
	
	static private function closeBatch() 
	{
		if (currentBatch == null) return;
		if (currentBatch.renderables.length > 0) {
			batches.push(currentBatch);
		}
	}
}