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
		var textureWidth:Int = coreTexture.textureData.baseData.width;
		var textureHeight:Int = coreTexture.textureData.baseData.height;
		
		if (textureWidth > textureHeight) {
			partition.rotate = true;
			textureWidth = coreTexture.textureData.baseData.height;
			textureHeight = coreTexture.textureData.baseData.width;
		}
		
		if (textureWidth <= partition.width && textureHeight <= partition.height) {
			partition.rightPartition = getRightPartition(partition, textureWidth, textureHeight /*coreTexture.textureData*/);
			partition.bottomPartition = getBottomPartition(partition, textureWidth, textureHeight/*coreTexture.textureData*/);
			
			partition.width = textureWidth;//coreTexture.textureData.activeData.width;
			partition.height = textureHeight;//coreTexture.textureData.activeData.height;
			partition.coreTexture = coreTexture;
			return true;
		}
		return false;
	}
	
	static function getRightPartition(partition:AtlasPartition, textureWidth:Int, textureHeight:Int /*textureData:ITextureData*/):AtlasPartition
	{
		if (textureWidth < partition.width) {
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
					partition.x + textureWidth + padding,
					partition.y,
					partition.width - textureWidth - padding,
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
	
	static function getBottomPartition(partition:AtlasPartition, textureWidth:Int, textureHeight:Int /*textureData:ITextureData*/):AtlasPartition
	{
		if (textureHeight < partition.height) {
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
					partition.y + textureHeight + padding,
					textureWidth,
					partition.height - textureHeight - padding
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