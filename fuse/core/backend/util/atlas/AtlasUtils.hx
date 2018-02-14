package fuse.core.backend.util.atlas;
import fuse.core.communication.data.textureData.ITextureData;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasUtils
{

	public function new() 
	{
		
	}
	
	public static inline function alreadyPlaced(textureData:ITextureData) 
	{
		if (textureData.placed == 1) return true;
		if (textureData.textureAvailable == 0) return true;
		return false;
	}
}