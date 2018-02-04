package fuse.loader;
import flash.net.URLRequest;

/**
 * ...
 * @author P.J.Shand
 */
class RemoteLoader extends Loader
{

	public function new() 
	{
		super();
	}
	
	override public function load(url:String):Void
	{
		#if air
			loader.load(new URLRequest(url), loaderContext);
		#else
			loader.load(new URLRequest(url));
		#end
	}
}