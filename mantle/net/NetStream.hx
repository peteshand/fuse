package mantle.net;

#if (electron||air)

import mantle.net.LocalFileCheckUtil;
import openfl.errors.Error;
import mantle.filesystem.File;
import openfl.net.NetConnection;
import openfl.net.NetStream as OpenFlNetStream;

/**
 * ...
 * @author P.J.Shand
 */

class NetStream extends OpenFlNetStream
{
	public var url:String;
	public function new(connection:NetConnection, peerID:String=null) 
	{
		super(connection, peerID);
		
		#if (js && html5)
			// DEBUG
			//js.Browser.document.body.insertBefore(__video, js.Browser.document.body.firstChild);
			//__video.style.setProperty("width", "200px");
		#end
	}
	
	public function playLocal(url:String):Void
	{
		this.url = url;
		this.close();
		if (url == null) return;
		
		
		var _localURL:String = localURL(url);
		if (_localURL != null) {
			this.play(_localURL);
		}
		else {
			download(url);
			this.play(url);
		}
	}

	override public function close()
	{
		super.close();
	}

	public static function localURL(url:String):String
	{
		if (url == null) return null;
		url = url.split("\n").join("");
		url = url.split("\t").join("");
		return LocalFileCheckUtil.localURL(url);
	}

	public static function hasLocalCopy(url:String):Bool
	{
		return new File(localURL(url)).exists;
	}
	
	public function download(url:String, onComplete:Void -> Void = null) 
	{
		if (url == null) {
			throw new Error("localURL should not be null");
		}
		var cacher = new FileCacher(url);
		if (onComplete != null) {
			cacher.onComplete.add(onComplete);
			cacher.onError.add(onComplete);
		}
	}
}

#else

import openfl.net.NetStream as OpenFlNetStream;

class NetStream extends OpenFlNetStream
{
	public function playLocal(url:String):Void
	{
		this.play(url);
	}
}
#end