package mantle.util.texture;

import openfl.utils.ByteArray;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display3D.Context3DTextureFormat;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import starling.textures.Texture;

/**
 * ...
 * @author P.J.Shand
 */
class TextureLoader
{
	static var loaders = new Map<String, TextureLoaderInstance>();
	
	public function new() 
	{
		
	}
	
	static public function load(url:String, callback:Texture -> Void) 
	{
		var loader = loaders.get(url);
		if (loader == null) {
			loader = new TextureLoaderInstance(url);
			loaders.set(url, loader);
		}
		loader.load(callback);
	}
}

class TextureLoaderInstance
{
	static var loaderContext:LoaderContext;
	static var que:Array<TextureLoaderInstance> = [];
	static var busy:Bool = false;
	
	var loader:Loader;
	var callbacks:Array<Texture-> Void> = [];
	var texture:Texture;
	var url:String;
	//var ATFLoader:Bool = false;
	var atfLoader:URLLoader;
	
	public function new(url:String) 
	{
		this.url = url;
		
		if (url.indexOf(".atf") != -1) {
			//ATFLoader = true;
			atfLoader = new URLLoader();
			atfLoader.dataFormat = URLLoaderDataFormat.BINARY;
			atfLoader.addEventListener(Event.COMPLETE, OnLoad);
			atfLoader.addEventListener(ErrorEvent.ERROR, OnError);
		}
		else {
			if (loaderContext == null){
				loaderContext = new LoaderContext();
				Reflect.setProperty(loaderContext, "imageDecodingPolicy", "onLoad");
			}
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoad);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, OnError);
		}
		
		TextureLoaderInstance.addToQue(this);
	}
	
	static function addToQue(textureLoaderInstance:TextureLoaderInstance) 
	{
		que.push(textureLoaderInstance);
		LoadNext();
	}
	
	static private function LoadNext() 
	{
		if (TextureLoaderInstance.busy) return;
		if (que.length == 0) return;
		
		TextureLoaderInstance.busy = true;
		var current:TextureLoaderInstance = que.shift();
		current.start();
	}
	
	function start() 
	{
		if (atfLoader != null) {
			atfLoader.load(new URLRequest(url));
		}
		else {
			loader.load(new URLRequest(url), loaderContext);
		}
		
	}
	
	public function load(callback:Texture-> Void) 
	{
		if (texture == null) callbacks.push(callback);
		else callback(texture);
	}
	
	private function OnError(e:ErrorEvent):Void 
	{
		trace(e);
	}
	
	private function OnLoad(e:Event):Void 
	{
		//trace("OnLoad: " + url);
		if (atfLoader != null) {
			var bytes:ByteArray = atfLoader.data;
			this.texture = Texture.fromAtfData(bytes, 1, false, OnUploadComplete);
		}
		else {
			var bitmap:Bitmap = cast (loader.content, Bitmap);
			this.texture = Texture.fromBitmapData(bitmap.bitmapData, false, false, 1, Context3DTextureFormat.BGRA, false);
			OnUploadComplete(texture);
		}
		
	}
	
	function OnUploadComplete(texture:Texture) 
	{
		//trace("OnUploadComplete: " + url);
		//this.texture = texture;
		
		var i:Int = callbacks.length - 1;
		while (i >= 0) 
		{
			callbacks[i](texture);
			callbacks.splice(i, 1);
			i--;
		}
		
		TextureLoaderInstance.busy = false;
		LoadNext();
	}
}