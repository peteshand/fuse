package fuse.texture;

import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;
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
	public var red:Float = 0;
	public var green:Float = 0;
	public var blue:Float = 0;
	
	var textureData:ITextureData;
	var onTextureUploadCompleteCallback:Void-> Void;
	public var nativeTexture:NativeTexture;
	
	public function new(queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		textureId = textureIdCount++;
		textureData = new TextureData(textureId);
		
		trace(this);
		trace("textureId = " + textureId);
		
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
		
		Fuse.current.workers.addTexture(textureId);
		
		if (queUpload) TextureUploadQue.add(this);
		else upload();
	}
	
	function createNativeTexture() 
	{
		nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false, 0);
		return nativeTexture;
	}
	
	function upload() 
	{
		throw new Error("This function should be overriden");
	}
	
	public function dispose():Void
	{
		Fuse.current.workers.removeTexture(textureId);
		Textures.deregisterTexture(textureId, this);
		if (nativeTexture != null) {
			nativeTexture.dispose();
			nativeTexture = null;
		}
	}
}