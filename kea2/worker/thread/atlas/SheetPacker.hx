package kea2.worker.thread.atlas;

import kea2.core.atlas.packer.AtlasPartition;
import kea2.core.atlas.packer.AtlasPartitionPool;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.AtlasVertexData;
import kea2.utils.GcoArray;
import kea2.worker.thread.display.TextureOrder;

/**
 * ...
 * @author P.J.Shand
 */
class SheetPacker
{
	var index:Int;
	var orderTo:Int = -1;
	var partitions:Array<AtlasPartition> = [];
	var atlasVertexData:AtlasVertexData;
	
	public function new(index:Int) 
	{
		this.index = index;
		
		atlasVertexData = new AtlasVertexData();
		clearPartitions();
	}
	
	public function pack(startIndex:Int) 
	{
		//textureAtlas.active = true;
		
		//clearPartitions();
		
		
		orderTo = 0;
		
		var i:Int = startIndex;
		while (i < WorkerCore.textureOrder.textureDefArray.length)
		{
			var textureData:TextureData = WorkerCore.textureOrder.textureDefArray[i].textureData;
			textureData.atlasIndex = index;
			
			var placedSuccessfully:Bool = place(textureData);
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
					reorderToBetween(WorkerCore.textureOrder.textureDefArray, startIndex, orderTo);
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
		partitions = /*textureAtlas.partitions =*/ [AtlasPartitionPool.allocate(0, 0, 2048, 2048)];
	}
	
	function reorderToBetween(textureOrder:GcoArray<TextureDef>, startIndex:Int, endIndex:Int) 
	{
		var ordered:Array<TextureDef> = [];// textureOrder.textureOrder.concat([]);
		//ordered = ordered.splice(startIndex, endIndex);
		
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
	
	function place(textureData:TextureData):Bool
	{
		if (textureData.placed) {
			return true; // already placed
		}
		
		for (i in 0...partitions.length) 
		{
			trace("i = " + i);
			
			var partition:AtlasPartition = partitions[i];
			trace("partition.key = " + partition.key);
			var placementReturn:PlacementReturn = partition.place(textureData);
			if (placementReturn.successful) {
				
				//textureData.atlasTexture = textureAtlas.texture;
				textureData.atlasX = partition.x;
				textureData.atlasY = partition.y;
				textureData.atlasWidth = partition.width;
				textureData.atlasHeight = partition.height;
				
				textureData.atlasIndex = index;
				
				setVertexData(partition);
				
				
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
	
	function setVertexData(partition:AtlasPartition) 
	{
		trace("partition = " + partition);
		trace("AtlasVertexData.OBJECT_POSITION = " + AtlasVertexData.OBJECT_POSITION);
		
		// Where to sample from source texture
		// BOTTOM LEFT
		atlasVertexData.u1 = 0;// (partition.x) / 2048;
		atlasVertexData.v1 = 1;// (partition.y + partition.height) / 2048;
		
		// TOP LEFT
		atlasVertexData.u2 = 0;// (partition.x) / 2048;
		atlasVertexData.v2 = 0;// (partition.y) / 2048;
		
		// TOP RIGHT
		atlasVertexData.u3 = 1;// (partition.x + partition.width) / 2048;
		atlasVertexData.v3 = 0;// (partition.y) / 2048;
		
		// BOTTOM RIGHT
		atlasVertexData.u4 = 1;// (partition.x + partition.width) / 2048;
		atlasVertexData.v4 = 1;// (partition.y + partition.height) / 2048;
		
		// Where to draw on destination texture
		// BOTTOM LEFT
		atlasVertexData.x1 = (partition.x) / 2048;
		atlasVertexData.y1 = (partition.y + partition.height) / 2048;
		
		// TOP LEFT
		atlasVertexData.x2 = (partition.x) / 2048;
		atlasVertexData.y2 = (partition.y) / 2048;
		
		// TOP RIGHT
		atlasVertexData.x3 = (partition.x + partition.width) / 2048;
		atlasVertexData.y3 = (partition.y) / 2048;
		
		// BOTTOM RIGHT
		atlasVertexData.x4 = (partition.x + partition.width) / 2048;
		atlasVertexData.y4 = (partition.y + partition.height) / 2048;
		
		//atlasVertexData
		
		AtlasVertexData.OBJECT_POSITION++;
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