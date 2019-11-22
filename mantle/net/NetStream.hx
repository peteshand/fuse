package mantle.net;

#if (electron || air)
import mantle.net.LocalFileCheckUtil;
import openfl.errors.Error;
import openfl.filesystem.File;
import openfl.net.NetConnection;
import openfl.net.NetStream as OpenFlNetStream;
import signals.Signal;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
class NetStream extends OpenFlNetStream {
	public var onComplete = new Signal();
	public var onError = new Signal();
	public var url:String;

	public function new(connection:NetConnection, peerID:String = null) {
		super(connection, peerID);

		#if (js && html5)
		// DEBUG
		// js.Browser.document.body.insertBefore(__video, js.Browser.document.body.firstChild);
		// __video.style.setProperty("width", "200px");
		#end
	}

	public function playLocal(url:String):Void {
		this.url = url;
		if (url == null)
			return;

		var _localURL:String = localURL(url);
		if (_localURL != null) {
			this.play(_localURL);
		} else {
			download(url);
			this.play(url);
		}
	}

	#if html5
	override public function play(url:String, ?_, ?_, ?_, ?_, ?_):Void {
		if (__video == null)
			return;

		try {
			// unlink MediaSource from video tag
			__video.src = url;
			__video.addEventListener('canplay', beginPlay);
		} catch (err:Dynamic) {
			trace("Error playing: " + url);
		}
	}

	function beginPlay():Void {
		__video.play();
	}

	override public function close():Void {
		if (__video != null)
			__video.removeEventListener('canplay', beginPlay);
		super.close();
	}

	override public function pause():Void {
		if (__video != null)
			__video.removeEventListener('canplay', beginPlay);
		super.pause();
	}
	#end

	public static function localURL(url:String):String {
		if (url == null)
			return null;
		url = url.split("\n").join("");
		url = url.split("\t").join("");
		return LocalFileCheckUtil.localURL(url);
	}

	public static function hasLocalCopy(url:String):Bool {
		return new File(localURL(url)).exists;
	}

	public function download(url:String, onComplete:Void->Void = null, onError:Void->Void = null) {
		if (url == null) {
			throw new Error("localURL should not be null");
		}
		var cacher = new FileCacher(url);
		if (onComplete != null) {
			cacher.onComplete.add(onComplete);
			cacher.onError.add(onError);
			cacher.onComplete.add(this.onComplete.dispatch);
			cacher.onError.add(this.onError.dispatch);
		}
	}
}
#else
import openfl.net.NetStream as OpenFlNetStream;
import signals.Signal;

class NetStream extends OpenFlNetStream {
	public var onComplete = new Signal();
	public var onError = new Signal();
	public var url:String;

	public function playLocal(url:String):Void {
		this.play(url);
	}
}
#end
