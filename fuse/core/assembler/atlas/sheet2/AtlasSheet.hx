package fuse.core.assembler.atlas.sheet2;

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
class AtlasPartitions
{
	public static var activePartitions = new GcoArray<AtlasPartition>([]);
	public static var active:Bool = false;
	//static var shouldClear:Bool = false;
	
	static var availablePartition = new GcoArray<AtlasPartition>([]);
	public static var numAtlases:Int = 4;
	public static var startIndex:Int = 2;
	
	public function new() 
	{
		
	}
	
	public static function clear() 
	{
		if (activePartitions.length == 0 && availablePartition.length == numAtlases) return;
		
		//Pool.atlasPartitions2.forceReuse();
		
		activePartitions.clear();
		availablePartition.clear();
		var i:Int = numAtlases - 1;
		while (i >= 0)
		{
			availablePartition.push(
				//Pool.atlasPartitions2.request()
				new AtlasPartition()
				.init(i, startIndex + i, 0, 0, Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE)
			);
			i--;
		}
	}
	
	static public function build(shouldClear:Bool=false) 
	{
		active = true;
		
		//AtlasSheet.shouldClear = shouldClear;
		//if (shouldClear) {
			clear();
		//}
		
		for (i in 0...AtlasTextures.textures.length) 
		{
			/*var successfulPlacement:Bool =*/ place(AtlasTextures.textures[i]);
			/*if (shouldClear == false && !successfulPlacement) {
				build(true);
				return;
			}*/
		}
	}
	
	static inline function place(coreTexture:CoreTexture)
	{
		//if (coreTexture.textureData.directRender == 1) return; // already checked in AtlasTextures
		
		//if (coreTexture.textureData.placed == 1) return true;
		
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
		
		//return successfulPlacement;
	}
}