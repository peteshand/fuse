package fuse.texture;

import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.texture.ITexture;
import fuse.utils.PowerOfTwo;

import openfl.display3D.textures.TextureBase;
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
	
	var p2Width:Int;
	var p2Height:Int;
	var _clear:Bool = false;
	var textureData:ITextureData;
	var onTextureUploadCompleteCallback:Void-> Void;
	var persistent:Int;
	
	public var textureId:Int;
	public var width:Int;
	public var height:Int;
	public var name:String;
	public var red:Float = 0;
	public var green:Float = 0;
	public var blue:Float = 0;
	public var textureBase:TextureBase;
	public var nativeTexture:NativeTexture;
	@:isVar public var directRender(get, set):Bool;
	
	public function new(queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null, p2Texture:Bool=true) 
	{
		this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		textureId = textureIdCount++;
		textureData = new TextureData(textureId);
		
		if (p2Texture){
			p2Width = PowerOfTwo.getNextPowerOfTwo(width);
			p2Height = PowerOfTwo.getNextPowerOfTwo(height);
		}
		else {
			p2Width = width;
			p2Height = height;
		}
		
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
		textureData.persistent = persistent;
		
		Fuse.current.workerSetup.addTexture(textureId);
		
		if (queUpload) TextureUploadQue.add(this);
		else upload();
	}
	
	function createNativeTexture()
	{
		textureBase = nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false, 0);
		return textureBase;
	}
	
	function upload() 
	{
		throw new Error("This function should be overriden");
	}
	
	public function dispose():Void
	{
		Fuse.current.workerSetup.removeTexture(textureId);
		Textures.deregisterTexture(textureId, this);
		if (textureBase != null) {
			textureBase.dispose();
			textureBase = null;
		}
	}
	
	function get_directRender():Bool 
	{
		return directRender;
	}
	
	function set_directRender(value:Bool):Bool 
	{
		if (directRender == value) return value;
		directRender = value;
		if (directRender) textureData.directRender = 1;
		else textureData.directRender = 0;
		return directRender;
	}
}