package fuse.texture;

import openfl.net.NetConnection;
import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import openfl.net.NetStream;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
import mantle.time.EnterFrame;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class VideoTexture extends BaseTexture
{
	static inline var TEXTURE_READY:String = "textureReady";
	public var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	public var loop:Bool = false;
	var url:String;

	public function new(url:String) 
	{
		var nc:NetConnection = new NetConnection();
		nc.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		nc.connect(null);
		netStream = new NetStream(nc);
		netStream.client = { onMetaData: onMetaData };
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		
		super(512, 512, false, null, false);
		this.directRender = true;

		if (url != null) play(url);
	}

	public function play(url:String) 
	{
		this.url = url;
		netStream.play(url);
	}

	public function stop()
	{
		netStream.close();
	}

	public function pause()
	{
		netStream.pause();
	}
	
	private function OnEvent(e:NetStatusEvent):Void 
	{
		var info:NetStatusInfo = e.info;
		trace(info.code);
		if (info.code == "NetStream.Buffer.Empty") {
			//nativeVideoTexture.addEventListener(TEXTURE_READY, function(e:Event) {
				textureData.textureAvailable = 1;
			//});
			//nativeVideoTexture.attachNetStream(netStream);
		}
	}
	
	public function onMetaData(videoMetaData:VideoMetaData) 
	{
		// TODO: need to be able to update width/height in backend texture
		if (this.width == 0) this.width = videoMetaData.width;
		if (this.height == 0) this.height = videoMetaData.height;
		setTextureData();
	}
	
	override public function upload() 
	{
		setTextureData();
		//createNativeTexture();
		
		/*textureBase =*/ //nativeVideoTexture = Textures.context3D.createVideoTexture();
		trace("create video texture");
		nativeVideoTexture = Textures.context3D.createVideoTexture();
		
		textureData.textureBase = nativeVideoTexture;
		
		//Textures.context3D.createTexture(64, 64, Context3DTextureFormat.BGRA, false);
		
		nativeVideoTexture.addEventListener(TEXTURE_READY, OnTextureUploadComplete);
		nativeVideoTexture.attachNetStream(netStream);
	}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		trace("TEXTURE_READY");
		nativeVideoTexture.removeEventListener(TEXTURE_READY, OnTextureUploadComplete);
		EnterFrame.add(onTick);

		textureData.placed = 0;
		Textures.registerTexture(objectId, this);
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