package fuse.window;

import flash.display.NativeWindow;
import flash.display.NativeWindowDisplayState;
import flash.display.NativeWindowResize;
import signal.Signal;

/**
 * ...
 * @author P.J.Shand
 */
class AppWindow {
	public var onMove = new Signal();
	public var onResize = new Signal();
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var displayState(get, null):NativeWindowDisplayState;

	var nativeWindow:NativeWindow;

	public function new(nativeWindow:NativeWindow) {
		this.nativeWindow = nativeWindow;
	}

	public function setBounds(x:Float, y:Float, w:Float, h:Float) {
		if (nativeWindow.x == x && nativeWindow.y == y && nativeWindow.width == w && nativeWindow.height == h)
			return;

		nativeWindow.x = x;
		nativeWindow.y = y;
		nativeWindow.width = w;
		nativeWindow.height = h;
		onResize.dispatch();
	}

	public function restore() {
		trace("TODO: implement restore");
	}

	public function startMove() {
		nativeWindow.startMove();
	}

	public function startResize(nativeWindowResize:NativeWindowResize) {
		nativeWindow.startResize(nativeWindowResize);
	}

	public function moveTo(x:Float, y:Float) {
		var scale = nativeWindow.stage.contentsScaleFactor;

		nativeWindow.x = x / scale;
		nativeWindow.y = y / scale;

		if (scale != nativeWindow.stage.contentsScaleFactor) {
			// moved to a different density screen
			scale = nativeWindow.stage.contentsScaleFactor;
			nativeWindow.x = x / scale;
			nativeWindow.y = y / scale;
		}

		onMove.dispatch();
	}

	public function resizeTo(width:Float, height:Float):Void {
		var scale = nativeWindow.stage.contentsScaleFactor;

		nativeWindow.width = width / scale;
		nativeWindow.height = height / scale;

		if (scale != nativeWindow.stage.contentsScaleFactor) {
			// moved to a different density screen
			scale = nativeWindow.stage.contentsScaleFactor;
			nativeWindow.width = width / scale;
			nativeWindow.height = height / scale;
		}

		onResize.dispatch();
	}

	function get_x():Float {
		return nativeWindow.x;
	}

	function get_y():Float {
		return nativeWindow.y;
	}

	function get_width():Float {
		return nativeWindow.width;
	}

	function get_height():Float {
		return nativeWindow.height;
	}

	function get_displayState():NativeWindowDisplayState {
		return nativeWindow.displayState;
	}
}
