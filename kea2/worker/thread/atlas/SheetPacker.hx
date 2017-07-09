package kea2.worker.thread.atlas;

import kea2.core.atlas.packer.AtlasPartition;
import kea2.core.atlas.packer.AtlasPartitionPool;
import kea2.core.memory.data.textureData.ITextureData;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.IVertexData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.texture.RenderTexture;
import kea2.utils.GcoArray;
import kea2.worker.thread.atlas.partition.PartitionRenderable;
import kea2.worker.thread.display.TextureOrder;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.pool.ObjectPool;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class SheetPacker
{
	static var bufferWidth:Int = 2048;
	static var bufferHeight:Int = 2048;
	var index:Int;
	var textureId:Int;
	
	var orderTo:Int = -1;
	var partitions:Array<AtlasPartition> = [];
	var vertexData:IVertexData;
	//var atlasTextureData:TextureData;
	
	public function new(index:Int, textureId:Int) 
	{
		this.index = index;
		this.textureId = textureId;
		
		//trace(["SheetPacker", index, textureId]);
		vertexData = new VertexData();
		//atlasTextureData = new TextureData(index + 1);
		clearPartitions();
	}
	
	public function pack(startIndex:Int) 
	{
		//textureAtlas.active = true;
		
		//clearPartitions();
		
		
		orderTo = 0;
		
		var i:Int = startIndex;
		while (i < WorkerCore.atlasTextureDrawOrder.textureDefArray.length)
		{
			//trace("i = " + i);
			var textureData:ITextureData = WorkerCore.atlasTextureDrawOrder.textureDefArray[i].textureData;
			//textureData.atlasIndex = index;
			
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
					reorderToBetween(WorkerCore.atlasTextureDrawOrder.textureDefArray, startIndex, orderTo);
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
		partitions = /*textureAtlas.partitions =*/ [AtlasPartitionPool.allocate(0, 0, bufferWidth, bufferHeight)];
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
	
	function place(textureData:ITextureData):Bool
	{
		if (textureData.placed || textureData.textureAvailable == 0) {
			return true;
		}
		trace("place");
		for (i in 0...partitions.length) 
		{
			//trace("i = " + i);
			
			var partition:AtlasPartition = partitions[i];
			//trace("partition.key = " + partition.key);
			var placementReturn:PlacementReturn = partition.place(textureData);
			if (placementReturn.successful) {
				
				//textureData.atlasTexture = textureAtlas.texture;
				//textureData.atlasX = partition.x;
				//textureData.atlasY = partition.y;
				
				textureData.x = partition.x;
				textureData.y = partition.y;
				textureData.width = partition.width;
				textureData.height = partition.height;
				textureData.p2Width = SheetPacker.bufferWidth;// partition.width;
				textureData.p2Height = SheetPacker.bufferHeight;// partition.height;
				
				//textureData.partition.value = partition;
				
				
				
				textureData.atlasTextureId = this.textureId;
				textureData.atlasBatchTextureIndex = this.index;
				
				var partitionRenderable:PartitionRenderable = new PartitionRenderable(partition, textureData);
				AtlasPacker.partitionRenderables.push(partitionRenderable);
				
				//setVertexData(partition, textureData);
				
				
				//trace([partition.x, partition.y, partition.width, partition.height]);
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
	
	//function setVertexData(partition:AtlasPartition, textureData:ITextureData) 
	//{
		////return;
		//
		//
	//}
	
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