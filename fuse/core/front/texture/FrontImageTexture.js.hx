package fuse.core.front.texture;

import delay.Delay;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.display3D.textures.ImageTexture as NativeImageTexture;
import time.EnterFrame;
import notifier.Notifier;
import signal.Signal;
import js.html.ImageElement;
import js.Browser;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(notifier.Notifier)
#end
class FrontImageTexture extends FrontBaseTexture {
	public var nativeImageTexture:NativeImageTexture;

	var imageElement:ImageElement;
	var available = new Notifier<Bool>();

	public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool = false) {
		imageElement = Browser.document.createImageElement();
		imageElement.addEventListener('load', onImageLoaded);
		
		super(imageElement.width, imageElement.height, false, false, false);

		imageElement.src = url;
		if (width != null)
			imageElement.width = width;
		if (height != null)
			imageElement.height = height;
	}

	function onImageLoaded() {
		this.width = imageElement.width;
		this.height = imageElement.height;
		generateBackendTexture();
		update();
	}

	inline function updateTextureSurface() {
		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}

	override public function upload() {
		setTextureData();
		// createNativeTexture();
		/*textureBase =*/ // nativeImageTexture = Textures.context3D.createVideoTexture();
		// nativeImageTexture = Textures.context3D.createVideoTexture();
		nativeImageTexture = new NativeImageTexture(Textures.context3D);
		textureData.textureBase = nativeImageTexture;
		// Textures.context3D.createTexture(64, 64, Context3DTextureFormat.BGRA, false);
		nativeImageTexture.attachImage(imageElement);
		// EnterFrame.add(onTick);
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		updateTextureSurface();
		// if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}

	public function update() {
		nativeImageTexture.update();
		updateTextureSurface();
	}

	override public function dispose() {
		super.dispose();
		// EnterFrame.remove(onTick);
	}

	// function onTick() {
	//
	// }
}