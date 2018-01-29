package fuse.core.assembler.atlas.sheet;
import fuse.core.assembler.atlas.partition.AtlasPartition;
import fuse.core.assembler.atlas.partition.AtlasPartitions;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheets
{
	public static var sheets:Array<AtlasSheet>;
	
	static function __init__() 
	{
		sheets = [];
		
		for (i in 0...AtlasPartitions.numAtlases) 
		{
			sheets.push(new AtlasSheet(i));
		}
	}
	
	static public function build() 
	{
		for (i in 0...sheets.length) 
		{
			for (j in 0...AtlasPartitions.activePartitions.length) 
			{
				var atlasPartition:AtlasPartition = AtlasPartitions.activePartitions[j];
				if (sheets[i].atlasIndex == atlasPartition.atlasIndex) {
					sheets[i].add(atlasPartition);
				}
			}
		}
		
	}
	
}