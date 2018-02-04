package fuse.core.assembler;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.atlas.AtlasBufferAssembler;
import fuse.core.assembler.input.InputAssembler;
import fuse.core.assembler.layers.LayerBufferAssembler;
import fuse.core.assembler.batches.BatchAssembler;
import fuse.core.assembler.layers.sort.SortLayers;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.Core;
import fuse.utils.GcoArray;

/**
    This class is called every frame and is responsible for assembling stage3d display data.
**/
class Assembler
{
	public function new() { }
	
	static public function init() 
	{
		//SortLayers.init();
	}
	
	public static function update() 
	{
		Core.textures.checkForTextureChanges();
		Core.displayList.checkForDisplaylistChanges();
		
		HierarchyAssembler.build();
		AtlasBufferAssembler.build();
		LayerBufferAssembler.build();
		BatchAssembler.build();	
		VertexWriter.build();
		BatchAssembler.findMaxNumTextures();
		
		InputAssembler.build();
		Core.textures.reset();
		
		Core.RESIZE = false;
		Fuse.current.conductorData.isStatic = 1;
	}
}