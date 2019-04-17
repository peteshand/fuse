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
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.CoreTextures;
import fuse.utils.GcoArray;
import notifier.Notifier;

/**
    This class is called every frame and is responsible for assembling stage3d display data.
**/
class Assembler
{
	static var backIsStatic = new Notifier<Int>();
	
	public function new() { }
	
	static public function init() 
	{
		backIsStatic.add(OnBackIsStaticChange);
	}
	
	public static function update() 
	{
		if (Core.displayList.stage == null) return;
		
		if (Fuse.current.conductorData.backIsStatic == 0 || Fuse.current.conductorData.frontStaticCount <= 0) {
			Fuse.current.conductorData.changeAvailable = 1;
		}
		else {
			Fuse.current.conductorData.changeAvailable = 0;
		}
		
		Fuse.current.conductorData.backIsStatic = 1;
		
		Core.textures.checkForTextureChanges();
		Core.displayList.checkForDisplaylistChanges();
		
		HierarchyAssembler.build();
		AtlasBufferAssembler.build();
		
		/*var a:Array<Dynamic> = [
			Fuse.current.conductorData.changeAvailable,
			Fuse.current.conductorData.backIsStatic,
			Fuse.current.conductorData.frontStaticCount,
			HierarchyAssembler.hierarchy.length, 
			DisplayList.hierarchyBuildRequired,
			CoreTextures.texturesHaveChanged,
			Fuse.current.conductorData.backIsStatic
		];
		trace(a);*/
		//trace("HierarchyAssembler.hierarchy.length = " + HierarchyAssembler.hierarchy.length);
		//trace("DisplayList.hierarchyBuildRequired = " + DisplayList.hierarchyBuildRequired);
		//trace("CoreTextures.texturesHaveChanged = " + CoreTextures.texturesHaveChanged);
		//trace("Fuse.current.conductorData.backIsStatic = " + Fuse.current.conductorData.backIsStatic);
		
		if (Fuse.current.conductorData.backIsStatic == 0){
			LayerBufferAssembler.build();
			BatchAssembler.build();	
			VertexWriter.build();
			BatchAssembler.findMaxNumTextures();
		}
		backIsStatic.value = Fuse.current.conductorData.backIsStatic;
		
		AtlasBufferAssembler.closePartitions();
		
		InputAssembler.build();
		Core.textures.reset();
		
		Core.RESIZE = false;
		
		if (Fuse.current.conductorData.backIsStatic == 0 || Fuse.current.conductorData.frontStaticCount <= 0) {
			Fuse.current.conductorData.changeAvailable = 1;
		}

		CoreTextures.texturesHaveChanged = false;
	}
	
	static function OnBackIsStaticChange()
	{
		if (Fuse.current.conductorData.backIsStatic == 1){
			//trace("switch to static");
			//BatchAssembler.clearNonDirect();
			
			//VertexWriter.build();
			//BatchAssembler.findMaxNumTextures();
			
			LayerBufferAssembler.build();
			BatchAssembler.build();	
			VertexWriter.build();
			BatchAssembler.findMaxNumTextures();
		}
	}
}