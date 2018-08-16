package fuse.core.backend.display;

import fuse.core.assembler.vertexWriter.ICoreRenderable;

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
				Core.textures.deregister(coreTexture.textureData.baseData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.baseData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
			
			//updateUVs = true;
		}
		return value;
	}
}