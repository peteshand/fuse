package fuse.core.assembler.atlas;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.atlas.sheet.AtlasSheet;
import fuse.core.assembler.atlas.sheet.placer.AtlasPartitionPlacer;
import fuse.core.assembler.atlas.sheet.AtlasSheets;
import fuse.core.assembler.atlas.textures.AtlasTextures;
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.texture.CoreTextures;
import fuse.core.backend.util.atlas.AtlasUtils;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.utils.Pool;
import fuse.utils.GcoArray;

/**
    This class is called every frame and is responsible for rendering textures into a dynamic texture atlas.
	This texture atlas is then used instead of the original texture. 
	This allows for far less draw calls once the initial copying is completed
**/
class AtlasBufferAssembler
{
	public function new() { }
	
	static public function build() 
	{
		AtlasSheets.active = false;
		
		if (DisplayList.hierarchyBuildRequired || CoreTextures.texturesHaveChanged) {
			AtlasTextures.build();
			AtlasSheets.build();
		}
	}
	
	static public function closePartitions() 
	{
		if (DisplayList.hierarchyBuildRequired || CoreTextures.texturesHaveChanged) {
			AtlasSheets.closePartitions();
		}
	}
}