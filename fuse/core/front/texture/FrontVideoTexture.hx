package fuse.core.front.texture;

import delay.Delay;
import openfl.events.VideoTextureEvent;
import openfl.media.SoundTransform;
import openfl.net.NetConnection;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import mantle.net.NetStream;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
import time.EnterFrame;
import notifier.Notifier;
import signal.Signal;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(mantle.net.NetStream)
@:access(notifier.Notifier)
#end
class FrontVideoTexture extends FrontBaseTexture {
	public var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	public var loop:Bool = false;
	public var duration:Null<Float>;

	var netConnection:NetConnection;

	public var time(get, null):Float;
	@:isVar public var volume(default, set):Float = 1;
	@:isVar public var onComplete(get, null):Signal;
	@:isVar public var onError(get, null):Signal;
	public var onMetaData = new Signal();

	var url:String;
	var currentUrl:String;
	var paused:Null<Bool> = null;
	var videoMetaData:VideoMetaData;
	var available = new Notifier<Bool>();
	var seekTarget:Null<Float>;
	var autoPlay:Bool;
	var action = new Notifier<VideoAction>();
	var state = new Notifier<VideoAction>();

	public function new(url:String = null) {
		// trace2("supportsVideoTexture = " + Context3D.supportsVideoTexture);
		netConnection = new NetConnection();
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: onMetaDataReceived};
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);

		netStream.onError.add(() -> {
			onError.dispatch();
		});
		super(512, 512, false, false);
		this.directRender = true;

		// if (url != null) play(url);

		action.add(onActiveChange);
		available.add(onAvailableChange);
		// available.requireChange = false;
	}

	function onActiveChange() {
		if (action.value == VideoAction.PLAY) {
			if (!autoPlay)
				action.value = VideoAction.PAUSE_WAIT;
			/*if (available.value != false)*/ playVideo();
			// else action.value = VideoAction.PLAY_WAIT;
		} else if (action.value == VideoAction.STOP) {
			if (available.value == true)
				stopVideo();
			else
				action.value = VideoAction.STOP_WAIT;
		} else if (action.value == VideoAction.PAUSE) {
			if (available.value == true)
				pauseVideo();
			else
				action.value = VideoAction.PAUSE_WAIT;
		} else if (action.value == VideoAction.SEEK) {
			seekVideo();
			if (!autoPlay)
				action.value = VideoAction.PAUSE_WAIT;
		} else if (action.value == VideoAction.RESTART) {
			seekTarget = 0;
			seekVideo();
		}
	}

	function onAvailableChange() {
		Delay.killDelay(delayAvailable);
		trace2("onAvailableChange: " + available.value);
		if (available.value) {
			if (action.value == VideoAction.PLAY_WAIT)
				action.value = VideoAction.PLAY;
			else if (action.value == VideoAction.PAUSE_WAIT)
				action.value = VideoAction.PAUSE;
			else if (action.value == VideoAction.STOP_WAIT)
				action.value = VideoAction.STOP;
			else if (action.value == VideoAction.SEEK_WAIT)
				action.value = VideoAction.SEEK;
		}
	}

	public function play(url:String = null, autoPlay:Bool = true) {
		trace2("play");
		this.autoPlay = autoPlay;
		this.url = url;
		action.value = VideoAction.PLAY;
	}

	public function stop() {
		trace2("stop");
		action.value = VideoAction.STOP;
	}

	public function pause() {
		trace2("pause");
		action.value = VideoAction.PAUSE;
	}

	public function seek(offset:Float) {
		trace2("seek");
		seekTarget = offset;
		action.value = VideoAction.SEEK;
	}

	function playVideo() {
		trace2(url);
		// Delay.killDelay(pause);

		// this.autoPlay = autoPlay;

		if (currentUrl == url) {
			trace2("resume");
			netStream.resume();
			// onMetaData.dispatch();
			Delay.nextFrame(() -> {
				onMetaData.dispatch();
			});
		} else {
			trace2("playLocal");
			// if (url == null && this.url != null) url = this.url;
			duration = null;
			// this.url = url;

			videoMetaData = null;

			netStream.playLocal(url);
			netStream.soundTransform = new SoundTransform(volume);
			available.value = false;
		}
		paused = false;

		// available.remove(onPlayingStartAfterSetURL);

		// checkAutoPlay();
	}

	function stopVideo() {
		// if (paused == false) return;
		trace2("stop");
		currentUrl = null;
		videoMetaData = null;
		duration = null;
		this.url = null;
		paused = null;
		netStream.close();
		netStream.url = null;
		available.value = false;
	}

	function pauseVideo() {
		trace2("pause");
		trace2(this.videoMetaData == null);

		trace2("paused = " + paused);
		if (paused == true || paused == null)
			return;
		trace2("AAA");
		paused = true;
		netStream.pause();
		// available.value = false;
	}

	function seekVideo() {
		trace2("seekTarget = " + seekTarget);
		action.value = VideoAction.SEEKING;

		netStream.seek(seekTarget);
	}

	private function OnEvent(e:NetStatusEvent):Void {
		var info:NetStatusInfo = e.info;
		trace2(info.code);
		// if (textureData != null){
		//	trace2("textureData.textureAvailable = " + textureData.textureAvailable);
		// }
		if (info.code == "NetStream.Play.Start") {
			updateTextureSurface();
			Delay.nextFrame(delayAvailable);
		}
		if (info.code == "NetStream.Play.Stop") {
			available.value = false;
			if (onComplete != null) {
				// onComplete.dispatch();
			}
		}
		if (info.code == "NetStream.Play.Complete") {
			available.value = false;
			if (onComplete != null) {
				onComplete.dispatch();
			}
		}

		if (info.code == "NetStream.Seek.Complete") {
			// seeking.value = false;
			// seek(seekTarget);
		}

		if (info.code == "NetStream.Buffer.Empty") {
			// nativeVideoTexture.addEventListener(Event.TEXTURE_READY, function(e:Event) {
			updateTextureSurface();
			// });
			// nativeVideoTexture.attachNetStream(netStream);
			if (onComplete != null) {
				onComplete.dispatch();
			}
		}
	}

	inline function updateTextureSurface() {
		textureAvailable = true;
		Fuse.current.workerSetup.updateTextureSurface(objectId);
	}

	function delayAvailable() {
		available.value = true;
	}

	function onMetaDataReceived(videoMetaData:VideoMetaData) {
		currentUrl = url;
		trace2("onMetaDataReceived");
		if (this.videoMetaData != null)
			return;
		// trace2(videoMetaData.width);

		this.videoMetaData = videoMetaData;
		// TODO: need to be able to update width/height in backend texture
		/*if (this.width == 0)*/ this.width = videoMetaData.width;
		/*if (this.height == 0)*/ this.height = videoMetaData.height;
		duration = videoMetaData.duration;
		setTextureData();

		// trace2("volume = " + volume);
		netStream.soundTransform = new SoundTransform(volume);

		// pause();
		// action.value == VideoAction.PAUSE;
		Delay.nextFrame(() -> {
			onMetaData.dispatch();
		});
		// checkAutoPlay();
	}

	/*function checkAutoPlay()
		{
			Delay.killDelay(autoPlayPause);
			trace2("checkAutoPlay");
			trace2("autoPlay = " + autoPlay);
			trace2(videoMetaData != null);
			if (!autoPlay && videoMetaData != null) {
				trace2("wait");
				Delay.byFrames(5, autoPlayPause);
			}
	}*/
	/*function autoPlayPause()
		{
			trace2("autoPlayPause");
			pause();
	}*/
	// function checkState()
	// {
	/*trace2("state.value = " + state.value);
		trace2("action.value = " + action.value);

		if (state.value != action.value){
			state.value = action.value;
			if (state.value == VideoAction.PAUSE) pause();
			//else if (state.value == VideoAction.PLAY) play(url, autoPlay);
			//else if (state.value == VideoAction.STOP) stop();
	}*/
	// }

	override public function upload() {
		setTextureData();
		// createNativeTexture();

		/*textureBase =*/ // nativeVideoTexture = Textures.context3D.createVideoTexture();
		nativeVideoTexture = Textures.context3D.createVideoTexture();

		textureData.textureBase = nativeVideoTexture;

		// Textures.context3D.createTexture(64, 64, Context3DTextureFormat.BGRA, false);

		nativeVideoTexture.addEventListener(Event.TEXTURE_READY, renderFrame);
		nativeVideoTexture.addEventListener(VideoTextureEvent.RENDER_STATE, onRenderState);

		nativeVideoTexture.attachNetStream(netStream);
	}

	function onRenderState(event:VideoTextureEvent) {
		// trace2(event.status);
	}

	private function renderFrame(e:Event):Void {
		// trace2("renderFrame");
		nativeVideoTexture.removeEventListener(Event.TEXTURE_READY, renderFrame);
		EnterFrame.add(onTick);

		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		updateTextureSurface();
		// if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}

	override public function dispose() {
		super.dispose();
		EnterFrame.remove(onTick);
	}

	function onTick() {
		if (loop) {
			if (duration != null) {
				if (time + 0.3 >= duration && action.value == VideoAction.PLAY) {
					action.value = VideoAction.RESTART;
				}
				if (action.value == VideoAction.RESTART && time + 0.3 < duration) {
					action.value = VideoAction.PLAY;
				}
			}
		}
		if (action.value == VideoAction.PLAY) {
			updateTextureSurface();
		}
	}

	function get_time():Float {
		return netStream.time;
	}

	function get_onComplete() {
		if (onComplete == null)
			onComplete = new Signal();
		return onComplete;
	}

	function get_onError() {
		if (onError == null)
			onError = new Signal();
		return onError;
	}

	function set_volume(value:Float):Float {
		volume = value;

		#if (js && html5)
		// DEBUG
		// js.Browser.document.body.insertBefore(__video, js.Browser.document.body.firstChild);
		netStream.__video.volume = volume;
		#else
		netStream.soundTransform = new SoundTransform(volume);
		#end

		return value;
	}

	function trace2(value:Dynamic) {
		// trace(value);
	}
}

typedef VideoMetaData = {
	width:Int,
	height:Int,
	duration:Float,
	videoframerate:Int
}

typedef NetStatusInfo = {
	level:String,
	code:String
}

@:enum abstract VideoAction(String) from String to String {
	public var RESTART:String = "restart";
	public var RESTART_WAIT:String = "restart_wait";
	public var PLAY:String = "play";
	public var STOP:String = "stop";
	public var PAUSE:String = "pause";
	public var SEEK:String = "seek";
	public var SEEKING:String = "seekING";
	public var PLAY_WAIT:String = "play_wait";
	public var PAUSE_WAIT:String = "pause_wait";
	public var STOP_WAIT:String = "stop_wait";
	public var SEEK_WAIT:String = "seek_wait";
}
