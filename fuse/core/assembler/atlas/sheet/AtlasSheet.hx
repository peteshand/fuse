package fuse.core.assembler.atlas.sheet;

import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.atlas.placer.AtlasPartitionPlacer;
import fuse.core.assembler.atlas.textures.AtlasTextures;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheet
{
	public static var activePartitions = new GcoArray<AtlasPartition>([]);
	public static var active:Bool = false;
	
	static var availablePartition = new GcoArray<AtlasPartition>([]);
	static var texturesPerBatch:Int = 4;
	static var startIndex:Int = 2;
	
	public function new() 
	{
		
	}
	
	public static function clear() 
	{
		if (activePartitions.length == 0 && availablePartition.length == texturesPerBatch) return;
		
		Pool.atlasPartitions2.forceReuse();
		
		activePartitions.clear();
		availablePartition.clear();
		var i:Int = texturesPerBatch - 1;
		while (i >= 0)
		{
			availablePartition.push(
				Pool.atlasPartitions2.request()
				.init(i, startIndex + i, 0, 0, Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE)
			);
			i--;
		}
	}
	
	static public function build() 
	{
		active = true;
		clear();
		
		for (i in 0...AtlasTextures.textures.length) 
		{
			place(AtlasTextures.textures[i]);
		}
		//drawActive();
	}
	
	static inline function place(coreTexture:CoreTexture) 
	{
		var textureData:ITextureData = coreTexture.textureData;
		var successfulPlacement:Bool = false;
		// TODO: only place if it hasn't already been placed in the past
		
		for (i in 0...availablePartition.length) 
		{
			var partition:AtlasPartition = availablePartition[i];
			//if (partition.available){
			successfulPlacement = AtlasPartitionPlacer.place(partition, textureData);
			
			//trace("i = " + i);
			if (successfulPlacement) {
				
				textureData.placed = 1;
				textureData.x = partition.x;
				textureData.y = partition.y;
				textureData.width = partition.width;
				textureData.height = partition.height;
				textureData.p2Width = Fuse.MAX_TEXTURE_SIZE;
				textureData.p2Height = Fuse.MAX_TEXTURE_SIZE;
				textureData.atlasTextureId = partition.atlasTextureId;
				textureData.atlasBatchTextureIndex = partition.atlasIndex;
				
				//trace("partition.atlasIndex = " + partition.atlasIndex);
				//trace([textureData.x, textureData.y, textureData.width, textureData.height]);
				
				//partition.textureData = textureData;
				partition.textureId = textureData.textureId;
				
				coreTexture.updateUVData();
				
				if (partition.rightPartition != null) {
					availablePartition.insert(i + 1, partition.rightPartition);
				}
				if (partition.bottomPartition != null) {
					availablePartition.insert(i + 1, partition.bottomPartition);
				}
				
				activePartitions.push(partition);
				//trace([i, availablePartition.length]);
				
				availablePartition.splice(i, 1);
				
				break;
			}
		}
		
		if (!successfulPlacement) {
			trace("Failed to place texture in AtlasBuffer, will need to render texture directly; " + coreTexture.textureId);
		}
	}
}