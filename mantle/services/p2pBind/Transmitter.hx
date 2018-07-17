package mantle.services.p2pBind;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class Transmitter
{
	var notifier:Notifier<Dynamic>;
	var id:String;
	
	public function new(notifier:Notifier<Dynamic>, id:String) 
	{
		this.id = id;
		this.notifier = notifier;
		P2P.neighborConnect.add(OnNeighborConnect);
		notifier.add(SetCurrentValue);
	}
	
	function OnNeighborConnect(neighborId:String) 
	{
		SetCurrentValue();
	}
	
	private function SetCurrentValue():Void 
	{
		var sendObj:Dynamic = { };
		Reflect.setProperty(sendObj, "P2PNotifier-" + id, notifier.value);
		P2P.send(sendObj);
	}
	
	public function dispose() 
	{
		notifier = null;
		id = null;
		P2P.neighborConnect.remove(OnNeighborConnect);
		notifier.remove(SetCurrentValue);
	}
}