package mantle.services.p2pBind.state;

import mantle.services.p2p.PeerObject;
import mantle.model.scene.SceneModel;
using Logger;

/**
 * ...
 * @author P.J.Shand
 */
class StateReceiver
{
	private var sceneModel:SceneModel;
	var peerObject:mantle.services.p2p.PeerObject;
	
	public function new(peerObject:PeerObject, _sceneModel:SceneModel=null) 
	{
		this.sceneModel = _sceneModel;
		if (this.sceneModel == null) {
			this.sceneModel = SceneModel.instance;
		}
		
		//this.sceneModel.change.add(OnSceneChange);
		
		
		/*peerObject.connectionRefused.add(onConnectionRefused);
		peerObject.connectionSuccess.add(onConnectionSuccess);
		peerObject.neighborConnect.add(onNeighbourConnect);
		peerObject.neighborDisconnect.add(onNeighbourDisconnect);*/
		peerObject.onMsg.add(onMsg);
	}
	
	/*function onConnectionRefused() 
	{
		//peerModel.connected = false;
	}
	
	function onConnectionSuccess() 
	{
		//info("onConnectionSuccess");
		//peerModel.selfId = _peerObject.selfId;
		//peerModel.connected = true;
	}
	
	function onNeighbourConnect(neighborId:String) 
	{
		//info("onNeighbourConnect: "+neighborId);
		//peerModel.addPeer(neighborId);
	}
	
	function onNeighbourDisconnect(neighborId:String) 
	{
		//info("onNeighbourDisconnect: "+neighborId);
		//peerModel.removePeer(neighborId);
	}*/
	
	function onMsg(neighborId:String, data:Dynamic) 
	{
		if (data.state != null){
			this.sceneModel.uri = data.state.sceneURI;
		}
	}
}