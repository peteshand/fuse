package fuse.core.front.texture;

import mantle.delay.Delay;
import openfl.events.VideoTextureEvent;
import openfl.media.SoundTransform;
import msignal.Signal.Signal0;
import openfl.net.NetConnection;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import mantle.net.NetStream;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
import mantle.time.EnterFrame;
import notifier.Notifier;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
#if (js && html5)
@:access(mantle.net.NetStream)
#end
class FrontVideoTexture extends FrontBaseTexture
{
	public var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	public var loop:Bool = false;
	public var duration:Null<Float>;
	var netConnection:NetConnection;

	public var time(get, null):Float;
	@:isVar public var volume(default, set):Float = 1;
	@:isVar public var onComplete(get, null):Signal0;
	public var onMetaData = new Signal0();

	var url:String;
	var paused:Null<Bool> = null;
	var videoMetaData:VideoMetaData;
	var playing = new Notifier<Bool>();
	var seekTarget:Null<Float>;
	var autoPlay:Bool;
	var action = new Notifier<VideoAction>();
	var state = new Notifier<VideoAction>();
	
	public function new(url:String=null) 
	{
		//traceProxy("supportsVideoTexture = " + Context3D.supportsVideoTexture);
		netConnection = new NetConnection();
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = { onMetaData: onMetaDataReceived };
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		
		super(512, 512, false, null, false);
		this.directRender = true;

		//if (url != null) play(url);

		action.add(onActiveChange);
		playing.add(onPlayingChange);
		playing.requireChange = false;
	}

	

	function onActiveChange()
	{
		traceProxy("onActiveChange: " + action.value);
		traceProxy("playing.value = " + playing.value);
		if (action.value == VideoAction.PLAY) {
			if (!autoPlay) action.value = VideoAction.PAUSE_WAIT;
			/*if (playing.value != false)*/ playVideo();
			//else action.value = VideoAction.PLAY_WAIT;
		}
		else if (action.value == VideoAction.STOP) {
			if (playing.value == true) stopVideo();
			else action.value = VideoAction.STOP_WAIT;
		}
		else if (action.value == VideoAction.PAUSE) {
			if (playing.value == true) pauseVideo();
			else action.value = VideoAction.PAUSE_WAIT;
		}
		else if (action.value == VideoAction.SEEK) {
			if (playing.value == true) {
				seekVideo();
				if (!autoPlay) action.value = VideoAction.PAUSE_WAIT;
			}
			else action.value = VideoAction.SEEK_WAIT;
		}
	}

	function onPlayingChange()
	{
		traceProxy("onPlayingChange: " + playing.value);
		if (playing.value){
			if (action.value == VideoAction.PLAY_WAIT) action.value = VideoAction.PLAY;
			else if (action.value == VideoAction.PAUSE_WAIT) action.value = VideoAction.PAUSE;
			else if (action.value == VideoAction.STOP_WAIT) action.value = VideoAction.STOP;
			else if (action.value == VideoAction.SEEK_WAIT) action.value = VideoAction.SEEK;
		}
	}

	public function play(url:String=null, autoPlay:Bool=true) 
	{
		this.autoPlay = autoPlay;
		this.url = url;
		action.value = VideoAction.PLAY;
	}

	public function stop()
	{
		action.value = VideoAction.STOP;
	}

	public function pause()
	{
		action.value = VideoAction.PAUSE;
	}

	public function seek(offset:Float)
	{
		seekTarget = offset;
		action.value = VideoAction.SEEK;
	}
	

	function playVideo() 
	{
		
		//Delay.killDelay(pause);

		//this.autoPlay = autoPlay;
		
		/*if (netStream.url == url) {
			traceProxy("resume");
			netStream.resume();
			
		} else {*/
			traceProxy("playLocal");
			//if (url == null && this.url != null) url = this.url;
			duration = null;
			//this.url = url;
			
			videoMetaData = null;
			
			netStream.playLocal(url);
			netStream.soundTransform = new SoundTransform(volume);
		//}
		paused = false;
		playing.value = false;
		//playing.remove(onPlayingStartAfterSetURL);

		//checkAutoPlay();
	}

	function stopVideo()
	{
		//if (paused == false) return;
		traceProxy("stop");
		videoMetaData = null;
		duration = null;
		this.url = null;
		paused = null;
		netStream.close();
		netStream.url = null;
		playing.value = false;
	}

	function pauseVideo()
	{
		traceProxy("pause");
		traceProxy(this.videoMetaData == null);


		traceProxy("paused = " + paused);
		if (paused == true || paused == null) return;
		traceProxy("AAA");
		paused = true;
		netStream.pause();
		//playing.value = false;
	}

	function seekVideo()
	{
		netStream.seek(seekTarget);
	}
	
