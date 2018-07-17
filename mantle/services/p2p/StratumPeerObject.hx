package mantle.services.p2p;
import flash.events.NetStatusEvent;

/**
 * @author P.J.Shand
 * @author Thomas Byrne
 */
class StratumPeerObject extends PeerObject
{
	
	static private var registered:Bool;
	static inline function register() 
	{
		if (registered) return;
		registered = true;
		haxe.remoting.AMFConnection.registerClassAlias("air.p2p.StratumPeerObject.UpperMsg", UpperMsg);
	}
	
	public var preventMsgForwarding:Bool = false;
	
	
	var levelGroupIDs:Array<String>;
	var upperConns:Array<PeerConnection>;
	var outgoingMsg:UpperMsg;
	var serviceURL:String;
	var peerConns:Map<String, Array<String>>;
	var children:Array<String>;

	public function new(levelGroupIDs:Array<String>) 
	{
		register();
		
		outgoingMsg = new UpperMsg();
		
		peerConns = new Map();
		
		this.levelGroupIDs = levelGroupIDs;
		
		var baseGroupId = levelGroupIDs.shift();
		super(baseGroupId);
		
		upperConns = [];
		
		for (i in 0 ... levelGroupIDs.length){
			var peerConn:PeerConnection = new PeerConnection(levelGroupIDs[i]);
			peerConn.onGroupConnected = onUpperConnectedChange.bind(_, i);
			peerConn.onNetStatusEvent = onUpperNetStatus.bind(_, i);
			upperConns.push(peerConn);
		}
	}
	
	override function setReady(value:Bool):Bool 
	{
		if (value){
			children = [selfId];
			sendToUpper(selfId, null, false);
		}
		return super.setReady(value);
	}
	
	function onUpperConnectedChange(connected:Bool, index:Int) 
	{
		connectUppermost();
	}
	
	override public function connect(serviceURL:String, key:String=null):Void
	{
		this.serviceURL = serviceURL;
		connectUppermost();
	}
	
	function connectUppermost() 
	{
		var found = false;
		for (i in 0 ... upperConns.length + 1){
			var conn;
			if (i == upperConns.length){
				conn = peerConnection;
			}else{
				conn = upperConns[upperConns.length - 1 - 0];
			}
			if (conn.netGroupOpen){
				if (found) conn.disconnect();
			}else if(!found){
				found = true;
				conn.connect(serviceURL);
			}
		}
	}
	
	override function SendMessage():Void 
	{
		sendToUpper(selfId, frames, false);
		super.SendMessage();
	}
	
	override function netStatus(event:NetStatusEvent):Void 
	{
		var isMsg:Bool = Std.is(event.info.message, UpperMsg);
		if (!isMsg) super.netStatus(event);
		else{
			UpperMsgReceived(event.info.message.parentId, event.info.message, 0);
		}
		
		switch(event.info.code){
			case "NetGroup.Neighbor.Connect":
				if(children.indexOf(event.info.neighbor) == -1)children.push(event.info.neighbor);
				sendToUpper(event.info.neighbor, null, false);
				
			case "NetGroup.Neighbor.Disconnect":
				children.remove(event.info.neighbor);
				sendToUpper(event.info.neighbor, null, true);
				clearByParent(event.info.neighbor, 0);
				
			case "NetGroup.Posting.Notify" | "NetGroup.SendTo.Notify":
				if(isMsg){
					sendToUpper(cast event.info.message.fromId, cast event.info.message.frames, false);
				}else{
					sendToUpper(event.info.from, cast (event.info.message), false);
				}
		}
	}
	
	function sendToUpper(fromId:String, frames:Array<Array<Dynamic>>, disconnect:Bool, fromIndex:Int = -1) 
	{
		outgoingMsg.parentId = selfId;
		outgoingMsg.fromId = fromId;
		outgoingMsg.frames = frames;
		outgoingMsg.disconnect = disconnect;
		
		if (fromIndex == -1) fromIndex = 0;
		for (i in fromIndex ... upperConns.length){
			var conn = upperConns[i];
			conn.sendToAllNeighbors(outgoingMsg);
		}
	}
	
	function onUpperNetStatus(event:NetStatusEvent, groupIndex:Int) 
	{
		if (preventMsgForwarding) return;
		//trace("onUpperNetStatus: "+event.info.code+" "+event.info.peerID+" "+event.info.neighbor+" "+event.info.from);
		switch(event.info.code){
			case "NetGroup.Neighbor.Connect":
				//if(peerConns.get(event.info.neighbor) == null) peerConns.set(event.info.neighbor, []);
				/*for (neighborId in children){
					sendToUpper(neighborId, null, false, groupIndex);
				}*/
				//sendToUpper(selfId, null, false);
				
			case "NetGroup.Neighbor.Disconnect":
				clearByParent(event.info.neighbor, groupIndex);
				
			case "NetGroup.Posting.Notify":
				UpperMsgReceived(event.info.from, cast event.info.message, groupIndex);
				
			case "NetGroup.SendTo.Notify":
				UpperMsgReceived(event.info.from, cast event.info.message, groupIndex);
		}
	}
	
	function clearByParent(parentId:String, groupIndex:Int) 
	{
		var peerList:Array<String> = peerConns.get(parentId);
		if (peerList == null) return;
		peerConns.remove(parentId);
		sendDisconnects(peerList, groupIndex);
	}
	
	function sendDisconnects(peerList:Array<String>, groupIndex:Int) 
	{
		for (peerId in peerList){
			sendToUpper(peerId, null, true, groupIndex);
			super.OnNeighborDisconnect(peerId);
		}
	}
	
	function UpperMsgReceived(fromId:String, msg:UpperMsg, groupIndex:Int) 
	{
		var conn = upperConns[groupIndex];
		if (msg.fromId == selfId) return;
		
		var peerList:Array<String> = null;
		if (fromId != null){
			peerList = peerConns.get(fromId);
			if (peerList == null){
				peerList = [];
				peerConns.set(fromId, peerList);
			}
		}
		
		if (msg.disconnect){
			if(peerList != null)peerList.remove(msg.fromId);
			if(msg.frames!=null && msg.frames.length>0){
				super.MsgReceived(msg.fromId, msg.frames);
			}
			super.OnNeighborDisconnect(msg.fromId);
		}else{
			if (!neighbours.exists(msg.fromId)){
				if (peerList != null && peerList.indexOf(msg.fromId) == -1){
					peerList.push(msg.fromId);
					trace("fromId: "+msg.fromId+" "+fromId+" "+msg.parentId+" "+peerList.length);
				}
				super.OnNeighborConnect(msg.fromId);
			}
			if(msg.frames!=null && msg.frames.length>0){
				super.MsgReceived(msg.fromId, msg.frames);
			}
		}
		
		if(upperConns.length > 0){
			for (i in 0 ... groupIndex){
				var otherConn = upperConns[i];
				if (otherConn.netGroupOpen) otherConn.sendToAllNeighbors(msg);
			}
			msg.parentId = selfId;
			peerConnection.sendToAllNeighbors(msg);
		}
	}
}


class UpperMsg {
	public var parentId:String;
	public var fromId:String;
	public var frames:Array<Array<Dynamic>>;
	public var disconnect:Bool;
	
	public function new(){
		
	}
}