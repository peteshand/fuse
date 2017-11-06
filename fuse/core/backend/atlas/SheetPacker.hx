package fuse.core.backend.atlas;

import fuse.core.backend.Core;
import fuse.core.backend.atlas.partition.AtlasPartition;
import fuse.core.backend.atlas.placer.AtlasPartitionPlacer;
import fuse.core.backend.atlas.render.AtlasPartitionRenderer;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.pool.Pool;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse)
class SheetPacker
{
	static var bufferWidth:Int = Fuse.MAX_TEXTURE_SIZE;
	static var bufferHeight:Int = Fuse.MAX_TEXTURE_SIZE;
	
	var activePartitions = new GcoArray<AtlasPartition>([]);
	var availablePartition = new Array<AtlasPartition>();
	
	var index:Int;
	var startIndex:Int;
	var texturesPerBatch:Int;
	var orderTo:Int;
	
	public function new(index:Int, startIndex:Int, texturesPerBatch:Int) 
	{
		this.index = index;
		this.startIndex = startIndex;
		this.texturesPerBatch = texturesPerBatch;
		
		clear();
	}
	
	public function clear() 
	{
		//trace("clear");
		availablePartition = [];
		for (i in 0...texturesPerBatch) 
		{
			availablePartition.push(Pool.atlasPartitions.request().init(index + i, startIndex + i, 0, 0, bufferWidth, bufferHeight));
		}
		activePartitions.clear();
	}
	
	public function pack(startIndex:Int):Int
	{
		//trace("index = " + index);
		//trace("Core.atlasDrawOrder.textureDefs.length = " + Core.atlasDrawOrder.textureDefs.length);
		orderTo = 0;
		
		var i:Int = startIndex;
		while (i < Core.atlasDrawOrder.textureDefs.length)
		{
			var textureData:ITextureData = Core.atlasDrawOrder.textureDefs[i].textureData;
			if (textureData.directRender == 1) {
				i++;
				continue;
			}
			//trace([textureData.textureId, textureData.placed]);
			
			var placedSuccessfully:Bool = place(textureData);
			//trace("i = " + i + " placedSuccessfully = " + placedSuccessfully);
		
			if (placedSuccessfully) {
				i++;
			}
			else {
				
				if (!findInactivePartitions()) {
					return i;
				}
				
				
				// THIS ALL NEEDS TO BE RETESTED!!! /////////////
				/////////////////////////////////////////////////
				//if (orderTo == i || orderTo != -1) {
					//// Re-ordering didn't help
					//trace("Re-ordering didn't help: " + i);
					////i++; // should now move to next sheet
					//
					//drawActive();
					//return i;
				//}
				//else {
					//trace("Re-order: " + orderTo);
					//orderTo = i;
					//reorderToBetween(Core.atlasDrawOrder.textureDefs, startIndex, orderTo);
					//
					//clear();
					//i = startIndex;
				//}
				/////////////////////////////////////////////////
				/////////////////////////////////////////////////
			}
		}
		
		drawActive();
		
		return i;
	}
	
	function findInactivePartitions():Bool
	{
		var i:Int = 0;
		while (i < activePartitions.length) 
		{
			//trace("activePartitions.length = " + activePartitions.length);
			var activePartition:AtlasPartition = activePartitions[i];
			activePartition.active = false;
			for (j in 0...Core.atlasDrawOrder.textureDefs.length) 
			{
				if (Core.atlasDrawOrder.textureDefs[j].textureId == activePartition.textureData.textureId) {
					activePartition.active = true;
					break;
				}
			}
			
			if (activePartition.active == false) {
				trace("Inactive Partitions Found");
				activePartitions.splice(i, 1);
				activePartition.clear();
				availablePartition.push(activePartition);
				return true;
			}
			else {
				i++;
			}
		}
		return false;
	}
	
	function drawActive() 
	{
		activePartitions.sort(function(a1:AtlasPartition, a2:AtlasPartition):Int
		{
			if (a1.atlasIndex > a2.atlasIndex) return 1;
			if (a1.atlasIndex < a2.atlasIndex) return -1;
			else return 0;
		});
		
		for (i in 0...activePartitions.length) 
		{
			//trace("atlasIndex = " + activePartitions[i].atlasIndex);
			AtlasPartitionRenderer.add(activePartitions[i]);
		}
	}
	
	function reorderToBetween(textureOrder:GcoArray<TextureDef>, startIndex:Int, endIndex:Int) 
	{
		var ordered:Array<TextureDef> = [];
		
		for (i in startIndex...endIndex) 
		{
			ordered.push(textureOrder[i]);
		}
		
		ordered.sort(function(a1:TextureDef, a2:TextureDef):Int
		{
			if (a1.textureData.area > a2.textureData.area) return -1;
			if (a1.textureData.area < a2.textureData.area) return 1;
			else return 0;
		});
		
		for (j in 0...ordered.length) 
		{
			textureOrder[startIndex + j] = ordered[j];
		}
	}
	
	function place(textureData:ITextureData):Bool
	{
		if (alreadyPlaced(textureData)) {
			return true;
		}
		
		for (i in 0...availablePartition.length) 
		{
			var partition:AtlasPartition = availablePartition[i];
			
			var successfulPlacement:Bool = AtlasPartitionPlacer.place(partition, textureData);
			
			if (successfulPlacement) {
				
				textureData.placed = 1;
				textureData.x = partition.x;
				textureData.y = partition.y;
				textureData.width = partition.width;
				textureData.height = partition.height;
				textureData.p2Width = SheetPacker.bufferWidth;
				textureData.p2Height = SheetPacker.bufferHeight;
				textureData.atlasTextureId = partition.atlasTextureId;
				textureData.atlasBatchTextureIndex = partition.atlasIndex;
				//trace("partition.atlasIndex = " + partition.atlasIndex);
				
				//trace([textureData.x, textureData.y, textureData.width, textureData.height]);
				
				partition.textureData = textureData;
				if (partition.rightPartition != null) addPartition(partition.rightPartition, i + 1);
				if (partition.bottomPartition != null) addPartition(partition.bottomPartition, i + 1);
				
				activePartitions.push(partition);
				availablePartition.splice(i, 1);
				
				return true;
			}
		}
		return false;
	}
	
	function alreadyPlaced(textureData:ITextureData) 
	{
		if (textureData.placed == 1) return true;
		if (textureData.textureAvailable == 0) return true;
		return false;
	}
	
	function addPartition(partition:AtlasPartition, insertAt:Int) 
	{
		availablePartition.insert(insertAt, partition);
		//for (i in 0...availablePartition.length) 
		//{
			//if (availablePartition[i].height > partition.height) {
				//availablePartition.insert(i, partition);
				//return;
			//}
		//}
		//
		//availablePartition.push(partition);
	}
	
	public function setVertexData() 
	{
		for (j in 0...activePartitions.length) 
		{
			AtlasPartitionRenderer.setVertexData(activePartitions[j]);
		}
	}
}