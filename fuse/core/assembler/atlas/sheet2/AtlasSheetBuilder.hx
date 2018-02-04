package fuse.core.assembler.atlas.sheet2;
import fuse.core.assembler.atlas.partition.AtlasPartitions;
import fuse.core.assembler.atlas.textures.AtlasTextures;
import fuse.core.backend.texture.CoreTexture;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasSheetBuilder
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
		var j:Int = 0;
		while (j < AtlasTextures.textures.length - 1) 
		{
			var successfullyAdded:Bool = addTexture(AtlasTextures.textures[j]);
			if (successfullyAdded
			j++;
		}
		
	}
	
	static function addTexture(texture:CoreTexture) 
	{
		
	}
}