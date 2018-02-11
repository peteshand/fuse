package fuse.core.assembler.atlas.sheet;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.placer.AtlasPartitionPlacer;
import fuse.core.assembler.atlas.textures.AtlasTextures;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.display.CoreAtlasCopyFrameImage;
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
	public var activePartitions = new GcoArray<AtlasPartition>([]);
	//static var shouldClear:Bool = false;
	
	var availablePartition = new GcoArray<AtlasPartition>([]);
	var frameCopyPartition:CoreAtlasCopyFrameImage;
	
	public var index:Int;
	public var atlasTextureId(get, null):Int;
	
	var texturesFromLastFrame:Int = 0;
	
	public function new(index:Int) 
	{
		this.index = index;
		frameCopyPartition = new CoreAtlasCopyFrameImage();
		
		initAvailablePartitions();
	}
	
	public function clear() 
	{
		activePartitions.clear();
		
		//initAvailablePartitions();
	}
	
	function initAvailablePartitions() 
	{
		availablePartition.clear();
		availablePartition.push(
			//Pool.atlasPartitions2.request()
			new AtlasPartition()
			.init(0, 0, Fuse.MAX_TEXTURE_SIZE, Fuse.MAX_TEXTURE_SIZE)
		);
	}
	
	public function add(coreTexture:CoreTexture):Bool
	{
		if (coreTexture.textureData.placed == 1) return true;
		
		
		//if (coreTexture.textureData.directRender == 1) return; // already checked in AtlasTextures
		
		//if (coreTexture.textureData.placed == 1) return true;
		
		//var textureData:ITextureData = coreTexture.textureData;
		var successfulPlacement:Bool = false;
		// TODO: only place if it hasn't already been placed in the past
		
		for (i in 0...availablePartition.length) 
		{
			var partition:AtlasPartition = availablePartition[i];
			//if (partition.available){
			successfulPlacement = AtlasPartitionPlacer.place(partition, coreTexture);
			
			//trace("i = " + i);
			if (successfulPlacement)
			{
				if (partition.rightPartition != null)	availablePartition.insert(i + 1, partition.rightPartition);
				if (partition.bottomPartition != null)	availablePartition.insert(i + 1, partition.bottomPartition);
				activePartitions.push(partition);
				availablePartition.splice(i, 1);
				return true;
			}
		}
		
		if (!successfulPlacement) {
			trace("Failed to place texture in AtlasBuffer, will need to render texture directly; " + coreTexture.textureId);
		}
		return false;
	}
	
	public function writeActivePartitions() 
	{
		//trace("activePartitions.length = " + activePartitions.length);
		if (activePartitions.length == 0) return;
		
		for (i in 0...activePartitions.length) 
		{
			var partition:AtlasPartition = activePartitions[i];
			var textureData:ITextureData = partition.coreTexture.textureData;
			
			
			textureData.placed = 1;
			textureData.x = partition.x;
			textureData.y = partition.y;
			textureData.width = partition.width;
			textureData.height = partition.height;
			textureData.p2Width = Fuse.MAX_TEXTURE_SIZE;
			textureData.p2Height = Fuse.MAX_TEXTURE_SIZE;
			textureData.atlasTextureId = atlasTextureId; // renderTarget for image being rendered into atlas buffer
			//textureData.atlasBatchTextureIndex = index;
			
			partition.textureId = textureData.textureId;
			partition.coreTexture.updateUVData();
			
			AtlasSheets.partitions.push(partition);
		}
		
		copyLastFrame();
		
		texturesFromLastFrame = AtlasSheets.partitions.length;
	}
	
	public function copyLastFrame() 
	{
		if (texturesFromLastFrame == 0) return;
		
		var renderCount:Int = AtlasSheets.renderCount - 1;
		
		frameCopyPartition.textureId = AtlasSheets.startIndex + (index * 2) + (renderCount % 2);
		if (frameCopyPartition.coreTexture == null) return;
		
		frameCopyPartition.coreTexture.textureData.atlasTextureId = atlasTextureId;
		AtlasSheets.partitions.push(frameCopyPartition);
		
	}
	
	function get_atlasTextureId():Int 
	{
		return AtlasSheets.startIndex + (index * 2) + (AtlasSheets.renderCount % 2);
	}
}