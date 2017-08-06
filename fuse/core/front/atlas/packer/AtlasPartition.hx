package fuse.core.front.atlas.packer;

import fuse.core.front.atlas.items.AtlasItem;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;

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
	
	public function place(textureData:ITextureData):PlacementReturn
	{
		placementReturn.successful = false;
		
		
		if (textureData.width <= width && textureData.height <= height) {
			placementReturn.successful = true;
			//placementReturn.newPartitions = [];
			placementReturn.rightPartition = null;
			placementReturn.bottomPartition = null;
			
			placementReturn.rightPartition = getRightPartition(textureData);
			
			placementReturn.bottomPartition = getBottomPartition(textureData);
			
			this.width = textureData.width;
			this.height = textureData.height;
			
			//if (textureData.partition.value != null) {
			//	AtlasPartitionPool.release(textureData.partition.value);
			//}
			//textureData.partition.value = AtlasPartitionPool.allocate(this.x, this.y, this.width, this.height);
		}
		return placementReturn;
	}
	
	function getRightPartition(textureData:ITextureData):AtlasPartition
	{
		if (textureData.width < width) {
			/*if (height > width){
				return new AtlasPartition(
					this.x + textureData.width,
					this.y,
					this.width - textureData.width,
					textureData.height
				);
			}
			else {*/
				return AtlasPartitionPool.allocate(
					this.x + textureData.width,
					this.y,
					this.width - textureData.width,
					this.height
				);
				/*return new AtlasPartition(0, 
					this.x + textureData.width,
					this.y,
					this.width - textureData.width,
					this.height
				);*/
			//}
		}
		return null;
	}
	
	function getBottomPartition(textureData:ITextureData):AtlasPartition
	{
		if (textureData.height < height) {
			/*if (height > width){
				return new AtlasPartition(
					this.x,
					this.y + textureData.height,
					this.width,
					this.height - textureData.height
				);
			}
			else {*/
				return AtlasPartitionPool.allocate(
					this.x,
					this.y + textureData.height,
					textureData.width,
					this.height - textureData.height
				);
				/*return new AtlasPartition(0, 
					this.x,
					this.y + textureData.height,
					textureData.width,
					this.height - textureData.height
				);*/
			//}
		}
		return null;
	}
	
	public function toString():String
	{
		return	"key = " + key + 
				" x = " + x + 
				" y = " + y + 
				" width = " + width + 
				" height = " + height;
	}
}

typedef PlacementReturn =
{
	successful:Bool,
	//?newPartitions:Array<AtlasPartition>
	?rightPartition:AtlasPartition,
	?bottomPartition:AtlasPartition
}