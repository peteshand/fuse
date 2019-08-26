package fuse.core.assembler.atlas.sheet.placer;

import fuse.core.backend.texture.CoreTexture;
import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.communication.data.textureData.ITextureData;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasPartitionPlacer {
	static var padding:Int = 1;

	public static function place(partition:AtlasPartition, coreTexture:CoreTexture):Bool {
		var textureWidth:Int = coreTexture.textureData.baseData.width;
		var textureHeight:Int = coreTexture.textureData.baseData.height;

		/*
			trace("FIX, causing blinking issue");
			if (textureWidth > textureHeight) {
				partition.rotate = true;
				textureWidth = coreTexture.textureData.baseData.height;
				textureHeight = coreTexture.textureData.baseData.width;
			}
		 */

		if (textureWidth <= partition.width && textureHeight <= partition.height) {
			partition.rightPartition = getRightPartition(partition, textureWidth, textureHeight /*coreTexture.textureData*/);
			partition.bottomPartition = getBottomPartition(partition, textureWidth, textureHeight /*coreTexture.textureData*/);

			partition.width = textureWidth;
			partition.height = textureHeight;
			partition.coreTexture = coreTexture;
			return true;
		}
		return false;
	}

	static function getRightPartition(partition:AtlasPartition, textureWidth:Int, textureHeight:Int /*textureData:ITextureData*/):AtlasPartition {
		return new AtlasPartition().init(partition.x + textureWidth + padding, partition.y, partition.width - textureWidth - padding, textureHeight);
	}

	static function getBottomPartition(partition:AtlasPartition, textureWidth:Int, textureHeight:Int /*textureData:ITextureData*/):AtlasPartition {
		return new AtlasPartition().init(partition.x, partition.y + textureHeight + padding, partition.width, partition.height - textureHeight - padding);
	}
}
