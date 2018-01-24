package fuse.core.backend.display;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.utils.Pool;
import fuse.display.geometry.Bounds;
import fuse.utils.Rect;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse.texture)
class CoreMovieClip extends CoreImage implements ICoreRenderable
{
	public function new() 
	{
		super();
	}
	
	override function set_textureId(value:Int):Int {
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
			
			updateUVs = 0;
		}
		return value;
	}
}