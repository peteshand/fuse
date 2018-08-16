package fuse.texture;

import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import openfl.net.NetStream;
import openfl.utils.ByteArray;
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
	var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	
	public function new(?width:Int, ?height:Int, netStream:NetStream, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.netStream = netStream;
		this.netStream.client = { onMetaData: onMetaData };
		this.netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
		
		super(width, height, false, onTextureUploadCompleteCallback, false);
		this.directRender = true;
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