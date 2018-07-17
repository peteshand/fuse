package mantle.services.p2pBind;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class Receiver
{
	var notifier:Notifier<Dynamic>;
	var id:String;
	
	public function new(notifier:Notifier<Dynamic>, id:String) 
	{
		this.id = id;
		this.notifier = notifier;
		
		P2P.onMsg.add(onMsg);
	}
	
	function onMsg(neighborId:String, data:Dynamic) 
	{
		if (Reflect.hasField(data, "P2PNotifier-" + id)) {
			notifier.value = Reflect.getProperty(data, "P2PNotifier-" + id);
		}
	}
	
	public function dispose() 
	{
		notifier = null;
		id = null;
		P2P.onMsg.remove(onMsg);
	}
}