package fuse.core.assembler.atlas.sheet.placer;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class AtlasPartitionPlacer
{
	static var padding:Int = 1;
	
	public function new() 
	{
		
	}
	
	public static function place(partition:AtlasPartition, coreTexture:CoreTexture):Bool
	{
		if (coreTexture.textureData.width <= partition.width && coreTexture.textureData.height <= partition.height) {
			partition.rightPartition = getRightPartition(partition, coreTexture.textureData);
			partition.bottomPartition = getBottomPartition(partition, coreTexture.textureData);
			
			partition.width = coreTexture.textureData.width;
			partition.height = coreTexture.textureData.height;
			partition.coreTexture = coreTexture;
			return true;
		}
		return false;
	}
	
	static function getRightPartition(partition:AtlasPartition, textureData:ITextureData):AtlasPartition
	{
		if (textureData.width < partition.width) {
			/*if (height > width){
				return new AtlasPartition(
					partition.x + textureData.width,
					partition.y,
					partition.width - textureData.width,
					textureData.height
				);
			}
			else {*/
				
				//return Pool.atlasPartitions2.request().
				return new AtlasPartition().init(
					partition.x + textureData.width + padding,
					partition.y,
					partition.width - textureData.width - padding,
					partition.height
				);
				
				/*return new AtlasPartition(0, 
					partition.x + textureData.width,
					partition.y,
					partition.width - textureData.width,
					partition.height
				);*/
			//}
		}
		return null;
	}
	
	static function getBottomPartition(partition:AtlasPartition, textureData:ITextureData):AtlasPartition
	{
		if (textureData.height < partition.height) {
			/*if (height > width){
				return new AtlasPartition(
					partition.x,
					partition.y + textureData.height,
					partition.width,
					partition.height - textureData.height
				);
			}
			else {*/
				//return Pool.atlasPartitions2.request().init(
				return new AtlasPartition().init(
					partition.x,
					partition.y + textureData.height + padding,
					textureData.width,
					partition.height - textureData.height - padding
				);
				
				/*return new AtlasPartition(0, 
					partition.x,
					partition.y + textureData.height,
					textureData.width,
					partition.height - textureData.height
				);*/
			//}
		}
		return null;
	}
}