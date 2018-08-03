package fuse.texture;


import fuse.core.front.texture.Textures;
import fuse.loader.ILoader;
import openfl.events.IOErrorEvent;
//import fuse.loader.FileLoader;
import fuse.loader.RemoteLoader;
import openfl.display3D.textures.Texture;

import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:forward(textureData, nativeTexture, textureBase, textureId, width, height, onUpdate, clearColour, _clear, _alreadyClear, upload, dispose, directRender)
@:access(fuse.texture.BaseTexture)
abstract FileTexture(AbstractTexture) to Int from Int 
{
	static var baseFileTextures = new Map<String, BaseFileTexture>();
	
	var baseFileTexture(get, never):BaseFileTexture;
	
	public function new(url:String, ?width:Int, ?height:Int, ?queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		//var textureId:Null<Int> = AbstractTexture.textureIdCount++;
		var baseFileTexture:BaseFileTexture = null;
		
		if (!baseFileTextures.exists(url)) {
			baseFileTexture = new BaseFileTexture(url, width, height, queUpload, onTextureUploadCompleteCallback);
			baseFileTextures.set(url, baseFileTexture);
		}
		else {
			baseFileTexture = baseFileTextures.get(url);
			onTextureUploadCompleteCallback(); // will fail if the texture hasn't actually loaded
		}
		//trace("textureId = " + textureId);
		this = new AbstractTexture(baseFileTexture);
		//trace("this.textureId = " + this.textureId);
	}
	
	private function upload():Void
	{
		baseFileTexture.upload();
	}
	
	function get_baseFileTexture():BaseFileTexture 
	{
		return untyped this.coreTexture;
	}
	
	@:to
	public function toAbstractTexture():AbstractTexture
	{
		return this;
	}
}

@:access(fuse.texture.FileTexture)
class BaseFileTexture extends BaseTexture
{
	var fileLoader:ILoader;
	var bitmapData:BitmapData;
	var url:String;
	
	public function new(url:String, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		//if (url.indexOf("http") == 0) {
			fileLoader = new RemoteLoader();
		//}
		//else {
			//fileLoader = new FileLoader();
		//}
		
		this.url = url;
		
		super(0, 0, queUpload, onTextureUploadCompleteCallback);
		
		fileLoader.addEventListener(Event.COMPLETE, OnLoadComplete);
		fileLoader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
	}
	
	private function OnError(e:IOErrorEvent):Void 
	{
		
	}
	
	override public function upload() 
	{
		fileLoader.load(url);
	}

	private function OnLoadComplete(e:Event):Void
	{
		this.bitmapData = fileLoader.bitmapData;
		this.width = bitmapData.width;
		this.height = bitmapData.height;
		
		createNativeTexture();
		
		if (uploadFromBitmapDataAsync == null) {
			nativeTexture.uploadFromBitmapData(bitmapData, 0);
			OnTextureUploadComplete(null);
		}
		else {
			nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
			uploadFromBitmapDataAsync(bitmapData, 0);
		}
	}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		
		textureData.changeCount++;
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
	
	override public function dispose():Void
	{
		super.dispose();
		FileTexture.baseFileTextures.remove(url);
	}
}