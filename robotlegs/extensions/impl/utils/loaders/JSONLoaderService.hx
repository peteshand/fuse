package robotlegs.extensions.impl.utils.loaders; 

import haxe.Json;
import openfl.errors.Error;
import openfl.net.URLRequestHeader;
import org.osflash.signals.Signal;



import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author Thomas Byrne
 */
class JSONLoaderService 
{
	
	public function new() 
	{
		
	}
	
	public function load(url:String, onComplete:Dynamic->Void=null, onFail:String->Void=null):JSONLoader
	{
		var jsonLoader:JSONLoader = new JSONLoader(url, onComplete, onFail);
		jsonLoader.load(url);
		return jsonLoader;
	}
	
	private function DelayLoad(jsonLoader:JSONLoader, url:String):Void 
	{
		jsonLoader.load(url);
	}
	
}

class JSONLoader
{
	public var available:Bool = true;
	public var url:String;
	
	private var request:URLRequest;
	private var loader:URLLoader;
	
	public var onComplete : Dynamic -> Void;
	public var onFail : String -> Void;
	
	public function new(url:String="", onComplete:Dynamic -> Void=null, onFail:String -> Void=null)
	{
		this.url = url;
		if (onComplete!=null) this.onComplete = onComplete;
		if (onFail!=null) this.onFail = onFail;
		
	}
	
	public function load(url:String):Void
	{
		this.url = url;
		
		if (loader==null) {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, OnLoadComplete);
			loader.addEventListener(ErrorEvent.ERROR, OnError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, OnError);
		}
		
		available = false;
		request = new URLRequest(url);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "text/plain")); // Prevents CORS issue
		//request.requestHeaders.push(new URLRequestHeader("Access-Control-Allow-Origin", "*"));
		loader.load(request);
	}
	
	private function OnLoadComplete(e:Event):Void 
	{
		available = true;
		var res:Dynamic;
		try{
			res = Json.parse(loader.data);
		}catch(e:Error){
			onFail(Std.string(e));
			this.dispose();
			return;
		}
		onComplete(res);
		this.dispose();
	}
	
	private function OnError(e:ErrorEvent):Void 
	{
		trace("[JSONLoaderService] Load Error: " + e);
		available = true;
		
		onFail(e.toString());
		
		// replaced with onFail
		//onComplete.dispatch(null, url);
	}
	
	public function dispose():Void 
	{
		loader.removeEventListener(Event.COMPLETE, OnLoadComplete);
		loader.removeEventListener(ErrorEvent.ERROR, OnError);
		loader = null;
		request = null;
		onComplete = null;
	}
}