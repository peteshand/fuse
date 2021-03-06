package fuse.core.front.texture;

import fuse.core.front.texture.FrontBaseTexture;
import fuse.texture.TextureId;
import delay.Delay;
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
class FrontImageTexture extends FrontBaseTexture {
	static var imageTextureIds = new Map<String, TextureId>();

	var masterTextureId:Null<TextureId>;

	static var loaders = new Map<String, ILoader>();

	var fileLoader:ILoader;

	public var bitmapData:BitmapData;
	public var url:String;

	@:isVar var errorBitmap(get, null):BitmapData;

	public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool = false /*, onTextureUploadCompleteCallback:Void -> Void = null*/) {
		// TODO: reuse nativeTexture when same url is set
		// masterTextureId = imageTextureIds.get(url);

		// fileLoader = loaders.get(url);
		// if (fileLoader == null){
		fileLoader = new RemoteLoader();
		// loaders.set(url, fileLoader);
		// }

		this.url = url;

		if (width == null)
			width = 0;
		if (height == null)
			height = 0;
		super(width, height, queUpload, /*onTextureUploadCompleteCallback, */ true, masterTextureId);

		if (masterTextureId == null) {
			// trace("no master texture found for " + url + ", setting self as master: " + this.textureId);
			imageTextureIds.set(url, this.textureId);
		}

		fileLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		fileLoader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
	}

	private function OnError(e:IOErrorEvent):Void {
		trace("OnError");
		setBitmapData(errorBitmap);
	}

	override public function upload() {
		if (fileLoader.bitmapData != null)
			onLoadComplete();
		else if (fileLoader.loading == false)
			fileLoader.load(url);
	}

	private function onLoadComplete(e:Event = null):Void {
		setBitmapData(fileLoader.bitmapData.clone());
	}

	function setBitmapData(bmd:BitmapData) {
		this.bitmapData = bmd;
		// this.bitmapData = new BitmapData(bmd.width, bmd.height, true, 0x00000000);
		// bitmapData.draw(bmd);
		this.width = bitmapData.width;
		this.height = bitmapData.height;

		createNativeTexture();

		if (uploadFromBitmapDataAsync == null) {
			try {
				nativeTexture.uploadFromBitmapData(bitmapData, 0);
				#if (air || flash)
				OnTextureUploadComplete(null);
				#else
				// Delay.byFrames(40, () -> {
				// Without a delay the following error is happening: there is no texture bound to the unit 1
				OnTextureUploadComplete(null);
				// });
				#end
			} catch (e:Dynamic) {
				trace("Error uploading texture");
			}
		} else {
			nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
			uploadFromBitmapDataAsync(bitmapData, 0);
		}
	}

	private function OnTextureUploadComplete(e:Event):Void {
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);

		// textureData.changeCount++;
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);

		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);

		// trace("frontStaticCount = 0");
		Fuse.current.conductorData.frontStaticCount = 0;
		// if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		// trace('load complete: ' + url);
		onUpload.dispatch();
	}

	override public function dispose():Void {
		super.dispose();
		// ImageTexture.baseFileTextures.remove(url);
	}

	function get_errorBitmap():BitmapData {
		if (errorBitmap == null)
			errorBitmap = new BitmapData(32, 32, true, 0x990000FF);
		return errorBitmap;
	}
}
