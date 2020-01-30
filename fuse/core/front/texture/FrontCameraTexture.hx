package fuse.core.front.texture;

import openfl.media.Camera;
import delay.Delay;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.display3D.textures.VideoElementTexture as NativeVideoElementTexture;
import time.EnterFrame;
import notifier.Notifier;
import signal.Signal;
import js.html.CanvasElement;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(notifier.Notifier)
@:access(openfl.media.Camera)
#end
class FrontCameraTexture extends FrontBaseTexture {
	public var nativeVideoElementTexture:NativeVideoElementTexture;

	var camera:Camera;
	var available = new Notifier<Bool>();

	public function new(camera:Camera = null) {
		this.camera = camera;

		trace([camera.width, camera.height, camera.video]);
		super(camera.width, camera.height, false, false);
		this.directRender = true;
	}

	inline function updateTextureSurface() {
		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}

	override public function upload() {
		setTextureData();

		nativeVideoElementTexture = new NativeVideoElementTexture(Textures.context3D);

		textureData.textureBase = nativeVideoElementTexture;

		nativeVideoElementTexture.attachVideo(camera.video);

		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		updateTextureSurface();
		onUpload.dispatch();
	}

	public function update() {
		nativeVideoElementTexture.update();
		updateTextureSurface();
	}

	override public function dispose() {
		super.dispose();
	}
}
