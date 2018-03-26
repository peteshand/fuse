package fuse.core.assembler.vertexWriter;
import fuse.core.backend.texture.CoreTexture;

/**
 * @author P.J.Shand
 */
interface ICoreRenderable 
{
	var objectId:Int;
	var coreTexture:CoreTexture;
	//var textureIndex:Int;
	var textureIndex(get, set):Int;
	
	var sourceTextureId(get, null):Int;
}