package fuse.texture;

import fuse.core.front.texture.FrontVideoTexture;
import signal.Signal;

class VideoTexture extends BaseTexture {
	var videoTexture:FrontVideoTexture;

	// public var netStream:NetStream;
	// public var nativeVideoTexture:NativeVideoTexture;
	public var loop(get, set):Bool;
	public var duration(get, set):Null<Float>;
	public var time(get, null):Float;
	public var volume(get, set):Float;
	public var onComplete(get, null):Signal;
	public var onError(get, null):Signal;
	public var onMetaData(get, null):Signal;

	public function new(url:String = null) {
		super();
		texture = videoTexture = new FrontVideoTexture(url);
	}

	public function play(url:String = null, autoPlay:Bool = true) {
		videoTexture.play(url, autoPlay);
	}

	public function stop() {
		videoTexture.stop();
	}

	public function pause() {
		videoTexture.pause();
	}

	public function seek(offset:Float) {
		videoTexture.seek(offset);
	}

	function get_loop():Bool {
		return videoTexture.loop;
	}

	function get_duration():Null<Float> {
		return videoTexture.duration;
	}

	function get_time():Float {
		return videoTexture.time;
	}

	function get_volume():Float {
		return videoTexture.volume;
	}

	function get_onComplete():Signal {
		return videoTexture.onComplete;
	}

	function get_onError():Signal {
		return videoTexture.onError;
	}

	function get_onMetaData():Signal {
		return videoTexture.onMetaData;
	}

	function set_loop(value:Bool):Bool {
		return videoTexture.loop = value;
	}

	function set_duration(value:Null<Float>):Null<Float> {
		return videoTexture.duration = value;
	}

	function set_volume(value:Float):Float {
		return videoTexture.volume = value;
	}
}