	private function OnEvent(e:NetStatusEvent):Void 
	{
		var info:NetStatusInfo = e.info;
		traceProxy(info.code);
		//if (textureData != null){
		//	traceProxy("textureData.textureAvailable = " + textureData.textureAvailable);
		//}
		if (info.code == "NetStream.Play.Start") {
			textureData.textureAvailable = 1;
			playing.value = true;
		}
		if (info.code == "NetStream.Play.Stop") {
			playing.value = false;
			if (onComplete != null) {
				//onComplete.dispatch();
			}
		}
		if (info.code == "NetStream.Play.Complete") {
			playing.value = false;
			if (onComplete != null) {
				onComplete.dispatch();
			}
		}

		

		if (info.code == "NetStream.Seek.Complete") {
			//seeking.value = false;
			//seek(seekTarget);
		}
		
		if (info.code == "NetStream.Buffer.Empty") {
			//nativeVideoTexture.addEventListener(Event.TEXTURE_READY, function(e:Event) {
				textureData.textureAvailable = 1;
			//});
			//nativeVideoTexture.attachNetStream(netStream);
			if (onComplete != null) {
				onComplete.dispatch();
			}
		}
	}
	
	function onMetaDataReceived(videoMetaData:VideoMetaData) 
	{
		traceProxy("onMetaDataReceived");
		if (this.videoMetaData != null) return;
		//traceProxy(videoMetaData.width);

		this.videoMetaData = videoMetaData;
		// TODO: need to be able to update width/height in backend texture
		/*if (this.width == 0)*/ this.width = videoMetaData.width;
		/*if (this.height == 0)*/ this.height = videoMetaData.height;
		duration = videoMetaData.duration;
		setTextureData();

		//traceProxy("volume = " + volume);
		netStream.soundTransform = new SoundTransform(volume);

		//pause();
		//action.value == VideoAction.PAUSE;
		onMetaData.dispatch();
		//checkAutoPlay();
	}

	/*function checkAutoPlay()
	{
		Delay.killDelay(autoPlayPause);
		traceProxy("checkAutoPlay");
		traceProxy("autoPlay = " + autoPlay);
		traceProxy(videoMetaData != null);
		if (!autoPlay && videoMetaData != null) {
			traceProxy("wait");
			Delay.byFrames(5, autoPlayPause);
		}
	}*/

	/*function autoPlayPause()
	{
		traceProxy("autoPlayPause");
		pause();
	}*/

	//function checkState()
	//{
		/*traceProxy("state.value = " + state.value);
		traceProxy("action.value = " + action.value);
		
		if (state.value != action.value){
			state.value = action.value;
			if (state.value == VideoAction.PAUSE) pause();
			//else if (state.value == VideoAction.PLAY) play(url, autoPlay);
			//else if (state.value == VideoAction.STOP) stop();
		}*/
	//}
	
	override public function upload() 
	{
		setTextureData();
		//createNativeTexture();
		
		/*textureBase =*/ //nativeVideoTexture = Textures.context3D.createVideoTexture();
		nativeVideoTexture = Textures.context3D.createVideoTexture();
		
		textureData.textureBase = nativeVideoTexture;
		
		//Textures.context3D.createTexture(64, 64, Context3DTextureFormat.BGRA, false);
		
		nativeVideoTexture.addEventListener(Event.TEXTURE_READY, renderFrame);
		nativeVideoTexture.addEventListener(VideoTextureEvent.RENDER_STATE, onRenderState);

		nativeVideoTexture.attachNetStream(netStream);
	}
	

	function onRenderState(event:VideoTextureEvent)
	{
		//traceProxy(event.status);
	}

	private function renderFrame(e:Event):Void 
	{
		//traceProxy("renderFrame");
		nativeVideoTexture.removeEventListener(Event.TEXTURE_READY, renderFrame);
		EnterFrame.add(onTick);

		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}

	override public function dispose()
	{
		super.dispose();
		EnterFrame.remove(onTick);
	}

	function onTick()
	{
		if (loop){
			if (duration != null){
				if (time + 0.3 >= duration){
					nativeVideoTexture.addEventListener(Event.TEXTURE_READY, renderFrame);
					EnterFrame.remove(onTick);
					seek(0);
				}
			}
		}
		this.textureData.changeCount++;
	}

	function get_time():Float
	{
		return netStream.time;
	}

	function get_onComplete()
	{
		if (onComplete == null) {
			onComplete = new Signal0();
		}
		return onComplete;
	}

	function set_volume(value:Float):Float
	{
		volume = value;
		//traceProxy("volume = " + volume);
		netStream.soundTransform = new SoundTransform(volume);
		return value;
	}

	function traceProxy(value:Dynamic)
	{
		//trace(value);
	}
}

typedef VideoMetaData =
{
	width:Int,
	height:Int,
	duration:Float,
	videoframerate:Int
}

typedef NetStatusInfo = 
{
	level:String,
	code:String
}

@:enum abstract VideoAction(String) from String to String {
	
	public var PLAY:String = "play";
	public var STOP:String = "stop";
	public var PAUSE:String = "pause";
	public var SEEK:String = "seek";
	public var PLAY_WAIT:String = "play_wait";
	public var PAUSE_WAIT:String = "pause_wait";
	public var STOP_WAIT:String = "stop_wait";
	public var SEEK_WAIT:String = "seek_wait";
	
	
}