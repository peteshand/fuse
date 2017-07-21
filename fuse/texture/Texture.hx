package fuse.texture;

import fuse.core.front.memory.data.textureData.ITextureData;
import fuse.core.front.memory.data.textureData.TextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.texture.ITexture;
import fuse.utils.PowerOfTwo;

import openfl.display3D.textures.Texture as NativeTexture;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class Texture implements ITexture
{
	static private var textureIdCount:Int = 0;
	
	public var textureId:Int;
	public var width:Int;
	public var height:Int;
	private var p2Width:Int;
	private var p2Height:Int;
	public var name:String;
	var _clear:Bool = false;
	
	var textureData:ITextureData;
	var onTextureUploadComplete:Void-> Void;
	public var nativeTexture:NativeTexture;
	
	public function new(queUpload:Bool=true, onTextureUploadComplete:Void -> Void = null) 
	{
		this.onTextureUploadComplete = onTextureUploadComplete;
		textureId = textureIdCount++;
		textureData = new TextureData(textureId);
		
		p2Width = PowerOfTwo.getNextPowerOfTwo(width);
		p2Height = PowerOfTwo.getNextPowerOfTwo(height);
		
		textureData.x = 0;
		textureData.y = 0;
		textureData.width = width;
		textureData.height = height;
		textureData.p2Width = p2Width;
		textureData.p2Height = p2Height;
		
		textureData.baseX = 0;
		textureData.baseY = 0;
		textureData.baseWidth = width;
		textureData.baseHeight = height;
		textureData.baseP2Width = p2Width;
		textureData.baseP2Height = p2Height;
		
		textureData.textureAvailable = 0;
		
		if (queUpload) TextureUploadQue.add(this);
		else upload();
	}
	
	function createNativeTexture() 
	{
		nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA_PACKED, false, 0);
		return nativeTexture;
	}
	
	function upload() 
	{
		throw new Error("This function should be overriden");
	}
	
}