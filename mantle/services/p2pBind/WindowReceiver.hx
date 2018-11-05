package mantle.services.p2pBind;

import js.Browser;
import haxe.Json;
import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class WindowReceiver
{
	var notifier:Notifier<Dynamic>;
	var id:String;
	
	public function new(notifier:Notifier<Dynamic>, id:String) 
	{
		this.id = id;
		this.notifier = notifier;
		
		Browser.window.addEventListener('message', onMsg, false);
	}
	
	function onMsg(event) 
	{
		var message:WindowMessage = event.data;
		if (message.id == id){
			if (message.payload == null) notifier.value = null;
			else notifier.value = Json.parse(message.payload);
		}
	}
	
	public function dispose() 
	{
		notifier = null;
		id = null;
	}
}