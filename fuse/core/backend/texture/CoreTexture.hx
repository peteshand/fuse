package fuse.core.backend.texture;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;

/**
 * ...
 * @author P.J.Shand
 */
class CoreTexture
{
	public var textureId:Int;
	public var textureData:ITextureData;
	public var activeCount:Int = 0;
	
	public var uvLeft	:Float = 0;
	public var uvTop	:Float = 0;
	public var uvRight	:Float = 1;
	public var uvBottom	:Float = 1;
	
	public function new(textureId:Int) 
	{
		this.textureId = textureId;
		textureData = new TextureData(textureId);
	}
	
	public function updateUVData() 
	{
		uvLeft = textureData.x / textureData.p2Width;
		uvTop = textureData.y / textureData.p2Height;
		uvRight = (textureData.x + textureData.width) / textureData.p2Width;
		uvBottom = (textureData.y + textureData.height) / textureData.p2Height;
	}
	
	public function checkForUpdate():Bool
	{
		if (textureData.placed == 0) return true;
		return false;
	}
}