package robotlegs.extensions.impl.services.email;

import openfl.errors.Error;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;

/**
 * ...
 * @author P.J.Shand
 */
@:rtti
@:keepSub
class EmailService 
{
	private var serverScript:String = "";
	private var emails:Array<String> = [];
	
	public function new()
	{
		
	}
	
	public function init(serverScript:String):Void
	{
		this.serverScript = serverScript;
	}
	
	public function addAddress(email:String):Void
	{
		emails.push(email);
	}
	
	public function send(subject:String, body:String):Void
	{
		if (serverScript == "") {
			throw new Error("EmailService.init(...) needs to be called first");
			return;
		}
		
		for (i in 0...emails.length) 
		{
			var variables:URLVariables = new URLVariables();
			variables.to = emails[i];
			variables.from = "noreply@imagsyd.com";
			variables.subject = subject;
			variables.body = body;
			
			var request:URLRequest = new URLRequest(serverScript);
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, OnSendComplete);
			urlLoader.load(request);
			
			trace("Send Email to: " + emails[i]);
		}
	}
	
	private function OnSendComplete(e:Event):Void 
	{
		cast(e.target, URLLoader).removeEventListener(Event.COMPLETE, OnSendComplete);
		trace("TEST REPORT SENT: " + e);
	}
}