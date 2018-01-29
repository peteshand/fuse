package fuse.core.assembler.atlas.sheet;
import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.atlas.partition.AtlasPartitions;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheet
{
	static var count:Int = 0;
	
	
	public var index:Int;
	//var ids:Array<Int> = [];
	public var atlasIndex:Int;
	//var id(get, null):Int;
	var partitions:Array<AtlasPartition> = [];
	
	public function new(index:Int) 
	{
		this.index = index;
		atlasIndex = AtlasPartitions.startIndex + index;
		//ids.push(AtlasPartitions.startIndex + (index * 2));
		//ids.push(AtlasPartitions.startIndex + (index * 2) + 1);
		
	}
	
	public function add(partition:AtlasPartition) 
	{
		for (i in 0...partitions.length) 
		{
			if (partitions[i].textureId == partition.textureId) {
				
				return;
			}
		}
		
		partitions.push(partition);
	}
	
	//function get_id():Int 
	//{
		//return ids[count % ids.length];
	//}
}