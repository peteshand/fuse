package fuse.texture;

import openfl.display.BitmapData;
import fuse.core.front.texture.FrontImageTexture;
import fuse.core.front.texture.IFrontTexture;
import signals.Signal1;

class ImageTexture extends BaseTexture {
	static var cache = new Map<String, IFrontTexture>();

	@:isVar public var url(default, set):String;

	var imageTexture:FrontImageTexture;

	public var bitmapData(get, null):BitmapData;
	public var onError:Signal1<Dynamic>;

	public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool = false, onTextureUploadCompleteCallback:Void->Void = null,
			useCache:Bool = true) {
		super();
		this.url = url;

		if (useCache) {
			texture = cache.get(url);
			imageTexture = cast texture;
		}
		if (texture == null) {
			texture = imageTexture = new FrontImageTexture(url, width, height, queUpload /*, onTextureUploadCompleteCallback*/);
			cache.set(url, texture);
		}
		onError = imageTexture.onError;

		if (onTextureUploadCompleteCallback != null) {
			texture.onUpload.add(onTextureUploadCompleteCallback);
		}
	}

	function set_url(value:String) {
		url = value;
		if (imageTexture != null) {
			imageTexture.url = url;
		}
		return value;
	}

	function get_bitmapData():BitmapData {
		#if js
		return null;
		#else
		return imageTexture.bitmapData;
		#end
	}

	override public function dispose():Void {
		cache.remove(url);
		super.dispose();
	}
}
