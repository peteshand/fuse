package mantle.net;

import openfl.display.BitmapData;
import openfl.display.Loader as OpenFLLoader;
import openfl.display.Bitmap;
import openfl.net.URLRequest;
import msignal.Signal.Signal1;
import msignal.Signal.Signal0;

/**
 * ...
 * @author P.J.Shand
 */
class Loader
{
	var loader:OpenFLLoader;
	public var onLoadComplete = new Signal1<BitmapData>();
	public var onError = new Signal0();
	
	public function new() 
	{
		
	}
	
	public function cancel() 
	{
		if (loader != null) {
			loader.close();
			loader = null;
		}
	}
	
	public function load(url:String) 
	{
		#if air
		var localURL:String = LocalFileCheckUtil.localURL(url);
		if (localURL != null) {
			loadImage(localURL);
		}
		else {
			cacheRemoteFile(url);
			loadImage(url);
		}
		#else
			loadImage(url);
		#end
	}
	
	public function dispose() 
	{
		if (loader != null){
			
			ListenerUtil.removeListeners(loader.contentLoaderInfo);
			loader = null;
		}
		onLoadComplete = null;
		onError = null;
	}
	
	function cacheRemoteFile(url:String) 
	{
		#if air
		if (url == null) return;
		if (url == "") return;
		
		var fileCacher:FileCacher = new FileCacher(url);
		fileCacher.load();
		#else
			return;
		#end
	}
	
	function loadImage(url:String) 
	{
		var request:URLRequest = new URLRequest(url);
		loader = new OpenFLLoader();
		ListenerUtil.configureListeners(loader.contentLoaderInfo, OnSuccess, OnFail);
		loader.load(request);
	}
	
	function OnFail() 
	{
		onError.dispatch();
		if (loader == null) return;
		ListenerUtil.removeListeners(loader.contentLoaderInfo);
		loader = null;
	}
	
	function OnSuccess() 
	{
		if (loader == null) return;
		
		ListenerUtil.removeListeners(loader.contentLoaderInfo);
		var bitmap:Bitmap = cast loader.content;
		if (bitmap == null) onLoadComplete.dispatch(null);
		else onLoadComplete.dispatch(bitmap.bitmapData);
		loader = null;
	}
}

#if air

#end