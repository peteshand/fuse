package fuse.core.backend.atlas.placer;
import fuse.core.backend.atlas.partition.AtlasPartition;
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
	
	public static function place(partition:AtlasPartition, textureData:ITextureData):Bool
	{
		if (textureData.width <= partition.width && textureData.height <= partition.height) {
			partition.rightPartition = getRightPartition(partition, textureData);
			partition.bottomPartition = getBottomPartition(partition, textureData);
			
			partition.width = textureData.width;
			partition.height = textureData.height;
			
			//if (textureData.partition.value != null) {
			//	AtlasPartitionPool.release(textureData.partition.value);
			//}
			//textureData.partition.value = AtlasPartitionPool.allocate(partition.x, partition.y, partition.width, partition.height);
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
				
				return Pool.atlasPartitions.request().init(
					partition.atlasIndex,
					partition.atlasTextureId,
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
				return Pool.atlasPartitions.request().init(
					partition.atlasIndex,
					partition.atlasTextureId,
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