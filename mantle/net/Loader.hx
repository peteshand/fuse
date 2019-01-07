package mantle.net;

#if (html5||air)
import openfl.display.Loader as OpenFLLoader;
typedef Loader = OpenFLLoader;
#else

import openfl.display.BitmapData;
import openfl.display.Loader as OpenFLLoader;
import openfl.display.Bitmap;
import openfl.net.URLRequest;
import signal.Signal1;
import signal.Signal;

/**
 * ...
 * @author P.J.Shand
 */
class Loader
{
	var loader:OpenFLLoader;
	public var onLoadComplete = new Signal1<BitmapData>();
	public var onError = new Signal();
	
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

#end