package mantle.services.p2pBind;

import haxe.Json;
import notifier.Notifier;
import js.html.Window;

/**
 * ...
 * @author P.J.Shand
 */
class WindowTransmitter {
	var notifier:Notifier<Dynamic>;
	var id:String;

	public function new(notifier:Notifier<Dynamic>, id:String) {
		this.id = id;
		this.notifier = notifier;
		// P2P.neighborConnect.add(OnNeighborConnect);
		notifier.add(setCurrentValue);
	}

	function OnNeighborConnect(neighborId:String) {
		setCurrentValue();
	}

	public function setCurrentValue():Void {
		var message:WindowMessage = {
			id: id,
			payload: Json.stringify(notifier.value)
		}
		P2P.send(id, message);
	}

	public function dispose() {
		if (notifier != null) {
			notifier.remove(setCurrentValue);
		}
		notifier = null;
		id = null;
	}
}
