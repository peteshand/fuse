package openfl.display3D.textures;

#if !flash
import js.html.ImageElement;
import haxe.Timer;
import openfl._internal.backend.gl.GLTexture;
import openfl.events.Event;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;

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
#end
