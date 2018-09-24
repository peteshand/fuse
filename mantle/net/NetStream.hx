package mantle.net;

import mantle.net.LocalFileCheckUtil;
import openfl.errors.Error;
import openfl.net.NetConnection;

/**
 * ...
 * @author P.J.Shand
 */
class NetStream extends openfl.net.NetStream
{
	
	public function new(connection:NetConnection, peerID:String=null) 
	{
		super(connection, peerID);
		
	}

	public function playLocal(url:String):Void
	{
		if (url == null) {
			trace("url = null");
			return;
		}
		
		url = url.split("\n").join("");
		url = url.split("\t").join("");
		
		var localURL:String = LocalFileCheckUtil.localURL(url);
		trace("url = " + url);
		trace("localURL = " + localURL);
		if (localURL == null) {
			trace("localURL = " + localURL);
		}
		
		if (localURL != null) {
			this.play(localURL);
		}
		else {
			download(url);
			this.play(url);
		}
	}
	
	function download(url:String) 
	{
		if (url == null) {
			throw new Error("localURL should not be null");
		}
		new FileCacher(url);
	}
}