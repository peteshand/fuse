package fuse.loader;

import openfl.events.EventDispatcher;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.LoaderInfo;
import openfl.display.Loader as NativeLoader;
#if air
	import flash.system.LoaderContext;
	import flash.system.ImageDecodingPolicy;
#end

/**
 * ...
 * @author P.J.Shand
 */
class Loader extends EventDispatcher implements ILoader
{
	var loader:NativeLoader;
	public var loading:Bool = false;

	#if air
		var loaderContext:LoaderContext;
	#end
	
	public var bitmapData:BitmapData;
	var currentURL:String;

	public function new() 
	{
		super();
		
		#if air
			loaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		#end
		
		loader = new NativeLoader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnError);
	}
	
	private function OnError(e:IOErrorEvent):Void 
	{
		trace(e + ", " + currentURL);
		loading = false;
		dispatchEvent(e);
	}
	
	public function load(url:String):Void
	{
		loading = true;
		currentURL = url;
	}
	
	function OnLoadComplete(e:Event):Void
	{
		var loaderInfo:LoaderInfo = cast (e.target, LoaderInfo);
		var content:Bitmap = cast (loaderInfo.content, Bitmap);
		//bitmapData = content.bitmapData;
		bitmapData = new BitmapData(Math.floor(content.width), Math.floor(content.height), true, 0x0);
		bitmapData.draw(content);
		loading = false;
		dispatchEvent(e);
	}
}