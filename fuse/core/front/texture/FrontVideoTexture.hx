package fuse.core.front.texture;

import mantle.delay.Delay;
import openfl.events.VideoTextureEvent;
import msignal.Signal.Signal0;
import openfl.net.NetConnection;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import mantle.net.NetStream;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
import mantle.time.EnterFrame;
import mantle.notifier.Notifier;
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
	@:isVar public var onComplete(get, null):Signal0;
	public var onMetaData = new Signal0();

	var url:String;
	var paused:Null<Bool> = null;
	var videoMetaData:VideoMetaData;
	var playing = new Notifier<Bool>();
	var seekTarget:Null<Float>;
	var autoPlay:Bool;

	public function new(url:String=null) 
	{
		//trace("supportsVideoTexture = " + Context3D.supportsVideoTexture);
		netConnection = new NetConnection();
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = { onMetaData: onMetaDataReceived };
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		
		super(512, 512, false, null, false);
		this.directRender = true;

		//if (url != null) play(url);
	}

	public function play(url:String=null, autoPlay:Bool=true) 
	{
		Delay.killDelay(pause);

		this.autoPlay = autoPlay;
		
		if (this.url == url) {
			//trace("resume");
			netStream.resume();
		} else {
			//trace("playLocal");
			if (url == null && this.url != null) url = this.url;
			duration = null;
			this.url = url;
			
			videoMetaData = null;
			netStream.playLocal(url);
		}
		paused = false;
		//playing.remove(onPlayingStartAfterSetURL);

		checkAutoPlay();
	}

	public function stop()
	{
		//if (paused == false) return;
		//trace("stop");
		this.url = null;
		paused = null;
		netStream.close();
	}

	public function pause()
	{
		if (paused == true || paused == null) return;
		//trace("pause");
		paused = true;
		netStream.pause();
	}

	public function seek(offset:Float)
	{
		seekTarget = offset;
		netStream.seek(offset);
	}
	
	private function OnEvent(e:NetStatusEvent):Void 
	{
		var info:NetStatusInfo = e.info;
		//trace(info.code);
		//if (textureData != null){
		//	trace("textureData.textureAvailable = " + textureData.textureAvailable);
		//}
		if (info.code == "NetStream.Play.Start") {
			textureData.textureAvailable = 1;
			playing.value = true;
		}
		if (info.code == "NetStream.Play.Stop") {
			playing.value = false;
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
		//trace("onMetaDataReceived");
		if (this.videoMetaData != null) return;
		//trace(videoMetaData.width);

		this.videoMetaData = videoMetaData;
		// TODO: need to be able to update width/height in backend texture
		/*if (this.width == 0)*/ this.width = videoMetaData.width;
		/*if (this.height == 0)*/ this.height = videoMetaData.height;
		duration = videoMetaData.duration;
		setTextureData();

		checkAutoPlay();
		onMetaData.dispatch();
	}

	function checkAutoPlay()
	{
		Delay.killDelay(pause);
		if (!autoPlay && videoMetaData != null) {
			Delay.byFrames(5, pause);
		}
	}
	
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
		//trace(event.status);
	}

	private function renderFrame(e:Event):Void 
	{
		//trace("renderFrame");
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