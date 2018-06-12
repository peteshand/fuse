package fuse.core.assembler.layers;
//import fuse.core.assembler.layers.changed.LayersHaveChanged;
import fuse.core.assembler.layers.generate.GenerateLayers;
import fuse.core.assembler.layers.layer.LayerBuffer;
import fuse.core.assembler.layers.sort.SortLayers;
import fuse.core.backend.displaylist.DisplayList;
import fuse.core.backend.texture.CoreTextures;
import fuse.utils.GcoArray;

/**
    This class is called every frame and is responsible for finding groups of display 
	objects that are static and adding instructions to render these objects into a LayerBuffer, 
	which in turn is then rendered into a single quad.
**/
class LayerBufferAssembler
{
	static public function build() 
	{
		GenerateLayers.build();
		//SortLayers.build();
		
	}
}