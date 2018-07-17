package robotlegs.extensions.impl.utils.loaders;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class XMLLoaderService 
{
	public function new() 
	{
		
	}
	
	public function load(url:String, onComplete:Xml->Void=null, onFail:String->Void=null):XMLLoader
	{
		var xmlLoader:XMLLoader = new XMLLoader();
		xmlLoader.load(url);
		xmlLoader.onComplete = onComplete;
		xmlLoader.onFail = onFail;
		return xmlLoader;
	}
}



class XMLLoader
{
	public var available:Bool = true;
	public var url:String;
	
	private var request:URLRequest;
	private var loader:URLLoader;
	
	public var onComplete:Xml->Void;
	public var onFail:String->Void;
	
	public function new(url:String="")
	{
		this.url = url;
	}
	
	public function load(url:String):Void
	{
		this.url = url;
		if (loader == null) {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, OnLoadComplete);
			loader.addEventListener(ErrorEvent.ERROR, OnError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
			
		}
		
		available = false;
		request = new URLRequest(url);
		loader.load(request);
	}
	
	private function OnLoadComplete(e:Event):Void 
	{
		available = true;
		
		var data:String = loader.data;
		loader.close();
		
		var xml:Xml = null;
		
		try{
			xml = Xml.parse(data);
		}catch (e:Error) {
			onFail(Std.string(e));
			return;
		}
		onComplete(xml);
	}
	
	private function OnError(e:ErrorEvent):Void 
	{
		trace("Load Error: " + e);
		available = true;
		onFail(e.toString());
	}
	
	public function dispose():Void 
	{
		if (loader != null){
			loader.removeEventListener(Event.COMPLETE, OnLoadComplete);
			loader.removeEventListener(ErrorEvent.ERROR, OnError);
			loader = null;
		}
		request = null;
		onComplete = null;
	}
}