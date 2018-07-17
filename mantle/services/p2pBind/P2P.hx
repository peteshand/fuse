package mantle.services.p2pBind;
import mantle.services.p2p.PeerObject;
import mantle.notifier.Notifier;
import mantle.util.app.App;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;
using Logger;
/**
 * ...
 * @author P.J.Shand
 */
class P2P
{
	static private var connection:PeerObject;
	static public var transmitters = new Map<String, Transmitter>();
	static public var receivers = new Map<String, Receiver>();
	
	/*@:isVar static public var groupID(default, set):String = "DefaultID";
	@:isVar static public var type(default, set):P2PConnectionType = P2PConnectionType.CLOUD;
	@:isVar static public var key(default, set):String = "9d665927ed29017b901d0c6c-2978dd023407";
	@:isVar static public var idAddress(default, set):String = null;*/
	
	static public var groupID:Notifier<String>;
	static public var type:Notifier<P2PConnectionType>;
	static public var key:Notifier<String>;
	static public var idAddress:Notifier<String>;
	
	public static var connectionRefused:Signal0;
	public static var connectionSuccess:Signal0;
	public static var neighborConnect:Signal1<String>;
	public static var neighborDisconnect:Signal1<String>;
	public static var onMsg:Signal2<String, Dynamic>;
	
	public static function __init__():Void
	{
		connectionRefused	= new Signal0();
		connectionSuccess	= new Signal0();
		neighborConnect		= new Signal1(String);
		neighborDisconnect	= new Signal1(String);
		onMsg				= new Signal2(String, Dynamic);
		
		groupID = new Notifier<String>("DefaultID");
		type = new Notifier<P2PConnectionType>(P2PConnectionType.CLOUD);
		key = new Notifier<String>("9d665927ed29017b901d0c6c-2978dd023407");
		idAddress = new Notifier<String>(null);
		
		groupID.add(UpdateConnection);
		type.add(UpdateConnection);
		key.add(UpdateConnection);
		idAddress.add(UpdateConnection);
		UpdateConnection();
		
		/*groupID = "DefaultID";
		type = P2PConnectionType.CLOUD;
		key = "9d665927ed29017b901d0c6c-2978dd023407";*/
	}
	
	public function new() { }
	
	public static function bind(notifier:Notifier<Dynamic>, id:String, transmit:Bool, receive:Bool):Void
	{
		if (transmit) transmitters.set(id, new Transmitter(notifier, id));
		if (receive) receivers.set(id, new Receiver(notifier, id));
	}
	
	static public function unbind(id:String, transmit:Bool=true, receive:Bool=true) 
	{
		if (transmit && transmitters.exists(id)) {
			var transmitter = transmitters.get(id);
			transmitter.dispose();
			transmitters.remove(id);
		}
		if (receive && receivers.exists(id)) {
			var receiver = receivers.get(id);
			receiver.dispose();
			receivers.remove(id);
		}
	}
	
	/*static function get_connection():PeerObject 
	{
		if (_connection == null) {
			var _connection = new PeerObject("P2PNotifier");
			_connection.connect("rtmfp:");
			_connection.start();
		}
		trace(_connection == null);
		return _connection;
	}
	
	static function set_connection(value:PeerObject):PeerObject 
	{
		if (_connection != null) {
			_connection.stop();
			_connection.dispose();
			_connection = null;
		}
		_connection = value;
		return _connection;
	}*/
	
	/*static function get_groupID():String 
	{
		return groupID;
	}*/
	
	/*static function set_groupID(value:String):String 
	{
		groupID = value;
		UpdateConnection();
		return groupID;
	}*/
	
	/*static function get_type():P2PConnectionType 
	{
		return type;
	}*/
	
	/*static function set_type(value:P2PConnectionType):P2PConnectionType 
	{
		type = value;
		UpdateConnection();
		return type;
	}*/
	
	/*static function get_key():String 
	{
		return key;
	}*/
	
	/*static function set_key(value:String):String 
	{
		key = value;
		UpdateConnection();
		return key;
	}*/
	
	/*static function get_idAddress():String 
	{
		return idAddress;
	}*/
	
	/*static function set_idAddress(value:String):String 
	{
		idAddress = value;
		UpdateConnection();
		return idAddress;
	}*/
	
	
	static private function UpdateConnection() 
	{
		if (P2P.connection != null) {
			
			P2P.connection.connectionRefused.removeAll();
			P2P.connection.connectionSuccess.removeAll();
			P2P.connection.neighborConnect.removeAll();
			P2P.connection.neighborDisconnect.removeAll();
			P2P.connection.onMsg.removeAll();
			
			P2P.connection.stop();
			P2P.connection.dispose();
			P2P.connection = null;
		}
		
		var peerObject = new PeerObject(groupID.value);
		if (type.value == P2PConnectionType.CLOUD) {
			peerObject.connect("rtmfp://p2p.rtmfp.net/" + key.value + "/");
		}
		else if (type.value == P2PConnectionType.LOCAL) {
			if (idAddress.value == null) {
				peerObject = null;
				Logger.error(P2P, "Valid server idAddress must be set when using LOCAL p2p connection type");
				return;
			}
			else peerObject.connect("rtmfp://" + idAddress.value);
		}
		else if (type.value == P2PConnectionType.SERVERLESS) {
			peerObject.connect("rtmfp:");
		}
		
		peerObject.start();
		
		peerObject.connectionRefused.add(connectionRefused.dispatch);
		peerObject.connectionSuccess.add(connectionSuccess.dispatch);
		peerObject.neighborConnect.add(neighborConnect.dispatch);
		peerObject.neighborDisconnect.add(neighborDisconnect.dispatch);
		peerObject.onMsg.add(onMsg.dispatch);
		
		P2P.connection = peerObject;
	}
	
	public static function send(payload:Dynamic):Void 
	{
		if (P2P.connection != null) {
			P2P.connection.send(payload);
		}
	}
}