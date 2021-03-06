package fuse.core.render.batch;

import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.render.Context3DBlendMode;
import fuse.core.render.Context3DTexture;
import fuse.core.render.buffers.Buffers;
import fuse.core.render.buffers.Buffer;
import fuse.core.render.debug.RenderDebugUtil;
import fuse.core.render.shaders.FShader;
import fuse.core.render.shaders.FShaders;
import fuse.core.render.Context3DRenderTarget;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class BatchRenderer {
	var currentBlendMode:Int = -1;
	private var context3D:Context3D;
	var index:Int;

	// ** // public static var shaderProgram:Notifier<ShaderProgram>;
	public static var quadCount:Int;

	public function new(index:Int, context3D:Context3D) {
		this.context3D = context3D;
		this.index = index;
	}

	static public function begin(conductorData:WorkerConductorData) {
		quadCount = 0;
		// ** // FuseShaders.setCurrentShader(conductorData.highestNumTextures);
	}

	public function drawBuffer(batchIndex:Int, conductorData:WorkerConductorData, context3D:Context3D, traceOutput:Bool) {
		var currentBatchData:IBatchData = TextureRenderBatch.getBatchData(batchIndex);
		if (currentBatchData == null)
			return;
		// trace("skip = " + currentBatchData.skip);
		if (currentBatchData.skip == 1)
			return;

		// ** // var numItemsInShaderProgram:Int = ShaderPrograms.getGroupId(currentBatchData.numItems);
		// ** // if (numItemsInShaderProgram == 0) return;
		if (conductorData.highestNumTextures == 0)
			return;
		if (currentBatchData.numItems == 0)
			return;

		// trace("numItems = " + currentBatchData.numItems);

		var buffer:Buffer = Buffers.getBuffer(currentBatchData.numItems * 2);
		// buffer.update2();
		buffer.activate();

		// trace("startIndex = " + currentBatchData.startIndex);
		// trace("quadCount = " + quadCount);
		// trace(quadCount * VertexData.BYTES_PER_ITEM);

		AtlasBuffers.setBufferIndexState(currentBatchData.renderTargetId);
		// conductorData.highestNumTextures = 8;
		// trace("conductorData.highestNumTextures = " + conductorData.highestNumTextures);
		// trace("currentBatchData.numTextures = " + currentBatchData.numTextures);
		// trace("currentBatchData.renderTargetId = " + currentBatchData.renderTargetId);
		for (j in 0...8) {
			if (j < currentBatchData.numTextures) {
				// trace(currentBatchData.textureIds[j]);
				Context3DTexture.setContextTexture(j, currentBatchData.textureIds[j]);
			} else {
				Context3DTexture.setContextTexture(j, -1);
			}
		}

		// TODO: update shader to use number of textures in each batch
		var fShader:FShader = FShaders.getShader(currentBatchData.numTextures, currentBatchData.shaderId);

		// trace("currentBatchData.numTextures = " + currentBatchData.numTextures);
		// trace("conductorData.highestNumTextures = " + conductorData.highestNumTextures);

		// var fShader:FShader = FShaders.getShader(conductorData.highestNumTextures, currentBatchData.shaderId);
		// fShader.shaderId = currentBatchData.shaderId;
		fShader.update(currentBatchData.renderTargetId == -1);

		if (traceOutput) {
			RenderDebugUtil.batchDebug(currentBatchData);
			RenderDebugUtil.vertexDebug(quadCount * VertexData.BYTES_PER_ITEM, currentBatchData.numItems);
		}

		// ** // Context3DProgram.setProgram(shaderProgram.value.program);
		Context3DRenderTarget.value = currentBatchData.renderTargetId;
		Context3DBlendMode.blendMode.value = currentBatchData.blendMode;

		#if (air || flash)
		var firstIndex = 0; // quadCount * 6;
		#else
		var firstIndex = 0; // quadCount * 6 * 2;
		#end
		buffer.drawTriangles(firstIndex, currentBatchData.numItems * 2);
		// trace("quadCount = " + quadCount);
		quadCount += currentBatchData.numItems;

		buffer.deactivate();
	}

	public function clear() {
		// ** // BatchRenderer.shaderProgram.value = null;
	}
}
