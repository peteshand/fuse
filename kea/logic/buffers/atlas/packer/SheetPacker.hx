package kea.logic.buffers.atlas.packer;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.packer.AtlasPartition.PlacementReturn;
import kea.logic.buffers.atlas.renderer.TextureAtlas;

/**
 * ...
 * @author P.J.Shand
 */
class SheetPacker
{
	var orderTo:Int = -1;
	var index:Int;
	var textureAtlas:TextureAtlas;
	var partitions:Array<AtlasPartition> = [];
	
	public function new(atlasBuffer:AtlasBuffer, index:Int) 
	{
		//textureAtlas = atlasBuffer.getAtlas(index);
		textureAtlas = atlasBuffer.atlases[index];
		this.index = index;	
		
		clearPartitions();
	}
	
	public function pack(orderedlist:Array<AtlasItem>, startIndex:Int) 
	{
		textureAtlas.active = true;
		
		//clearPartitions();
		
		orderTo = 0;
		
		var i:Int = startIndex;
		while (i < orderedlist.length)
		{
			var atlasItem:AtlasItem = orderedlist[i];
			atlasItem.atlasIndex = index;
			
			var placedSuccessfully:Bool = place(orderedlist[i]);
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
					reorderToBetween(orderedlist, startIndex, orderTo);
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
		partitions = textureAtlas.partitions = [AtlasPartitionPool.allocate(0, 0, AtlasBuffer.TEMP_WIDTH, AtlasBuffer.TEMP_HEIGHT)];
	}
	
	function reorderToBetween(orderedlist:Array<AtlasItem>, startIndex:Int, endIndex:Int) 
	{
		var ordered:Array<AtlasItem> = [];// orderedlist.concat([]);
		//ordered = ordered.splice(startIndex, endIndex);
		
		for (i in startIndex...endIndex) 
		{
			ordered.push(orderedlist[i]);
		}
		
		ordered.sort(function(a1:AtlasItem, a2:AtlasItem):Int
		{
			if (a1.area > a2.area) return -1;
			if (a1.area < a2.area) return 1;
			else return 0;
		});
		
		for (j in 0...ordered.length) 
		{
			orderedlist[startIndex + j] = ordered[j];
		}
	}
	
	function place(atlasItem:AtlasItem):Bool
	{
		if (atlasItem.placed) {
			return true; // already placed
		}
		
		for (i in 0...partitions.length) 
		{
			var partition:AtlasPartition = partitions[i];
			var placementReturn:PlacementReturn = partition.place(atlasItem);
			if (placementReturn.successful) {
				
				atlasItem.atlasTexture = textureAtlas.texture;
				
				partitions.splice(i, 1);
				
				if (placementReturn.rightPartition != null) addPartition(placementReturn.rightPartition);
				if (placementReturn.bottomPartition != null) addPartition(placementReturn.bottomPartition);
				
				/*for (j in 0...placementReturn.newPartitions.length) 
				{
					addPartition(placementReturn.newPartitions[j]);
				}*/
				atlasItem.placed = true;
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