package fuse.loader;

import flash.net.URLRequest;

/**
 * ...
 * @author P.J.Shand
 */
class RemoteLoader extends Loader
{
	public static function init()
	{
		//#if (air||flash)
		//new RemoteLoader().load("");
		//#end
	}
	
	public function new() 
	{
		super();
	}
	
	override public function load(url:String):Void
	{
		currentURL = url;
		#if air
			loader.load(new URLRequest(url), loaderContext);
		#else
			loader.load(new URLRequest(url));
		#end
	}
}