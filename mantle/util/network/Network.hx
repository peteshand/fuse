package mantle.util.network;
import mantle.notifier.Notifier;
import remove.util.time.Timer;
import flash.events.Event;
import mloader.Http;

#if (ios || android)
import com.freshplanet.nativeExtensions.AirNetworkInfo as NetworkInfo;
import com.freshplanet.nativeExtensions.NativeNetworkInterface as NetworkInterface;
#else
import flash.net.NetworkInfo;
import flash.net.NetworkInterface;
#end

/**
 * ...
 * @author Thomas Byrne
 */
class Network
{
	static var _ipChangeHandlers:Array<Void->Void> = [];
	static var _listening:Bool;
	static var _pollTimer:Timer;
	static var _hardwareConnected:Bool;
	static var _currPollInd:Int = 0;
	
	@:isVar static public var ipAddress(get, null):String;
	@:isVar static public var broadcastAddress(get, null):String;
	@:isVar static public var macAddress(get, null):String;
	@:isVar static public var isSupported(get, null):Bool;
	@:isVar static public var isConnected(get, null):Notifier<Bool>;
	
	@:isVar static public var pollAddresses:Array<String> = ["adobe.com", "apple.com", "google.com"];
	@:isVar static public var pollTimeout(default, set):Int = 5000;
	
	static private function beginListening() 
	{
		_listening = true;
		_pollTimer = new Timer(doPoll, pollTimeout);
		isConnected = new Notifier(false);
		NetworkInfo.networkInfo.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
		onNetworkChange();
	}
	
	static private function onNetworkChange(?e:Event):Void 
	{
		checkIP();
	}
	
	static private function checkIP() 
	{
		var newIP = null;
		var newMAC = null;
		var newBroadcast = null;
		var interfaces = NetworkInfo.networkInfo.findInterfaces();
		for(inter in interfaces) {
			if (!inter.active) continue;
			
			#if (ios || android)
				newMAC = inter.hardwareAddress;
				break;
			#else
				for(addr in inter.addresses) {
					if (addr.ipVersion == "IPv4" && addr.address != null && addr.address!="127.0.0.1") {
						newIP = addr.address;
						newMAC = inter.hardwareAddress;
						newBroadcast = addr.broadcast;
						break;
					}
				}
				if (newIP != null) break;
			#end
		}
		
		var hardwareConected:Bool;
		#if (ios || android)
			hardwareConected = NetworkInfo.networkInfo.isConnected();
		#else
			hardwareConected = (newIP != null);
		#end
		
		if (_hardwareConnected != hardwareConected){
			_hardwareConnected = hardwareConected;
			if (_hardwareConnected){
				if (pollAddresses==null || pollAddresses.length == 0){
					isConnected.value = true;
					_pollTimer.stop();
				}else{
					doPoll();
				}
			}else{
				isConnected.value = false;
				_pollTimer.stop();
			}
		}
		
		var ipChange = newIP != ipAddress;
		if (ipChange || newMAC != macAddress || newBroadcast != broadcastAddress) {
			ipAddress = newIP;
			macAddress = newMAC;
			broadcastAddress = newBroadcast;
			if(ipChange){
				for (handler in _ipChangeHandlers) {
					handler();
				}
			}
		}
	}
	
	static private function doPoll() 
	{
		_currPollInd = 0;
		pollNext();
	}
	
	static private function pollNext() 
	{
		var address = pollAddresses[_currPollInd];
		// TODO: Use an Http system that doesn't require so much allocation
		var http = new Http("http://" + address + "/");
		http.onStatus = onPollStatus.bind(_, http);
		http.onError = onPollError;
		http.request();
	}
	
	static private function onPollStatus(status:Int, http:Http) 
	{
		http.onStatus = null;
		http.onError = null;
		if (status != 404 && status != 503){
			isConnected.value = true;
			_pollTimer.go();
		}else{
			onPollError();
		}
	}
	static private function onPollError(?res:String) 
	{
		if (_currPollInd >= pollAddresses.length - 1){
			isConnected.value = false;
			_pollTimer.go();
		}else{
			_currPollInd++;
			pollNext();
		}
	}
	
	static function get_isSupported():Bool 
	{
		#if (ios || android)
			return true;
		#else
			return NetworkInfo.isSupported;
		#end
	}
	
	static function get_ipAddress():String 
	{
		if (!_listening) {
			beginListening();
		}
		return ipAddress;
	}
	
	static function get_macAddress():String 
	{
		if (!_listening) {
			beginListening();
		}
		return macAddress;
	}
	
	static function get_broadcastAddress():String 
	{
		if (!_listening) {
			beginListening();
		}
		return broadcastAddress;
	}
	
	public static function onIpChange(handler:Void->Void):Void 
	{
		_ipChangeHandlers.push(handler);
	}
	
	static function get_isConnected():Notifier<Bool> 
	{
		if (!_listening) {
			beginListening();
		}
		return isConnected;
	}
	
	static function set_pollTimeout(value:Int):Int 
	{
		if(pollTimeout == value) return value;
		pollTimeout = value;
		_pollTimer.delay = value;
		_pollTimer.reset();
		return value;
	}
	
}