package fuse.core.assembler;
import fuse.core.assembler.atlas.AtlasBufferAssembler;
import fuse.core.assembler.batches.BatchAssembler;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.layers.LayerBufferAssembler;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreImage;
import fuse.utils.GcoArray;

/**
    This class is called every frame and is responsible for assembling stage3d display data.
**/
class Assembler2
{
	public var hierarchy = new GcoArray<CoreImage>([]);
	public var transformActions = new GcoArray<Void -> Void>([]);
	
	public function new() { }
	
	public static function update() 
	{
		// var numNewTextures:Int = 
		// var numChangedTextures:Int = 
		// var hierarchyHasChanged:Bool = 
		// var numDisplaysHaveChanged:Int = 
		
		/*
		 * Build Hierarchy
		 * Build Atlas Buffers
		 * Write Layer VertexData
		 * Build Layer Buffers
		 * Write Layer VertexData
		 * Build Batches
		 * Write VertexData
		*/
		
		Core.textures.checkForTextureChanges();
		Core.displayList.checkForDisplaylistChanges();
		
		HierarchyAssembler.build();
		AtlasBufferAssembler.build();
		LayerBufferAssembler.build();
		BatchAssembler.build();	
		VertexWriter.build();
	}
}