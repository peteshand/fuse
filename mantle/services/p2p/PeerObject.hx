package mantle.services.p2p;

import mantle.delay.Delay;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.GroupSpecifier;
import flash.net.NetConnection;
import flash.net.NetGroup;
import mantle.time.EnterFrame;
import msignal.Signal;

/**
 * @author P.J.Shand
 * @author Thomas Byrne
 */
class PeerObject
{

	private var groupID:String;
	
	public var connectionRefused	= new Signal0();
	public var connectionSuccess	= new Signal0();
	public var neighborConnect		= new Signal1(String);
	public var neighborDisconnect	= new Signal1(String);
	public var onMsg				= new Signal2<String, Dynamic>();
	
	
	public var frameBuffer:Int = 0;
	public var dispatchToSelf:Bool = false;
	
	public var ipMulticast(get, set):String;
	public var ipMulticastPort(get, set):Int;
	
	
	public var selfId(get, null):String;
	
	private var frameBufferCount:Int = 0;
	private var activeFrames:Int = 0;
	private var frames:Array<Array<Dynamic>>;
	
	private var neighbours:Map<String, Bool> = new Map();
	
	private var peerConnection:PeerConnection;
	
	public function new(groupID:String) 
	{
		this.groupID = groupID;
		
		clearAllMsgs();
		
		peerConnection = new PeerConnection(groupID);
		peerConnection.onGroupConnected = setReady;
		peerConnection.onNetStatusEvent = netStatus;
	}
	public function connectServerless():Void 
	{
		peerConnection.connectServerless();
	}
	public function connect(serviceURL:String, key:String=null):Void
	{
		peerConnection.connect(serviceURL, key);
	}
	
	
	private function netStatus(event:NetStatusEvent):Void
	{
		switch(event.info.code){
			case "NetGroup.Neighbor.Connect":
				OnNeighborConnect(event.info.neighbor);
				
			case "NetGroup.Neighbor.Disconnect":
				OnNeighborDisconnect(event.info.neighbor);
				
			case "NetGroup.Posting.Notify" | "NetGroup.SendTo.Notify":
				MsgReceived(event.info.from, cast (event.info.message));
		}
	}
	
	public function send(payload:Dynamic):Void 
	{
		frames[frameBufferCount].push(payload);
	}
	
	public function clearMsgs():Void
	{
		for (j in 0 ... frames[frameBufferCount].length) 
		{
			frames[frameBufferCount].splice(0, 1);
		}
	}
	
	public function clearAllMsgs():Void
	{
		frames = new Array<Array<Dynamic>>();
		for (i in 0 ... (frameBuffer+1)) 
		{
			frames[i] = new Array<Dynamic>();
		}
	}
	
	public function start():Void 
	{
		running = true;
	}
	
	public function stop():Void 
	{
		running = false;
	}
	
	function checkRunning() 
	{
		if (running && ready){
			EnterFrame.add(Update);
		}else{
			EnterFrame.remove(Update);
		}
	}
	
	private function Update():Void 
	{
		if (frames[frameBufferCount].length > 0) activeFrames++;
		else clearMsgs();
		
		frameBufferCount++;
		
		if (frameBufferCount >= frames.length) {
			frameBufferCount = 0;
			if (activeFrames != 0) SendMessage();
			activeFrames = 0;
		}
	}
		
	private function SendMessage():Void 
	{
		if (dispatchToSelf) MsgReceived(selfId, frames);
		if (ready && numberOfConnectedPeers > 0) {
			peerConnection.sendToAllNeighbors(frames);
		}
		clearAllMsgs();
	}
	
	public function dispose():Void
	{
		peerConnection.disconnect();
	}
	
	
	
	private function OnNeighborConnect(neighborId:String):Void 
	{
		if (neighbours.exists(neighborId) ) return;
		
		neighbours.set(neighborId, true);
		numberOfConnectedPeers++;
		neighborConnect.dispatch(neighborId);
	}
	
	private function OnNeighborDisconnect(neighborId:String):Void 
	{
		if (!neighbours.exists(neighborId) ) return;
		
		neighbours.remove(neighborId);
		numberOfConnectedPeers--;
		neighborDisconnect.dispatch(neighborId);
	}
	
	private function MsgReceived(neighborId:String, frames:Array<Dynamic>):Void 
	{
		for (i in 0 ... frames.length) 
		{
			var frame:Array<Dynamic> = cast frames[i];
			if (i == 0) FrameMsgReceived(neighborId, frame);
			else {
				Delay.byFrames(i, FrameMsgReceived.bind(neighborId, frame));
			}
		}
	}
	
	private function FrameMsgReceived(neighborId:String, messageObjects:Array<Dynamic>):Void 
	{
		for (i in 0 ... messageObjects.length) 
		{
			var msgObject:Dynamic = messageObjects[i];
			onMsg.dispatch(neighborId, msgObject);
		}
	}
	
	@:isVar public var numberOfConnectedPeers(default, null):Int;
	
	@:isVar public var running(default, set):Bool;
	private function set_running(value:Bool):Bool 
	{
		if (running == value) return value;
		
		running = value;
		checkRunning();
		
		return value;
	}
	
	@:isVar public var ready(default, null):Bool;
	private function setReady(value:Bool):Bool 
	{
		if (ready == value) return value;
		
		ready = value;
		if (!value){
			for (neighbor in neighbours.keys()){
				OnNeighborDisconnect(neighbor);
			}
			connectionRefused.dispatch();
		}else{
			connectionSuccess.dispatch();
		}
		checkRunning();
		
		return value;
	}
	
	function get_ipMulticast():String 
	{
		return peerConnection.ipMulticast;
	}
	
	function set_ipMulticast(value:String):String 
	{
		return peerConnection.ipMulticast = value;
	}
	
	function get_ipMulticastPort():Int 
	{
		return peerConnection.ipMulticastPort;
	}
	
	function set_ipMulticastPort(value:Int):Int 
	{
		return peerConnection.ipMulticastPort = value;
	}
	
	function get_selfId():String 
	{
		return peerConnection.selfId;
	}
	
}