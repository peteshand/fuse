package fuse.core.assembler.atlas.sheet;
import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.AtlasSheet;
import fuse.core.assembler.atlas.textures.AtlasTextures;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheets
{
	public static var partitions = new GcoArray<AtlasPartition>([]);
	
	public static var sheets:Array<AtlasSheet>;
	public static var numAtlases:Int;
	public static var startIndex:Int;
	public static var active:Bool = false;
	
	
	static function __init__() 
	{
		sheets = [];
		numAtlases = 4;
		startIndex = 2;
		
		for (i in 0...numAtlases) 
		{
			sheets.push(new AtlasSheet(i));
		}
	}
	
	static function clear() 
	{
		partitions.clear();
		
		for (i in 0...sheets.length) 
		{
			sheets[i].clear();
		}
	}
	
	static public function build() 
	{
		active = true;
		
		clear();
		
		for (k in 0...AtlasTextures.textures.length) 
		{
			for (i in 0...sheets.length) 
			{
				var successfulPlacement:Bool = sheets[i].add(AtlasTextures.textures[k]);
				if (successfulPlacement) {
					break;
				}
			}
		}
		
		for (j in 0...sheets.length) 
		{
			sheets[j].writeActivePartitions();
		}
	}
	
	static public function closePartitions() 
	{
		for (i in 0...partitions.length) 
		{
			partitions[i].placed = true;
			partitions[i].coreTexture.textureData.placed = 1;
		}
	}
}