package fuse.texture;


import fuse.core.front.texture.Textures;
import fuse.loader.ILoader;
import openfl.events.IOErrorEvent;
import fuse.loader.RemoteLoader;

import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */

class ImageTexture extends BaseTexture
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
		Textures.registerTexture(objectId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
	
	override public function dispose():Void
	{
		super.dispose();
		//ImageTexture.baseFileTextures.remove(url);
	}
}