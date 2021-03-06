package fuse.texture;

import openfl.net.NetStream;
import fuse.core.front.texture.FrontVideoTexture;
import signals.Signal;

class VideoTexture extends BaseTexture {
	var videoTexture:FrontVideoTexture;

	public var netStream(get, set):NetStream;
	// public var nativeVideoTexture:NativeVideoTexture;
	public var playbackRate(get, set):Float;
	public var loop(get, set):Bool;
	public var loopBuffer(get, set):Float;
	public var duration(get, set):Null<Float>;
	public var time(get, null):Float;
	public var volume(get, set):Float;
	public var onComplete(get, null):Signal;
	public var onError(get, null):Signal;
	public var onMetaData(get, null):Signal;
	public var url(get, set):String;

	public function new(width:Int = 512, height:Int = 512, url:String = null) {
		super();
		texture = videoTexture = new FrontVideoTexture(width, height, url);
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

	public function resume() {
		videoTexture.resume();
	}

	public function seek(offset:Float) {
		videoTexture.seek(offset);
	}

	function get_url():String {
		return videoTexture.url;
	}

	function get_loop():Bool {
		return videoTexture.loop;
	}

	function get_loopBuffer():Float {
		return videoTexture.loopBuffer;
	}

	function get_playbackRate():Float {
		return videoTexture.playbackRate;
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

	function set_url(value:String):String {
		return videoTexture.url = value;
	}

	function set_loop(value:Bool):Bool {
		return videoTexture.loop = value;
	}

	function set_loopBuffer(value:Float):Float {
		return videoTexture.loopBuffer = value;
	}

	function set_playbackRate(value:Float):Float {
		return videoTexture.playbackRate = value;
	}

	function set_duration(value:Null<Float>):Null<Float> {
		return videoTexture.duration = value;
	}

	function set_volume(value:Float):Float {
		return videoTexture.volume = value;
	}

	function get_netStream():NetStream {
		return videoTexture.netStream;
	}

	function set_netStream(value:NetStream):NetStream {
		return videoTexture.netStream = value;
	}
}
