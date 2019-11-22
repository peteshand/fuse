package fuse.core.front.texture;

import delay.Delay;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.display3D.textures.CanvasTexture as NativeCanvasTexture;
import time.EnterFrame;
import notifier.Notifier;
import signals.Signal;
import js.html.CanvasElement;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(notifier.Notifier)
#end
class FrontCanvasTexture extends FrontBaseTexture {
	public var nativeCanvasTexture:NativeCanvasTexture;

	var canvas:CanvasElement;
	var available = new Notifier<Bool>();

	public function new(canvas:CanvasElement = null) {
		this.canvas = canvas;

		super(canvas.width, canvas.height, false, false);
		this.directRender = true;
	}

	inline function updateTextureSurface() {
		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}

	override public function upload() {
		setTextureData();
		// createNativeTexture();

		/*textureBase =*/ // nativeCanvasTexture = Textures.context3D.createVideoTexture();
		// nativeCanvasTexture = Textures.context3D.createVideoTexture();

		nativeCanvasTexture = new NativeCanvasTexture(Textures.context3D);

		textureData.textureBase = nativeCanvasTexture;

		// Textures.context3D.createTexture(64, 64, Context3DTextureFormat.BGRA, false);

		nativeCanvasTexture.attachCanvas(canvas);

		// EnterFrame.add(onTick);

		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		updateTextureSurface();
		// if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}

	public function update() {
		nativeCanvasTexture.update();
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
