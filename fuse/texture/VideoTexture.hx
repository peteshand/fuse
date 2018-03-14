package fuse.texture;

import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.net.NetStream;
import openfl.utils.ByteArray;
import openfl.display3D.textures.VideoTexture as NativeVideoTexture;
/**
 * ...
 * @author P.J.Shand
 */

@:forward(textureData, nativeTexture, textureBase, textureId, width, height, onUpdate, clearColour, _clear, _alreadyClear, upload, dispose)
abstract VideoTexture(AbstractTexture) to Int from Int 
{
	var baseVideoTexture(get, never):BaseVideoTexture;
	
	public function new(?width:Int, ?height:Int, netStream:NetStream, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		var baseVideoTexture:BaseVideoTexture = new BaseVideoTexture(width, height, netStream, onTextureUploadCompleteCallback);
		this = new AbstractTexture(baseVideoTexture);
	}
	
	function upload():Void										{ baseVideoTexture.upload(); 					}
	function get_baseVideoTexture():BaseVideoTexture			{ return untyped this.coreTexture; 				}
	@:to public function toAbstractTexture():AbstractTexture	{ return this; 									}
}

@:access(fuse)
class BaseVideoTexture extends BaseTexture
{
	static inline var TEXTURE_READY:String = "textureReady";
	var netStream:NetStream;
	public var nativeVideoTexture:NativeVideoTexture;
	
	public function new(?width:Int, ?height:Int, netStream:NetStream, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.netStream = netStream;
		this.netStream.client = { onMetaData: onMetaData };
		
		super(width, height, false, onTextureUploadCompleteCallback, false);
		this.directRender = true;
	}
	
	public function onMetaData(videoMetaData:VideoMetaData) 
	{
		// TODO: need to be able to update width/height in backend texture
		this.width = videoMetaData.width;
		this.height = videoMetaData.height;
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