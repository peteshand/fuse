package fuse.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.core.front.texture.Textures;
import fuse.display.Image;
import msignal.Signal.Signal0;
import fuse.texture.IBaseTexture;
import fuse.utils.Color;
import fuse.utils.PowerOfTwo;
import openfl.display.BitmapData;

import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class BaseTexture implements IBaseTexture
{
	//static private var textureIdCount:Int = 0;
	static public var overTextureId:Null<Int>;
	static public var textureIdCount:Int = 0;
	
	var p2Width:Int;
	var p2Height:Int;
	public var _clear:Bool = false;
	public var _alreadyClear:Bool = false;
	public var textureData:ITextureData;
	var onTextureUploadCompleteCallback:Void-> Void;
	var persistent:Int;
	var p2Texture:Bool;
	var uploadFromBitmapDataAsync:BitmapData -> UInt -> Void;
	
	public var textureId:Int;
	public var width:Null<Int>;
	public var height:Null<Int>;
	
	public var clearColour:Color = 0;
	@:isVar public var directRender(get, set):Bool = false;
	public var onUpdate = new Signal0();
	public var onUpload = new Signal0();
	
	public var nativeTexture(get, null):Texture;
	public var textureBase(get, null):TextureBase;
	
	public var dependantDisplays = new Map<Int, Image>();
	
	public function new(width:Int, height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null, p2Texture:Bool=true) 
	{
		if (overTextureId == null){
			this.textureId = BaseTexture.textureIdCount++;
		}
		else {
			this.textureId = BaseTexture.overTextureId;
			BaseTexture.overTextureId = null;
		}
		this.width = width;
		this.height = height;
		this.p2Texture = p2Texture;
		this.onTextureUploadCompleteCallback = onTextureUploadCompleteCallback;
		//textureId = textureIdCount++;
		textureData = CommsObjGen.getTextureData(textureId);
		
		setTextureData();
		Fuse.current.workerSetup.addTexture(textureId);
		
		if (queUpload) TextureUploadQue.add(this);
		else upload();
		
		Fuse.current.conductorData.frontStaticCount = 0;
		
		onUpdate.add(function() {
			for (image in dependantDisplays.iterator()) 
				image.OnTextureUpdate();
		});
	}
	
	function setTextureData() 
	{
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
		
		onUpdate.dispatch();
	}
	
	public function createNativeTexture()
	{
		setTextureData();
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false, 0);
		#if air
			try {
				uploadFromBitmapDataAsync = untyped textureData.nativeTexture["uploadFromBitmapDataAsync"];
			}
			catch (e:Dynamic) {
				
			}
			
		#else
			uploadFromBitmapDataAsync = Reflect.getProperty(textureData.nativeTexture, "uploadFromBitmapDataAsync");
		#end
		return textureData.textureBase;
	}
	
	public function upload() 
	{
		throw new Error("This function should be overriden");
	}
	
	public function dispose():Void
	{
		if (textureId <= 1) {
			// Can't dispose default textures
			return;
		}
		Fuse.current.workerSetup.removeTexture(textureId);
		Textures.deregisterTexture(textureId, this);
		textureData.dispose();
	}
	
	
	
	function get_textureBase() 
	{
		return textureData.textureBase;
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
	
	function get_nativeTexture():Texture 
	{
		return textureData.nativeTexture;
	}
}