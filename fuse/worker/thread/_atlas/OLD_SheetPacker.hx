package fuse.worker.thread._atlas;

import fuse.core.atlas.packer.AtlasPartition;
import fuse.core.atlas.packer.AtlasPartitionPool;
import fuse.core.memory.data.textureData.ITextureData;
import fuse.core.memory.data.textureData.TextureData;
import fuse.worker.thread.display.TextureOrder;

/**
 * ...
 * @author P.J.Shand
 */
class OLD_SheetPacker
{
	var textureOrder:TextureOrder;
	var index:Int;
	var orderTo:Int = -1;
	var partitions:Array<AtlasPartition> = [];
	
	public function new(textureOrder:TextureOrder, index:Int) 
	{
		this.index = index;
		this.textureOrder = textureOrder;
		
		clearPartitions();
	}
	
	public function pack(startIndex:Int) 
	{
		//textureAtlas.active = true;
		
		//clearPartitions();
		
		
		orderTo = 0;
		
		var i:Int = startIndex;
		while (i < textureOrder.textureDataArray.length)
		{
			var textureData:ITextureData = textureOrder.textureDataArray[i];
			textureData.atlasIndex = index;
			
			var placedSuccessfully:Bool = place(textureOrder.textureDataArray[i]);
			if (placedSuccessfully) {
				i++;
			}
			else {
				if (orderTo == i || orderTo != -1) {
					// Re-ordering didn't help
					//trace("Re-ordering didn't help: " + i);
					//i++; // should now move to next sheet
					return i;
				}
				else {
					//trace("Re-order: " + orderTo);
					orderTo = i;
					reorderToBetween(textureOrder.textureDataArray, startIndex, orderTo);
					clearPartitions();
					i = startIndex;
				}
				//trace(["placedSuccessfully = " + placedSuccessfully, i]);
			}
		}
		return i;
	}
	
	function clearPartitions() 
	{
		for (i in 0...partitions.length) 
		{
			//AtlasPartitionPool.release(partitions[i]);
		}
		partitions = /*textureAtlas.partitions =*/ [AtlasPartitionPool.allocate(0, 0, 1024, 1024)];
	}
	
	function reorderToBetween(textureOrder:Array<TextureData>, startIndex:Int, endIndex:Int) 
	{
		var ordered:Array<TextureData> = [];// textureOrder.textureOrder.concat([]);
		//ordered = ordered.splice(startIndex, endIndex);
		
		for (i in startIndex...endIndex) 
		{
			ordered.push(textureOrder[i]);
		}
		
		ordered.sort(function(a1:ITextureData, a2:ITextureData):Int
		{
			if (a1.area > a2.area) return -1;
			if (a1.area < a2.area) return 1;
			else return 0;
		});
		
		for (j in 0...ordered.length) 
		{
			textureOrder[startIndex + j] = ordered[j];
		}
	}
	
	function place(textureData:ITextureData):Bool
	{
		if (textureData.placed) {
			return true; // already placed
		}
		
		for (i in 0...partitions.length) 
		{
			var partition:AtlasPartition = partitions[i];
			var placementReturn:PlacementReturn = partition.place(textureData);
			if (placementReturn.successful) {
				
				//textureData.atlasTexture = textureAtlas.texture;
				textureData.atlasX = partition.x;
				textureData.atlasY = partition.y;
				textureData.atlasWidth = partition.width;
				textureData.atlasHeight = partition.height;
				
				textureData.atlasIndex = index;
				
				trace([partition.x, partition.y, partition.width, partition.height]);
				partitions.splice(i, 1);
				
				if (placementReturn.rightPartition != null) addPartition(placementReturn.rightPartition);
				if (placementReturn.bottomPartition != null) addPartition(placementReturn.bottomPartition);
				
				/*for (j in 0...placementReturn.newPartitions.length) 
				{
					addPartition(placementReturn.newPartitions[j]);
				}*/
				textureData.placed = true;
				return true;
			}
			else {
				
			}
		}
		return false;
	}
	
	function addPartition(partition:AtlasPartition) 
	{
		for (i in 0...partitions.length) 
		{
			if (partitions[i].height > partition.height) {
				partitions.insert(i, partition);
				return;
			}
		}
		
		partitions.push(partition);
	}
	
}