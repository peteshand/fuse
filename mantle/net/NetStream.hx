package mantle.net;

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
	public function new(connection:NetConnection, peerID:String=null) 
	{
		super(connection, peerID);
		
		//__video.setAttribute("preload", "auto");
	}
	
	public function playLocal(url:String):Void
	{
		if (url == null) return;
		
		var _localURL:String = localURL(url);
		trace("url = " + url);
		trace("localURL = " + _localURL);
		if (_localURL == null) {
			trace("localURL = " + _localURL);
		}
		
		if (_localURL != null) {
			this.play(_localURL);
		}
		else {
			download(url);
			this.play(url);
		}
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
		if (onComplete != null) cacher.onComplete.add(onComplete);
	}
}