package mantle.services.p2p;

import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.NetConnection;
import flash.net.GroupSpecifier;
import flash.net.NetGroup;

/**
 * @author P.J.Shand
 * @author Thomas Byrne
 */
class PeerConnection
{

		private var groupID:String;
		private var autoStart:Bool;
		
		private var nc:NetConnection;
		private var groupSpec:GroupSpecifier;
		private var group:NetGroup;
		
		
		public var ipMulticast:String = "239.254.254.2";
		public var ipMulticastPort:Int = 1935;
		
		
		@:isVar public var selfId(default, null):String;
		@:isVar public var connectionOpen(default, null):Bool;
		@:isVar public var netGroupOpen(default, null):Bool;
		
		
		public var onGroupConnected:Bool->Void;
		public var onNetStatusEvent:NetStatusEvent->Void;
		
		public function new(groupID:String) 
		{
			this.groupID = groupID;
			
		}
		
		public function connectServerless():Void 
		{
			connect("rtmfp:");
		}
		
		public function connect(serviceURL:String, key:String=null):Void
		{
			if (nc == null){
				nc = new NetConnection();
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
				nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
			}
			nc.connect(serviceURL, key);
		}
		
		public function disconnect():Void
		{
			connectionClosed();
			if (nc!=null){
				nc.close();
				nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
				nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
				nc = null;
			}
		}
		
		public function sendToAllNeighbors(msg:Dynamic) 
		{
			group.sendToAllNeighbors(msg);
		}
		
		private function netSecurityError(e:SecurityErrorEvent):Void 
		{
			trace("netSecurityError: " + e);
		}
		
		private function netStatus(event:NetStatusEvent):Void
		{
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					connectionOpened();
					
				case "NetConnection.Connect.Closed":
					connectionClosed();
					
				case "NetGroup.Connect.Success":
					netGroupOpened();
					
				case "NetGroup.Connect.Rejected":
					netGroupClosed();
					
			}
			
			if (onNetStatusEvent != null) onNetStatusEvent(event);
		}
		
		private function connectionOpened():Void
		{
			connectionOpen = true;
			
			groupSpec = new GroupSpecifier(groupID);
			groupSpec.peerToPeerDisabled = false;
			groupSpec.serverChannelEnabled = true;
			groupSpec.ipMulticastMemberUpdatesEnabled = true;
			groupSpec.multicastEnabled = true;
			groupSpec.postingEnabled = true;
			
			groupSpec.routingEnabled = true;
			groupSpec.objectReplicationEnabled = true;
			
			groupSpec.addIPMulticastAddress(ipMulticast + ":" + ipMulticastPort);
			
			var groupId:String = groupSpec.groupspecWithAuthorizations(); 
			
			group = new NetGroup(nc, groupId);
			group.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			
			selfId = group.localCoverageFrom;
		}
		
		private function connectionClosed():Void
		{
			selfId = null;
			groupSpec = null;
			if (group != null){
				group.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
				group.close();
			}
			group = null;
			connectionOpen = false;
			
			netGroupClosed();
		}
		
		private function netGroupOpened():Void 
		{
			if (netGroupOpen) return;
			netGroupOpen = true;
			if (onGroupConnected != null) onGroupConnected(true);
		}
		
		private function netGroupClosed():Void 
		{
			if (!netGroupOpen) return;
			netGroupOpen = false;
			if (onGroupConnected != null) onGroupConnected(false);
		}
	
}