package fuse.core.assembler.atlas.sheet;

import fuse.texture.TextureId;
import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.placer.AtlasPartitionPlacer;
import fuse.core.backend.display.CoreAtlasCopyFrameImage;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheet
{
	public var partitions = new GcoArray<AtlasPartition>([]);
	public var lastFramePartitions = new GcoArray<AtlasPartition>([]);
	
	public var activePartitions = new GcoArray<AtlasPartition>([]);
	
	var availablePartition = new GcoArray<AtlasPartition>([]);
	var frameCopyPartition:CoreAtlasCopyFrameImage;
	
	public var index:Int;
	public var atlasTextureId(get, null):TextureId;
	public var lastFramesAtlasTextureId(get, null):TextureId;
	
	var texturesFromLastFrame:Int = 0;
	public var renderCount:Int = 0;
	
	public function new(index:Int) 
	{
		this.index = index;
		frameCopyPartition = new CoreAtlasCopyFrameImage();
		
		initAvailablePartitions();
	}
	
	public function clear() 
	{
		activePartitions.clear();
		
		initAvailablePartitions();
		
		if (partitions.length > 0){
			partitions.copyTo(lastFramePartitions);
		}
		partitions.clear();
		
		//trace("partitions.length = " + partitions.length);
		//trace("lastFramePartitions.length = " + lastFramePartitions.length);
		//for (i in 0...lastFramePartitions.length) 
		//{
			//var partition:AtlasPartition = lastFramePartitions[i];
			//add(partition.coreTexture, partition);
		//}
	}
	
	function initAvailablePartitions() 
	{
		availablePartition.clear();
		availablePartition.push(
			//Pool.atlasPartitions2.request()
			new AtlasPartition()
			.init(1, 1, Fuse.MAX_TEXTURE_SIZE - 2, Fuse.MAX_TEXTURE_SIZE - 2)
		);
	}
	
	public function add(coreTexture:CoreTexture):Bool
	{
		//if (AtlasUtils.alreadyPlaced(coreTexture.textureData)) return true;
		//if (coreTexture.textureData.directRender == 1) return; // already checked in AtlasTextures
		
		//var textureData:ITextureData = coreTexture.textureData;
		var successfulPlacement:Bool = false;
		// TODO: only place if it hasn't already been placed in the past
		
		for (i in 0...availablePartition.length) 
		{
			var partition:AtlasPartition = availablePartition[i];
			partition.lastFramePairPartition = null;
			
			
			//trace("partition.lastFramePairPartition = " + partition.lastFramePairPartition);
			//trace("place: " + coreTexture.objectId + ", " + coreTexture.textureId);
			successfulPlacement = AtlasPartitionPlacer.place(partition, coreTexture);
			//trace("i = " + i);
			if (successfulPlacement)
			{
				if (!coreTexture.textureHasChanged) {
					partition.lastFramePairPartition = getLastFramePair(coreTexture);
				}
				
				//if (partition.rightPartition != null)	availablePartition.insert(i + 1, partition.rightPartition);
				//if (partition.bottomPartition != null)	availablePartition.insert(i + 1, partition.bottomPartition);
				//activePartitions.push(partition);
				//availablePartition.splice(i, 1);
				var added:Bool = false;
				if (partition.rightPartition != null)	{
					availablePartition[i] = partition.rightPartition;
					added = true;
				}
				if (partition.bottomPartition != null)	{
					if (added) availablePartition.push(partition.bottomPartition);
					else availablePartition[i] = partition.bottomPartition;
					added = true;
				}
				activePartitions.push(partition);
				if (!added) availablePartition.splice(i, 1);
				return true;
			}
		}
		
		//if (!successfulPlacement) {
		//	trace("Failed to place texture in AtlasBuffer, will need to render texture directly; " + coreTexture.textureId);
		//}
		return false;
	}
	
	function getLastFramePair(coreTexture:CoreTexture) 
	{
		for (i in 0...lastFramePartitions.length) 
		{
			if (lastFramePartitions[i].coreTexture.textureId == coreTexture.textureId) {
				return lastFramePartitions[i];
			}
		}
		return null;
	}
	
	public function writeActivePartitions() 
	{
		//trace("activePartitions.length = " + activePartitions.length);
		if (activePartitions.length == 0) return;
		if (noChanges(activePartitions)) return;
		
		
		
		for (i in 0...activePartitions.length) 
		{
			var partition:AtlasPartition = activePartitions[i];
			var textureData:ITextureData = partition.coreTexture.textureData;
			
			
			//textureData.placed = 1;
			textureData.atlasData.x = partition.x;					// x position to draw on atlas
			textureData.atlasData.y = partition.y;					// y position to draw on atlas
			textureData.atlasData.width = partition.width;			// width to draw on atlas
			textureData.atlasData.height = partition.height;			// height to draw on atlas
			textureData.atlasData.p2Width = Fuse.MAX_TEXTURE_SIZE;	// width of target texture
			textureData.atlasData.p2Height = Fuse.MAX_TEXTURE_SIZE;	// height of target texture
			//trace("atlasTextureId = " + atlasTextureId);
			textureData.atlasData.textureId = atlasTextureId;	// renderTarget for image being rendered into atlas buffer
			//textureData.atlasBatchTextureIndex = index;
			
			textureData.activeData = textureData.atlasData;
			
			partition.lastRenderTarget = lastFramesAtlasTextureId;
			partition.textureObjectId = textureData.baseData.objectId;
			partition.coreTexture.updateUVData();
			
			AtlasSheets.partitions.push(partition);
			partitions.push(partition);
		}
		
		//copyLastFrame();
		
		texturesFromLastFrame = AtlasSheets.partitions.length;
		
		renderCount++;
	}
	
	function noChanges(p:GcoArray<AtlasPartition>) 
	{
		var count:Int = 0;
		for (j in 0...p.length) 
		{
			if (p[j].coreTexture.textureHasChanged) return false;
			if (p[j].lastFramePairPartition != null) count++;
		}
		if (count == p.length) return true;
		return false;
	}
	
	//public function copyLastFrame() 
	//{
		//if (texturesFromLastFrame == 0) return;
		//
		//frameCopyPartition.textureId = lastFramesAtlasTextureId;
		//if (frameCopyPartition.coreTexture == null) return;
		//
		//frameCopyPartition.coreTexture.textureData.atlasTextureId = atlasTextureId;
		//AtlasSheets.partitions.push(frameCopyPartition);
	//}
	
	inline function get_atlasTextureId():TextureId 
	{
		return AtlasSheets.startIndex + (index * 2) + (renderCount % 2);
	}
	
	inline function get_lastFramesAtlasTextureId():TextureId 
	{
		return AtlasSheets.startIndex + (index * 2) + ((renderCount - 1) % 2);
	}
	
	
}