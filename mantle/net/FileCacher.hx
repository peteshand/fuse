package mantle.net;

import mantle.filesystem.FileMode;
import mantle.filesystem.FileStream;
import openfl.utils.ByteArray;
import mantle.filesystem.File;
import msignal.Signal.Signal0;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;

class FileCacher
{
	var urlLoader:URLLoader;
	var localFile:File;
	var url:String;
	public var onComplete = new Signal0();
	public var onError = new Signal0();
	
	public function new(url:String = null)
	{
		urlLoader = new URLLoader();
		ListenerUtil.configureListeners(urlLoader, OnSuccess, OnFail);
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
		//trace("LOAD: " + url);
		
		
		var localPath:String = LocalFileCheckUtil.localPath(this.url);
		if (localPath == null) return;
		if (localPath == "") return;
		//trace("localPath: " + localPath);
		
		this.localFile = new File().resolvePath(localPath);
		
		if (localFile.exists) {
			onComplete.dispatch();
			return;
		}
		
		//trace("load: " + url);
		urlLoader.load(new URLRequest(this.url));
	}
	
	function OnFail()
	{
		ListenerUtil.removeListeners(urlLoader);
		onError.dispatch();
	}
	
	function OnSuccess() 
	{
		ListenerUtil.removeListeners(urlLoader);
		var data:ByteArray = cast urlLoader.data;
		var fileStream:FileStream = new FileStream();
		fileStream.open(localFile, FileMode.WRITE);
		fileStream.writeBytes(data, 0, data.length);
		fileStream.close();
		onComplete.dispatch();
	}
}