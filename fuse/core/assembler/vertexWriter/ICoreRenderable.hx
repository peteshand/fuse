package fuse.core.assembler.vertexWriter;

import fuse.core.backend.texture.CoreTexture;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;

/**
 * @author P.J.Shand
 */
interface ICoreRenderable {
	var objectId:ObjectId;
	var coreTexture:CoreTexture;
	var textureIndex(get, set):Int;
	var blendMode:Int;
	var shaderId:Int;
	var sourceTextureId(get, null):TextureId;
}
