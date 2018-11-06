package fuse.core.backend.display;

import fuse.utils.ObjectId;
import fuse.core.backend.displaylist.DisplayType;
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
		this.displayType = DisplayType.MOVIECLIP;
	}
	
	override function set_textureId(value:ObjectId):ObjectId {
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				Core.textures.deregister(coreTexture.textureData.baseData.objectId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.baseData.objectId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
		}
		return value;
	}
}