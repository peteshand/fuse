package fuse.core.front.texture;

import delay.Delay;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import time.EnterFrame;
import notifier.Notifier;
import signal.Signal;
import js.html.ImageElement;
import js.Browser;
import js.html.ImageElement;
import haxe.Timer;
import openfl._internal.backend.gl.GLTexture;
import openfl.events.Event;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(notifier.Notifier)
#end
class FrontImageTexture extends FrontBaseTexture {
	public var nativeImageTexture:ImageTexture;

	var imageElement:ImageElement;
	var available = new Notifier<Bool>();

	public function new(url:String, ?width:Null<Int>, ?height:Null<Int>, queUpload:Bool = false) {
		imageElement = Browser.document.createImageElement();
		imageElement.addEventListener('load', onImageLoaded);
		imageElement.crossOrigin = "anonymous";

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
		nativeImageTexture = new ImageTexture(Textures.context3D);
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.events.Event)
@:final class ImageTexture extends TextureBase {
	public var canvasHeight(default, null):Int;
	public var canvasWidth(default, null):Int;

	var __update:Bool = true;
	@:noCompletion private var imageElement:ImageElement;

	@:noCompletion public function new(context:Context3D) {
		super(context);

		__textureTarget = __context.gl.TEXTURE_2D;
	}

	public function attachImage(imageElement:ImageElement):Void {
		this.imageElement = imageElement;
		__textureReady();
	}

	@:noCompletion private override function __getTexture():GLTexture {
		#if (js && html5)
		if (__update == true) {
			__update = false;
			var gl = __context.gl;
			__context.__bindGLTexture2D(__textureID);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, imageElement);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, imageElement);
		}
		#end
		return __textureID;
	}

	public function update() {
		__update = true;
	}

	@:noCompletion private function __textureReady():Void {
		#if (js && html5)
		canvasWidth = imageElement.clientWidth;
		canvasHeight = imageElement.clientHeight;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.TEXTURE_READY);
		#else
		event = new Event(Event.TEXTURE_READY);
		#end

		dispatchEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}
}
