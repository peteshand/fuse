package fuse.render.batch;

import fuse.core.PlatformSettings;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.render.blendMode.Context3DBlendMode;
import fuse.render.texture.Context3DTexture;
import fuse.render.buffers.Buffers;
import fuse.render.debug.RenderDebugUtil;
import fuse.render.shaders.FShader;
import fuse.render.shaders.FShaders;
import fuse.render.target.Context3DRenderTarget;
import mantle.notifier.Notifier;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class BatchRenderer
{
	var currentBlendMode:Int = -1;
	private var context3D:Context3D;
	var index:Int;
	
	// ** // public static var shaderProgram:Notifier<ShaderProgram>;
	public static var quadCount:Int;
	
	public function new(index:Int, context3D:Context3D) 
	{
		this.context3D = context3D;
		this.index = index;
		
	}
	
	static public function begin(conductorData:WorkerConductorData) 
	{
		quadCount = 0;
		// ** // FuseShaders.setCurrentShader(conductorData.highestNumTextures);
	}
	
	public function drawBuffer(batchIndex:Int, conductorData:WorkerConductorData, context3D:Context3D, traceOutput:Bool) 
	{
		var currentBatchData:IBatchData = TextureRenderBatch.getBatchData(batchIndex);
		if (currentBatchData == null) return;
		if (currentBatchData.skip == 1) return;
		
		// ** // var numItemsInShaderProgram:Int = ShaderPrograms.getGroupId(currentBatchData.numItems);
		// ** // if (numItemsInShaderProgram == 0) return;
		if (conductorData.highestNumTextures == 0) return;
		
		//trace("startIndex = " + currentBatchData.startIndex);
		//trace("quadCount = " + quadCount);
		//trace(quadCount * VertexData.BYTES_PER_ITEM);
		
		AtlasBuffers.setBufferIndexState(currentBatchData.renderTargetId);
		//conductorData.highestNumTextures = 8;
		
		for (j in 0...8) 
		{
			if (j < conductorData.highestNumTextures) {
				Context3DTexture.setContextTexture(j, currentBatchData.textureIds[j]);
			}
			else {
				Context3DTexture.setContextTexture(j, -1);
			}
		}
		
		
		var fShader:FShader = FShaders.getShader(conductorData.highestNumTextures);
		fShader.update(currentBatchData.renderTargetId == -1);
		
		if (traceOutput){
			RenderDebugUtil.batchDebug(currentBatchData);
			RenderDebugUtil.vertexDebug(quadCount * VertexData.BYTES_PER_ITEM, currentBatchData.numItems);
		}
				
		// ** // Context3DProgram.setProgram(shaderProgram.value.program);
		Context3DRenderTarget.value = currentBatchData.renderTargetId;
		
		Context3DBlendMode.blendMode.value = currentBatchData.blendMode;
		
		// TODO: move this logic into worker
		//var newBlendMode:Int = 0;
		//if (currentBlendMode != newBlendMode) {
			//currentBlendMode = newBlendMode;
			//var blendFactors:BlendFactors = BlendMode.getBlendFactors(currentBlendMode);
			//context3D.setBlendFactors(blendFactors.sourceFactor, blendFactors.destinationFactor);
		//}
		
		#if (air||flash)
			var firstIndex = quadCount * 6;
		#else
			var firstIndex = quadCount * 6 * 2;
		#end
		Buffers.currentBuffer.drawTriangles(firstIndex, currentBatchData.numItems * 2);
		//trace("quadCount = " + quadCount);
		quadCount += currentBatchData.numItems;
	}
	
	public function clear() 
	{
		// ** // BatchRenderer.shaderProgram.value = null;
	}
}