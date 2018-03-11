package fuse.loader;
import flash.events.EventDispatcher;
import openfl.display.BitmapData;
import openfl.events.Event;

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
	
	#if air
		var loaderContext:LoaderContext;
	#end
	
	public var bitmapData:BitmapData;
	
	public function new() 
	{
		super();
		
		#if air
			loaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		#end
		
		loader = new NativeLoader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
	}
	
	public function load(url:String):Void
	{
		
	}
	
	function OnLoadComplete(e:Event):Void
	{
		var loaderInfo:LoaderInfo = cast (e.target, LoaderInfo);
		var content:Bitmap = cast (loaderInfo.content, Bitmap);
		bitmapData = content.bitmapData;
		//bitmapData = new BitmapData(content.bitmapData.width, content.bitmapData.height, true, 0x00000000);
		//bitmapData.draw(content.bitmapData);
		dispatchEvent(e);
	}
}