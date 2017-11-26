package fuse.core.assembler.batches;

import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.AtlasSheet;
import fuse.core.assembler.batches.batch.AtlasBatch;
import fuse.core.assembler.batches.batch.BatchType;
import fuse.core.assembler.batches.batch.DirectBatch;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.assembler.batches.batch.LayerCacheBatch;
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
		Pool.layerCacheBatches.forceReuse();
		Pool.directBatches.forceReuse();
	}
	
	static public function build() 
	{
		
		clear();
		
		addAtlasRenderables();
		addLayerRenderables();
		addDirectRenderables();
		
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
			getNewBatch();
			
			for (j in 0...AtlasSheet.activePartitions.length) 
			{
				var atlasPartition:AtlasPartition = AtlasSheet.activePartitions[j];
				addRenderable(atlasPartition, atlasPartition.atlasTextureId);
			}
		}
	}
	
	static private function addLayerRenderables() 
	{
		if (LayerBufferAssembler.activeLayers.length > 0){
			currentBatchType = BatchType.LAYER_CACHE;
			if (currentBatch == null) getNewBatch();
			
			for (j in 0...LayerBufferAssembler.activeLayers.length) 
				addRenderables(LayerBufferAssembler.activeLayers[j].renderables, LayerBufferAssembler.activeLayers[j].renderTarget);
		}
	}
	
	static private function addDirectRenderables() 
	{
		if (LayerBufferAssembler.directLayers.length > 0){
			currentBatchType = BatchType.DIRECT;
			if (currentBatch == null) getNewBatch();
			
			for (i in 0...LayerBufferAssembler.directLayers.length) 
				addRenderables(LayerBufferAssembler.directLayers[i].renderables, LayerBufferAssembler.directLayers[i].renderTarget);
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
		var added:Bool = currentBatch.add(renderable, renderTarget);
		if (added) return;
		
		getNewBatch();
		addRenderable(renderable, renderTarget);
	}
	
	static private function getNewBatch() 
	{
		switch currentBatchType {
			case BatchType.ATLAS:		currentBatch = Pool.atlasBatches.request();
			case BatchType.LAYER_CACHE:	currentBatch = Pool.layerCacheBatches.request();
			case BatchType.DIRECT:		currentBatch = Pool.directBatches.request();
		}
		currentBatch.init(batches.length);
		
		batches.push(currentBatch);
	}
}