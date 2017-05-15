package kea.logic.buffers.atlas.packer;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.buffers.atlas.packer.AtlasPartition;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasPartition
{
	var rightPartition:AtlasPartition;
	var bottomPartition:AtlasPartition;
	var placementReturn:PlacementReturn;
	public var key:Int;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	static function __init__():Void
	{
		
	}
	
	public function new(key:Int, x:Int, y:Int, width:Int, height:Int) 
	{
		this.key = key;
		
		placementReturn = { successful:false };
		init(x, y, width, height);
		
	}
	
	public function init(x:Int, y:Int, width:Int, height:Int) 
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.rightPartition = null;
		this.bottomPartition = null;
		
		placementReturn.successful = false;
		placementReturn.rightPartition = null;
		placementReturn.bottomPartition = null;
	}
	
	public function place(atlasItem:AtlasItem):PlacementReturn
	{
		placementReturn.successful = false;
		
		if (atlasItem.width <= width && atlasItem.height <= height) {
			placementReturn.successful = true;
			//placementReturn.newPartitions = [];
			placementReturn.rightPartition = null;
			placementReturn.bottomPartition = null;
			
			placementReturn.rightPartition = getRightPartition(atlasItem);
			
			placementReturn.bottomPartition = getBottomPartition(atlasItem);
			
			this.width = atlasItem.width;
			this.height = atlasItem.height;
			
			if (atlasItem.partition.value != null) {
				AtlasPartitionPool.release(atlasItem.partition.value);
			}
			atlasItem.partition.value = AtlasPartitionPool.allocate(this.x, this.y, this.width, this.height);
		}
		return placementReturn;
	}
	
	function getRightPartition(atlasItem:AtlasItem):AtlasPartition
	{
		if (atlasItem.width < width) {
			/*if (height > width){
				return new AtlasPartition(
					this.x + atlasItem.width,
					this.y,
					this.width - atlasItem.width,
					atlasItem.height
				);
			}
			else {*/
				return AtlasPartitionPool.allocate(
					this.x + atlasItem.width,
					this.y,
					this.width - atlasItem.width,
					this.height
				);
				/*return new AtlasPartition(0, 
					this.x + atlasItem.width,
					this.y,
					this.width - atlasItem.width,
					this.height
				);*/
			//}
		}
		return null;
	}
	
	function getBottomPartition(atlasItem:AtlasItem):AtlasPartition
	{
		if (atlasItem.height < height) {
			/*if (height > width){
				return new AtlasPartition(
					this.x,
					this.y + atlasItem.height,
					this.width,
					this.height - atlasItem.height
				);
			}
			else {*/
				return AtlasPartitionPool.allocate(
					this.x,
					this.y + atlasItem.height,
					atlasItem.width,
					this.height - atlasItem.height
				);
				/*return new AtlasPartition(0, 
					this.x,
					this.y + atlasItem.height,
					atlasItem.width,
					this.height - atlasItem.height
				);*/
			//}
		}
		return null;
	}
	
}

typedef PlacementReturn =
{
	successful:Bool,
	//?newPartitions:Array<AtlasPartition>
	?rightPartition:AtlasPartition,
	?bottomPartition:AtlasPartition
}