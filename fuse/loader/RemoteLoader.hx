package fuse.loader;

import openfl.net.URLRequest;

/**
 * ...
 * @author P.J.Shand
 */
class RemoteLoader extends Loader {
	public function new() {
		super();
	}

	override public function load(url:String):Void {
		loading = true;
		if (url == null) {
			trace("url = " + url);
		}
		currentURL = url;
		#if air
		loader.load(new URLRequest(url), loaderContext);
		#else
		loader.load(new URLRequest(url));
		#end
	}
}
