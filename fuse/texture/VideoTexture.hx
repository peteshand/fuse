package fuse.texture;

import openfl.events.Event;
import openfl.events.VideoTextureEvent;
import msignal.Signal.Signal0;
import openfl.net.NetConnection;
import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import mantle.net.NetStream;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
import mantle.time.EnterFrame;
import openfl.display3D.Context3D;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class VideoTexture extends BaseTexture
{
	public var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	public var loop:Bool = false;
	public var duration:Null<Float>;
	var url:String;
	public var time(get, null):Float;
	@:isVar public var onComplete(get, null):Signal0;

	var paused:Bool = false;
	var videoMetaData:VideoMetaData;

	public function new(url:String=null) 
	{
		trace("supportsVideoTexture = " + Context3D.supportsVideoTexture);

		var nc:NetConnection = new NetConnection();
		nc.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		nc.connect(null);
		netStream = new NetStream(nc);
		netStream.client = { onMetaData: onMetaData };
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		
		super(512, 512, false, null, false);
		this.directRender = true;

		//if (url != null) play(url);
	}

	public function play(url:String=null) 
	{
		trace("play");
		trace("paused = " + paused);
		if (paused) {
			netStream.togglePause();
		} else {
			if (url == null && this.url != null) url = this.url;
			duration = null;
			this.url = url;
			paused = false;
			videoMetaData = null;
			netStream.playLocal(url);
		}
		
	}

	public function stop()
	{
		trace("stop");
		paused = false;
		netStream.close();
	}

	public function pause()
	{
		trace("pause");
		//netStream.togglePause();
		paused = true;
		netStream.pause();
	}

	public function seek(offset:Float)
	{
		trace("seek");
		netStream.seek(offset);
	}
	
	private function OnEvent(e:NetStatusEvent):Void 
	{
		var info:NetStatusInfo = e.info;
		trace(info.code);
		if (textureData != null){
			trace("textureData.textureAvailable = " + textureData.textureAvailable);
		}
		if (info.code == "NetStream.Play.Start") {
			textureData.textureAvailable = 1;
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
	
	public function onMetaData(videoMetaData:VideoMetaData) 
	{
		if (this.videoMetaData != null) return;

		this.videoMetaData = videoMetaData;
		// TODO: need to be able to update width/height in backend texture
		if (this.width == 0) this.width = videoMetaData.width;
		if (this.height == 0) this.height = videoMetaData.height;
		duration = videoMetaData.duration;
		setTextureData();
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
		trace(event.status);
	}

	private function renderFrame(e:Event):Void 
	{
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