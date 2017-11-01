package fuse.texture;

import fuse.texture.Texture;
import fuse.core.front.texture.Textures;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.net.NetStream;
import openfl.utils.ByteArray;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class VideoTexture extends Texture
{
	static inline var TEXTURE_READY:String = "textureReady";
	var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	
	public function new(?width:Int, ?height:Int, netStream:NetStream, queUpload:Bool=false, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.netStream = netStream;
		this.netStream.client = { onMetaData: onMetaData };
		
		this.width = width;
		this.height = height;
		
		super(queUpload, onTextureUploadCompleteCallback, false);
		this.directRender = true;
	}
	
	public function onMetaData(videoMetaData:VideoMetaData) 
	{
		// TODO: need to be able to update width/height in backend texture
		this.width = videoMetaData.width;
		this.height = videoMetaData.height;
	}
	
	override public function upload() 
	{
		textureBase = nativeVideoTexture = Textures.context3D.createVideoTexture();
		nativeVideoTexture.addEventListener(TEXTURE_READY, OnTextureUploadComplete);
		nativeVideoTexture.attachNetStream(netStream);
	}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeVideoTexture.removeEventListener(TEXTURE_READY, OnTextureUploadComplete);
		
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
	}
}

typedef VideoMetaData =
{
	width:Int,
	height:Int,
	duration:Float,
	videoframerate:Int
}