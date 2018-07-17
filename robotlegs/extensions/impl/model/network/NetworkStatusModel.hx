package robotlegs.extensions.impl.model.network;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class NetworkStatusModel 
{
	public var connected = new Notifier<Bool>(null);
	
	public function new() 
	{
		
	}
}