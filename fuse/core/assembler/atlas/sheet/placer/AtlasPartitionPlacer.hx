package fuse.core.assembler.atlas.sheet.placer;

import fuse.core.backend.texture.CoreTexture;
import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.communication.data.textureData.ITextureData;

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
		if (coreTexture.textureData.activeData.width <= partition.width && coreTexture.textureData.activeData.height <= partition.height) {
			partition.rightPartition = getRightPartition(partition, coreTexture.textureData);
			partition.bottomPartition = getBottomPartition(partition, coreTexture.textureData);
			
			partition.width = coreTexture.textureData.activeData.width;
			partition.height = coreTexture.textureData.activeData.height;
			partition.coreTexture = coreTexture;
			return true;
		}
		return false;
	}
	
	static function getRightPartition(partition:AtlasPartition, textureData:ITextureData):AtlasPartition
	{
		if (textureData.activeData.width < partition.width) {
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
					partition.x + textureData.activeData.width + padding,
					partition.y,
					partition.width - textureData.activeData.width - padding,
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
		if (textureData.activeData.height < partition.height) {
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
					partition.y + textureData.activeData.height + padding,
					textureData.activeData.width,
					partition.height - textureData.activeData.height - padding
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