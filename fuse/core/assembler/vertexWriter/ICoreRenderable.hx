package fuse.core.assembler.vertexWriter;
import fuse.core.backend.texture.CoreTexture;

/**
 * @author P.J.Shand
 */
interface ICoreRenderable 
{
	var coreTexture:CoreTexture;
	var textureIndex:Int;
	//function writeVertex():Void;
}