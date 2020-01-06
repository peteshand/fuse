package fuse.core.backend;

import fuse.core.backend.texture.CoreRenderTexture;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.texture.RenderTextureManager;
import fuse.core.front.texture.TextureRef;
import fuse.texture.TextureId;
import fuse.utils.ObjectId;
import fuse.core.assembler.input.Touchables;
import fuse.core.communication.messageData.StaticData;
import fuse.core.communication.messageData.TouchableMsg;
import fuse.core.communication.messageData.VisibleMsg;
import fuse.input.Touch;
import fuse.Fuse;
import fuse.core.assembler.Assembler;
import fuse.core.assembler.input.InputAssembler;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.Core;
import fuse.core.communication.messageData.AddMaskMsg;
import fuse.core.communication.messageData.SetChildIndexMsg;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.IWorkerComms;
import fuse.core.backend.Conductor;
import fuse.core.communication.messageData.AddChildMsg;
import openfl.Lib;
import openfl.utils.ByteArray;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.messageData.WorkerPayload;
import fuse.core.communication.data.WorkerSharedProperties;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class CoreEntryPoint {
	private var numberOfWorkers:Int;
	private var workerComms:IWorkerComms;
	var index:Int;

	public function new(workerComms:IWorkerComms, numberOfWorkers:Int) {
		this.workerComms = workerComms;
		this.numberOfWorkers = numberOfWorkers;

		if (Fuse.current.sharedMemory == null) {
			var memory:ByteArray = workerComms.getSharedProperty(WorkerSharedProperties.CORE_MEMORY);
			Fuse.current.sharedMemory = new SharedMemory(memory);
			Fuse.current.conductorData = new WorkerConductorData();
		}

		Core.init();

		workerComms.addListener(MessageType.UPDATE, onUpdateMsg);
		workerComms.addListener(MessageType.RESIZE, onResizeMsg);
		workerComms.addListener(MessageType.ADD_CHILD, onAddChild);
		workerComms.addListener(MessageType.ADD_CHILD_AT, onAddChildAt);
		workerComms.addListener(MessageType.SET_CHILD_INDEX, onSetChildIndex);
		workerComms.addListener(MessageType.REMOVE_CHILD, onRemoveChild);
		workerComms.addListener(MessageType.ADD_TO_RENDER_TEXTURE, onAddToRenderTexture);
		workerComms.addListener(MessageType.VISIBLE_CHANGE, onVisibleChange);
		workerComms.addListener(MessageType.SET_RENDER_LAYER, onSetRenderLayer);
		
		workerComms.addListener(MessageType.ADD_MASK, onAddMask);
		workerComms.addListener(MessageType.REMOVE_MASK, onRemoveMask);
		workerComms.addListener(MessageType.ADD_TEXTURE, onAddTexture);
		// workerComms.addListener(MessageType.ADD_RENDER_TEXTURE, onAddRenderTexture);
		workerComms.addListener(MessageType.UPDATE_TEXTURE, onUpdateTexture);
		workerComms.addListener(MessageType.UPDATE_TEXTURE_SURFACE, onUpdateTextureSurface);
		workerComms.addListener(MessageType.REMOVE_TEXTURE, onRemoveTexture);
		workerComms.addListener(MessageType.MOUSE_INPUT, onMouseInput);
		workerComms.addListener(MessageType.SET_TOUCHABLE, onSetTouchable);
		workerComms.addListener(MessageType.SET_STATIC, onSetStatic);

		index = workerComms.getSharedProperty(WorkerSharedProperties.INDEX);
		numberOfWorkers = workerComms.getSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS);
		var framerate:Float = workerComms.getSharedProperty(WorkerSharedProperties.FRAME_RATE);
		Lib.current.stage.frameRate = framerate;
		Lib.current.stopAllMovieClips();

		Conductor.init(workerComms, index, numberOfWorkers, workerComms.usingWorkers);
		Conductor.onTick.add(onTick);

		VertexWriter.init();
		Assembler.init();

		workerComms.send(MessageType.WORKER_STARTED);
	}

	function onTick() {
		
		// Remove for New Assembler //
		// Core.assembler.update();

		Assembler.update();
		for (i in 0...InputAssembler.collisions.length) {
			workerComms.send(MessageType.MOUSE_COLLISION, InputAssembler.collisions[i]);
		}
	}

	function onAddMask(addChildPayload:AddMaskMsg) {
		Core.displayList.addMask(addChildPayload);
	}

	function onRemoveMask(workerPayload:WorkerPayload) {
		var objectId:Int = workerPayload;
		Core.displayList.removeMask(objectId);
	}

	function onAddTexture(textureRef:TextureRef):Void {
		var texture = Core.textures.create(textureRef);
	}

	/*function onAddRenderTexture(textureRef:TextureRef):Void {
		var texture = Core.textures.create(textureRef);
		RenderTextureManager.add(texture);
	}*/
	function onUpdateTexture(objectId:ObjectId):Void {
		Core.textures.update(objectId);
	}

	function onUpdateTextureSurface(objectId:ObjectId):Void {
		Core.textures.updateSurface(objectId);
	}

	private function onRemoveTexture(objectId:ObjectId):Void {
		Core.textures.dispose(objectId);
	}

	private function onMouseInput(touch:Touch):Void {
		InputAssembler.add(touch);
	}

	function onAddChild(addChildPayload:AddChildMsg) {
		addChildPayload.addAtIndex = -1;
		onAddChildAt(addChildPayload);
	}

	function onAddChildAt(payload:AddChildMsg) {
		Core.displayList.addChildAt(payload.objectId, payload.displayType, payload.parentId, payload.addAtIndex);
	}

	function onSetChildIndex(payload:SetChildIndexMsg) {
		Core.displayList.setChildIndex(payload.objectId, payload.displayType, payload.parentId, payload.index);
	}

	function onRemoveChild(workerPayload:WorkerPayload) {
		var objectId:Int = workerPayload;
		Core.displayList.removeChild(objectId);
	}

	function onAddToRenderTexture(payload:{textureId:ObjectId, objectId:Int, displayType:Int}) {
		var display:CoreDisplayObject = Core.displayList.getDisplay(payload.objectId, payload.displayType);
		var texture:CoreRenderTexture = Core.textures.getRenderTexture(payload.textureId);
		texture.addDisplay(display);
	}

	function onVisibleChange(visibleMsg:VisibleMsg) {
		Core.displayList.visibleChange(visibleMsg.objectId, visibleMsg.visible);
	}

	function onSetRenderLayer(data:{objectId:Int,renderLayer:Int}) {
		Core.displayList.renderLayerChange(data.objectId, data.renderLayer);
	}

	

	private function onSetTouchable(payload:TouchableMsg):Void {
		Touchables.setTouchable(payload);
	}

	private function onSetStatic(payload:StaticData):Void {
		Core.displayList.setStatic(payload);
	}

	function onUpdateMsg(workerPayload:WorkerPayload) {
		workerComms.send(MessageType.UPDATE_RETURN);
		// OnTick();
	}

	function onResizeMsg(payload:{stageWidth:Int, stageHeight:Int, windowWidth:Int, windowHeight:Int}){
		Core.STAGE_WIDTH = payload.stageWidth;
		Core.STAGE_HEIGHT = payload.stageHeight;
		Core.WINDOW_WIDTH = payload.windowWidth;
		Core.WINDOW_HEIGHT = payload.windowHeight;
	}
}
