package fuse.utils.videoPlayer;

import openfl.events.NetStatusEvent;
import openfl.net.NetConnection;
import mantle.net.NetStream;

/**
 * ...
 * @author P.J.Shand
 */
class VideoPlayer {
	public var netStream:NetStream;
	public var loop:Bool = false; // TODO: fix issues

	public function new(_netStream:NetStream = null) {
		if (_netStream == null) {
			var nc:NetConnection = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
			nc.connect(null);
			netStream = new NetStream(nc);
		} else {
			netStream = _netStream;
		}
		netStream.addEventListener(NetStatusEvent.NET_STATUS, OnEvent);
	}

	public function play(url:String) {
		netStream.playLocal(url);
	}

	public function stop() {
		netStream.pause();
		netStream.close();
	}

	private function OnEvent(e:NetStatusEvent):Void {
		var info:NetStatusInfo = e.info;
		// trace("info.code = " + info.code);
		if (loop) {
			if (info.code == "NetStream.Play.Stop") {
				// netStream.pause();
				netStream.seek(0);
				#if html5
				netStream.togglePause();
				#end
			}
		}
	}
}

typedef NetStatusInfo = {
	level:String,
	code:String
}
