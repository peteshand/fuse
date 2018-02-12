package fuse.render;

import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.display.effects.BlendMode;
import fuse.display.effects.BlendMode.BlendFactors;
import fuse.render.program.Context3DProgram;
import fuse.render.program.ShaderProgram;
import fuse.render.program.ShaderPrograms;
import fuse.render.Context3DTexture;
import fuse.render.shader.FuseShaders;
import fuse.utils.Notifier;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class BatchRenderer
{
	static var programChanged:Bool = false;
	static var currentBlendMode:Int = -1;
	static private var context3D:Context3D;
	
	public static var shaderProgram:Notifier<ShaderProgram>;
	public static var quadCount:Int;
	
	static public function init(context3D:Context3D) 
	{
		BatchRenderer.context3D = context3D;
		shaderProgram = new Notifier<ShaderProgram>();
		shaderProgram.add(OnShaderProgramChange);
	}
	
	static function OnShaderProgramChange() 
	{
		if (shaderProgram.value == null) return;
		programChanged = true;
	}
	
	static public function begin(conductorData:WorkerConductorData) 
	{
		#if !air
			// Seems to be a bug in non AIR targets where changing the program causes texture bind issues
			conductorData.highestNumTextures = 8;
		#end
		quadCount = 0;
		FuseShaders.setCurrentShader(conductorData.highestNumTextures);
	}
	
	static public function drawBuffer(batchIndex:Int, conductorData:WorkerConductorData, context3D:Context3D) 
	{
		var currentBatchData:IBatchData = TextureRenderBatch.getBatchData(batchIndex);
		if (currentBatchData.skip == 1) return;
		
		var numItemsInBatch:Int = currentBatchData.numItems;
		if (numItemsInBatch == 0) return;
		if (conductorData.highestNumTextures == 0) return;
		
		programChanged = false;
		
		for (j in 0...8) 
		{
			if (j < conductorData.highestNumTextures) {
				Context3DTexture.setContextTexture(j, currentBatchData.textureIds[j]);
			}
			else {
				Context3DTexture.setContextTexture(j, -1);
			}
		}
		//for (k in conductorData.highestNumTextures...8) 
		//{
			//Context3DTexture.setContextTexture(k, -1);
		//}
		//trace("numItemsInBatch = " + numItemsInBatch);
		shaderProgram.value = ShaderPrograms.getProgram(numItemsInBatch);
		//FuseShaders.CURRENT_SHADER.value = FuseShaders.getShader(4);
		
		//var batchData:IBatchData = textureRenderBatch.getBatchData(i);
		//trace("conductorData.isStatic = " + conductorData.isStatic);
		//trace("programChanged = " + programChanged);
		
		if (currentBatchData != null /*&& (conductorData.isStatic == 0 || programChanged)*/) {
			
			//trace("quadCount = " + quadCount);
			//trace("VertexData.BYTES_PER_ITEM = " + VertexData.BYTES_PER_ITEM);
			//trace("currentBatchData.startIndex = " + currentBatchData.startIndex);
			//trace("currentBatchData.firstIndex = " + currentBatchData.firstIndex);
			//
			//
			//if (currentBatchData.renderTargetId == 6) {
				//RenderDebugUtil.vertexDebug(quadCount * VertexData.BYTES_PER_ITEM, numItemsInBatch);
			//}
			//
			//trace("quadCount = " + quadCount);
			shaderProgram.value.vertexbuffer.uploadFromByteArray(
				SharedMemory.memory, 
				quadCount * VertexData.BYTES_PER_ITEM,
				0, 
				ShaderProgram.VERTICES_PER_QUAD * numItemsInBatch
			);
			
			//trace(ShaderProgram.VERTICES_PER_QUAD * numItemsInBatch);
			
		}
		
		Context3DProgram.setProgram(shaderProgram.value.program);
		
		Context3DRenderTarget.value = currentBatchData.renderTargetId;
		
		// TODO: move this logic into worker
		var newBlendMode:Int = 0;
		if (currentBlendMode != newBlendMode) {
			currentBlendMode = newBlendMode;
			var blendFactors:BlendFactors = BlendMode.getBlendFactors(currentBlendMode);
			context3D.setBlendFactors(blendFactors.sourceFactor, blendFactors.destinationFactor);
		}
		
		
		//m.appendRotation(Lib.getTimer()/40, Vector3D.Z_AXIS);
		//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
		
		//trace("itemCount = " + itemCount);
		
		//if (numItemsInBatch > 1) numItemsInBatch = 1;
		//trace("numItemsInBatch = " + numItemsInBatch);
		//trace("drawTriangles");
		context3D.drawTriangles(shaderProgram.value.indexbuffer, 0, numItemsInBatch * 2);
		
		quadCount += numItemsInBatch;
	}
	
	static public function clear() 
	{
		BatchRenderer.shaderProgram.value = null;
	}
}