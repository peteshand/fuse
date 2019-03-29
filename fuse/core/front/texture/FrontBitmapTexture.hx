package fuse.core.front.texture;

import fuse.texture.TextureId;
import fuse.utils.ObjectId;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.events.Event;
/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class FrontBitmapTexture extends FrontBaseTexture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, /*onTextureUploadCompleteCallback:Void -> Void = null, */_textureId:Null<TextureId> = null, _objectId:Null<ObjectId> = null) 
	{
		this.bitmapData = bitmapData;
		
		var w:Int = width;
		if (width == null) w = bitmapData.width;
		
		var h:Int = height;
		if (width == null) h = bitmapData.height;
		
		super(w, h, queUpload, /*onTextureUploadCompleteCallback, */true, _textureId, _objectId);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		update(bitmapData);
	}
	
	public function update(source:BitmapData) 
	{
		this.bitmapData = source;
		if (nativeTexture == null) return;
		//var uploadFromBitmapDataAsync:BitmapData -> Int -> Void = Reflect.getProperty(nativeTexture, "uploadFromBitmapDataAsync");
		/*if (uploadFromBitmapDataAsync != null) {
			nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
			uploadFromBitmapDataAsync(bitmapData, 0);
		}
		else {*/
			try {
				nativeTexture.uploadFromBitmapData(bitmapData, 0);
				OnTextureUploadComplete(null);
			} catch (e:Dynamic) {
				trace("Error uploading texture");
			}
			
			
		//}
	}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		textureData.changeCount++;
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		
		Fuse.current.conductorData.frontStaticCount = 0;
		
		//if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
}