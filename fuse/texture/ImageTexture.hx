package fuse.texture;


import mantle.delay.Delay;
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
	static var loaders = new Map<String, ILoader>();
	var fileLoader:ILoader;
	var bitmapData:BitmapData;
	public var url:String;
	
	public function new(url:String, ?width:Int, ?height:Int, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		fileLoader = loaders.get(url);
		if (fileLoader == null){
			fileLoader = new RemoteLoader();
			loaders.set(url, fileLoader);
		}
		
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
		if (fileLoader.bitmapData != null) OnLoadComplete();
		else if (fileLoader.loading == false) fileLoader.load(url);
	}

	private function OnLoadComplete(e:Event=null):Void
	{
		this.bitmapData = fileLoader.bitmapData;
		this.width = bitmapData.width;
		this.height = bitmapData.height;
		
		createNativeTexture();
		
		if (uploadFromBitmapDataAsync == null) {
			nativeTexture.uploadFromBitmapData(bitmapData, 0);
			

			#if (air||flash)
				OnTextureUploadComplete(null);
			#else
			Delay.byFrames(40, () -> {
				// Without a delay the following error is happening: there is no texture bound to the unit 1
				OnTextureUploadComplete(null);
			});
			#end
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
		
		Fuse.current.conductorData.frontStaticCount = 0;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
	
	override public function dispose():Void
	{
		super.dispose();
		//ImageTexture.baseFileTextures.remove(url);
	}
}