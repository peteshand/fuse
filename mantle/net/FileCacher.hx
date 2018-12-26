package mantle.net;

import mantle.filesystem.FileMode;
import mantle.filesystem.FileStream;
import openfl.utils.ByteArray;
import mantle.filesystem.File;
import notifier.Signal;
import notifier.Signal1;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.ProgressEvent;

class FileCacher
{
	var urlLoader:URLLoader;
	public var localFile:File;
	var url:String;
	public var onComplete = new Signal();
	public var onProgress = new Signal1<Float>();
	public var onError = new Signal();
	
	public function new(url:String = null)
	{
		urlLoader = new URLLoader();
		ListenerUtil.configureListeners(urlLoader, onSuccess, onFail, onProgressChange);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		
		
		if (url != null) {
			load(url);
		}
	}
	
	public function load(url:String=null) 
	{
		if (url != null) {
			url = url.split("\n").join("");
			url = url.split("\t").join("");
			this.url = url;
		}
		
		var localPath:String = LocalFileCheckUtil.localPath(this.url);
		//trace("localPath = " + localPath);
		if (localPath == null || localPath == "") {
			onError.dispatch();
			return;
		}
		//trace("localPath: " + localPath);
		
		this.localFile = new File(localPath);
		
		if (localFile.exists) {
			onComplete.dispatch();
			return;
		}
		
		//trace("load: " + url);
		urlLoader.load(new URLRequest(this.url));
	}
	
	function onFail(event:Event)
	{
		trace("onFail: " + url);
		ListenerUtil.removeListeners(urlLoader);
		onError.dispatch();
	}
	
	function onSuccess(event:Event) 
	{
		ListenerUtil.removeListeners(urlLoader);
		var data:ByteArray = cast urlLoader.data;
		var fileStream:FileStream = new FileStream();
		fileStream.open(localFile, FileMode.WRITE);
		fileStream.writeBytes(data, 0, data.length);
		fileStream.close();
		onComplete.dispatch();
	}

	function onProgressChange(event:ProgressEvent)
	{
		if (event.bytesTotal != 0) {
			onProgress.dispatch(event.bytesLoaded / event.bytesTotal);
		}
	}
}