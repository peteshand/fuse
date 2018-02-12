package fuse.core.assembler.layers.layer;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.backend.Core;
import fuse.core.backend.texture.CoreTexture;

/**
 * ...
 * @author P.J.Shand
 */
class LayerCacheRenderable implements ICoreRenderable
{
	public var objectId:Int = -1;
	@:isVar public var textureId(get, set):Int = -1;
	public var coreTexture:CoreTexture;
	public var textureIndex:Int;
	public var sourceTextureId(get, null):Int;
	
	public function new(textureId:Int) 
	{
		this.textureId = textureId;
	}
	
	inline function get_textureId():Int { return textureId; }
	
	function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				coreTexture = Core.textures.register(textureId);
			}
		}
		return value;
	}
	
	function get_sourceTextureId():Int 
	{
		return coreTexture.textureId;
	}
}