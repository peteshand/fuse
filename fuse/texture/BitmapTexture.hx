package fuse.texture;

import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.events.Event;
/**
 * ...
 * @author P.J.Shand
 */

@:forward(textureData, nativeTexture, textureBase, textureId, width, height, onUpdate, clearColour, _clear, _alreadyClear, upload, dispose, directRender)
abstract BitmapTexture(AbstractTexture) to Int from Int 
{
	var baseBitmapTexture(get, never):BaseBitmapTexture;
	
	public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this = new AbstractTexture(new BaseBitmapTexture(bitmapData, width, height, queUpload, onTextureUploadCompleteCallback));
	}
	
	public function update(source:BitmapData)					{ baseBitmapTexture.update(source); 			}
	function upload():Void										{ baseBitmapTexture.upload(); 					}
	function get_baseBitmapTexture():BaseBitmapTexture			{ return untyped this.coreTexture; 				}
	@:to public function toAbstractTexture():AbstractTexture	{ return this; 									}
}

@:access(fuse)
class BaseBitmapTexture extends BaseTexture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.bitmapData = bitmapData;
		
		var w:Int = width;
		if (width == null) w = bitmapData.width;
		
		var h:Int = height;
		if (width == null) h = bitmapData.height;
		
		//if (width == null) this.width = bitmapData.width;
		//else this.width = width;
		//
		//if (height == null) this.height = bitmapData.height;
		//else this.height = height;
		
		super(w, h, queUpload, onTextureUploadCompleteCallback);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		update(bitmapData);
	}
	
	public function update(source:BitmapData) 
	{
		this.bitmapData = source;
		
		//var uploadFromBitmapDataAsync:BitmapData -> Int -> Void = Reflect.getProperty(nativeTexture, "uploadFromBitmapDataAsync");
		//if (uploadFromBitmapDataAsync != null) {
		//	nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		//	uploadFromBitmapDataAsync(bitmapData, 0);
		//}
		//else {
			nativeTexture.uploadFromBitmapData(bitmapData, 0);
			OnTextureUploadComplete(null);
		//}
	}
	
	//public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0):Void
	//{
		//nativeTexture.uploadFromBitmapData(source, miplevel);
		//textureData.placed = 0;
	//}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		textureData.changeCount++;
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		
		Fuse.current.conductorData.frontStaticCount = 0;
		
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
	}
}