package fuse.render;

import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.render.program.ShaderPrograms;
import fuse.render.program.ShaderProgram;
import fuse.render.program.Context3DProgram;
import fuse.render.shader.FuseShader;
import fuse.render.shader.FuseShaders;
import fuse.render.texture.Context3DTexture;
import fuse.display.effects.BlendMode;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.front.texture.Textures;
import fuse.texture.IBaseTexture;
import fuse.utils.FrameBudget;
import fuse.utils.Notifier;
import fuse.utils.Color;
import fuse.Fuse;
import openfl.display3D.Context3DClearMask;

import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.geom.Matrix3D;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class Renderer
{
	var textureRenderBatch:TextureRenderBatch;
	var context3DTexture:Context3DTexture;
	var context3DProgram:Context3DProgram;
	//var shaderPrograms:ShaderPrograms;
	var conductorData:ConductorData;
	var context3D:Context3D;
	var sharedContext:Bool;
	var programChanged:Bool;
	
	var m:Matrix3D = new Matrix3D();
	var currentBlendMode:Int = -1;
	var targetTextureId = new Notifier<Int>(-2);
	var shaderProgram = new Notifier<ShaderProgram>();
	var numItemsInBatch:Int;
	var quadCount:Int;
	var currentBatchData:IBatchData;
	
	var stageSizeHasChanged:Bool = false;
	var stageWidth = new Notifier<Int>();
	var stageHeight = new Notifier<Int>();
	
	public function new(context3D:Context3D, sharedContext:Bool) 
	{
		this.context3D = context3D;
		this.sharedContext = sharedContext;
		
		if (!sharedContext){
			context3D.configureBackBuffer(Fuse.current.stage.stageWidth, Fuse.current.stage.stageHeight, 0, false);	
		}
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		//context3D.setScissorRectangle(new Rectangle(0, 0, 1600, 900));
		context3D.setCulling(Context3DTriangleFace.BACK);
		
		conductorData = new ConductorData();
		context3DTexture = new Context3DTexture(context3D);
		context3DProgram = new Context3DProgram(context3D);
		
		ShaderPrograms.init(context3D);
		//shaderPrograms = new ShaderPrograms(context3D);
		textureRenderBatch = new TextureRenderBatch();
		
		//FuseShader.init();
		FuseShaders.init();
		ShaderProgram.init();
		Textures.init(context3D);
		
		targetTextureId.add(OnTargetTextureIdChange);
		shaderProgram.add(OnShaderProgramChange);
		
		stageWidth.add(function():Void	{ stageSizeHasChanged = true; } );
		stageHeight.add(function():Void { stageSizeHasChanged = true; } );
	}
	
	function OnShaderProgramChange() 
	{
		if (shaderProgram.value == null) return;
		
		//trace("quadCount = " + quadCount);
		
		programChanged = true;
		//var numItems:Int = conductorData.numberOfRenderables;
		
		
		
		
		
		// assign shader program
		//context3DProgram.setProgram(shaderProgram.value.program);
	}
	
	function debugIndex(numItemsInBatch:Int, startIndex:Int) 
	{
		SharedMemory.memory.position = startIndex;
		for (i in 0...numItemsInBatch) 
		{
			var i1:Int = SharedMemory.memory.readShort();
			var i2:Int = SharedMemory.memory.readShort();
			var i3:Int = SharedMemory.memory.readShort();
			var i4:Int = SharedMemory.memory.readShort();
			var i5:Int = SharedMemory.memory.readShort();
			var i6:Int = SharedMemory.memory.readShort();
			trace([i1, i2, i3, i4, i5, i6]);
		}
		//trace("debugIndex");
	}
	
	function OnTargetTextureIdChange() 
	{
		//trace("targetTextureId.value = " + targetTextureId.value);
		if (targetTextureId.value == -1) {
			#if air
				context3D.setRenderToTexture(null, false, 0, 0, 0);
			#else
				context3D.setRenderToBackBuffer();
			#end
		}
		else {
			var texture:IBaseTexture = Textures.getTexture(targetTextureId.value);
			#if air
				context3D.setRenderToTexture(texture.textureBase, false, 0, 0, 0);
			#else
				context3D.setRenderToTexture(texture.textureBase, false, 0, 0);
			#end
			
			if (texture._clear || texture._alreadyClear || currentBatchData.clearRenderTarget == 1) {
				texture._clear = false;
				context3D.clear(texture.clearColour.red, texture.clearColour.green, texture.clearColour.blue, 0);
				//context3D.clear(0, 0, 0, 0);
			}
			else {
				context3D.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.DEPTH);
			}
			
			//context3D.clear(Math.random(), Math.random(), Math.random(), 1);
		}
	}
	
	public function update() 
	{
		targetTextureId.value = -1;
		if (sharedContext) {
			// context3D.clear will need to be called externally
			drawBuffer();
			// context3D.present will need to be called externally
		}
		else {
			begin(true, Fuse.current.stage.color);
			drawBuffer();
			end();
		}
		
	}
	
	public function begin(clear:Bool = true, clearColor:Color):Void
	{
		context3D.clear(clearColor.red / 255, clearColor.green / 255, clearColor.blue / 255, 1);
	}
	
	function drawBuffer() 
	{
		//var numItems:Int = conductorData.numberOfRenderables;
		//var numTriangles:Int = conductorData.numTriangles;
		//trace("total numItems = " + numItems);
		
		//if (numItems == 0) return;
		
		/*programChanged = false;
		shaderProgram.value = shaderPrograms.getProgram(numItems);
		
		var batchData:IBatchData = textureRenderBatch.getBatchData(0);
		
		if (batchData != null && (conductorData.isStatic == 0 || programChanged)) {
			
			vertexDebug(batchData, numItems);
			shaderProgram.value.vertexbuffer.uploadFromByteArray(SharedMemory.memory, batchData.startIndex, 0, 4 * numItems);
			
		}*/
		
		//trace("numberOfBatches = " + conductorData.numberOfBatches);
		
		
		
		if (!sharedContext) {
			stageWidth.value = Fuse.current.stage.stageWidth;
			stageHeight.value = Fuse.current.stage.stageHeight;
			
			if (stageSizeHasChanged){
				context3D.configureBackBuffer(stageWidth.value, stageHeight.value, 0, false);
			}
		}
		
		var itemCount:Int = 0;
		quadCount = 0;
		
		if (Fuse.current.cleanContext) {
			shaderProgram.value = null;
		}
		
		#if html5
			conductorData.highestNumTextures = 8;
		#end
		
		FuseShaders.setCurrentShader(conductorData.highestNumTextures);
		
		//if (conductorData.numberOfBatches > 1){
			//trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		//}
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			
			currentBatchData = textureRenderBatch.getBatchData(i);
			if (currentBatchData.skip == 1) continue;
			
			numItemsInBatch = currentBatchData.numItems;
			//trace("-- batch " + i);
			//trace("numItemsInBatch = " + numItemsInBatch);
			//trace("renderTargetId = " + currentBatchData.renderTargetId);
			//if (numItemsInBatch > 1) numItemsInBatch--;
			
			if (numItemsInBatch == 0) continue;
			if (conductorData.highestNumTextures == 0) continue;
			//trace("batch = " + i);
			//trace("numItemsInBatch = " + numItemsInBatch);
			//trace([numItemsInBatch * ShaderProgram.VERTICES_PER_QUAD, numItemsInBatch * ShaderProgram.INDICES_PER_QUAD]);
			programChanged = false;
			
			//if (currentBatchData.renderTargetId == 6){
				//batchDebug(currentBatchData);
			//}
			//trace("conductorData.highestNumTextures = " + conductorData.highestNumTextures);
			
			for (j in 0...8) 
			{
				if (j < conductorData.highestNumTextures) {
					context3DTexture.setContextTexture(j, currentBatchData.textureIds[j]);
				}
				else {
					context3DTexture.setContextTexture(j, -1);
				}
			}
			//for (k in conductorData.highestNumTextures...8) 
			//{
				//context3DTexture.setContextTexture(k, -1);
			//}
			
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
					//vertexDebug(quadCount * VertexData.BYTES_PER_ITEM, numItemsInBatch);
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
			
			context3DProgram.setProgram(shaderProgram.value.program);
			
			targetTextureId.value = currentBatchData.renderTargetId;
			
			
			
			
			//context3DTexture.setContextTexture(0, currentBatchData.textureId1);
			//context3DTexture.setContextTexture(1, currentBatchData.textureId2);
			//context3DTexture.setContextTexture(2, currentBatchData.textureId3);
			//context3DTexture.setContextTexture(3, currentBatchData.textureId4);
			//context3DTexture.setContextTexture(4, currentBatchData.textureId5);
			//context3DTexture.setContextTexture(5, currentBatchData.textureId6);
			//context3DTexture.setContextTexture(6, currentBatchData.textureId7);
			//context3DTexture.setContextTexture(7, currentBatchData.textureId8);
			
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
			#if air
				itemCount += numItemsInBatch * ShaderProgram.INDICES_PER_QUAD;
			#else
				itemCount += numItemsInBatch * ShaderProgram.INDICES_PER_QUAD * 2;
			#end
			
			quadCount += numItemsInBatch;
			
		}
		
		//context3DTexture.setContextTexture(0, -1);
		//context3DTexture.setContextTexture(1, -1);
		//context3DTexture.setContextTexture(2, -1);
		//context3DTexture.setContextTexture(3, -1);
		
		if (Fuse.current.cleanContext) {
			context3DTexture.clear();
			ShaderPrograms.clear();
			context3DProgram.setProgram(null);
			shaderProgram.value = null;
			targetTextureId.value = -2;
			
			
		}
	}
	
	function batchDebug(batchData:IBatchData) 
	{
		trace("startIndex      = " + batchData.startIndex);
		trace("numItemsInBatch = " + batchData.numItems);
		trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4, batchData.textureId5, batchData.textureId6, batchData.textureId7, batchData.textureId8]);
		trace("renderTargetId = " + batchData.renderTargetId);
	}
	
	inline function vertexDebug(startIndex:Int, numItems:Int) 
	{
		trace("numItems = " + numItems);
		if (numItems == 0) return;
		
		/*trace("Batch: " + i);
		trace("batchData.startIndex = " + batchData.startIndex);
		trace("numItemsInBatch = " + numItemsInBatch);
		trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
		trace("targetTextureId = " + targetTextureId.value);*/
		
		SharedMemory.memory.position = startIndex;// + (j * VertexData.BYTES_PER_ITEM);
		//trace("startIndex = " + startIndex);
		
		for (j in 0...numItems) 
		{
			trace("SharedMemory.memory.position = " + SharedMemory.memory.position);
			
			for (k in 0...ShaderProgram.VERTICES_PER_QUAD) 
			{
				
				var INDEX_X:Float = SharedMemory.memory.readFloat();
				
				/*var p:Int = SharedMemory.memory.position;
				SharedMemory.memory.writeFloat(-1);
				SharedMemory.memory.position = p;*/
				var INDEX_Y:Float = SharedMemory.memory.readFloat();
				
				var INDEX_U:Float = SharedMemory.memory.readFloat();
				var INDEX_V:Float = SharedMemory.memory.readFloat();
				var INDEX_MU:Float = SharedMemory.memory.readFloat();
				var INDEX_MV:Float = SharedMemory.memory.readFloat();
				
				var INDEX_COLOUR:UInt = SharedMemory.memory.readUnsignedInt();
				
				var INDEX_Texture:Float = SharedMemory.memory.readFloat();
				var INDEX_MaskTexture:Float = SharedMemory.memory.readFloat();
				var INDEX_MASK_BASE_VALUE:Float = SharedMemory.memory.readFloat();
				var INDEX_ALPHA:Float = SharedMemory.memory.readFloat();
				
				//var INDEX_R:Float = SharedMemory.memory.readFloat();
				//var INDEX_G:Float = SharedMemory.memory.readFloat();
				//var INDEX_B:Float = SharedMemory.memory.readFloat();
				//var INDEX_A:Float = SharedMemory.memory.readFloat();
				
				trace([INDEX_X, INDEX_Y, INDEX_U, INDEX_V]);
				trace([INDEX_Texture, INDEX_ALPHA]);
				trace("Colour = " + StringTools.hex(INDEX_COLOUR));
				trace([INDEX_MU, INDEX_MV, INDEX_MaskTexture, INDEX_MASK_BASE_VALUE]);
				//trace([INDEX_R, INDEX_G, INDEX_B, INDEX_A]);
				trace("--");
				
				//trace("INDEX_X = " + INDEX_X);
				//trace("INDEX_Y = " + INDEX_Y);
				//trace("INDEX_U = " + INDEX_U);
				//trace("INDEX_V = " + INDEX_V);
				////trace("INDEX_MU = " + INDEX_MU);
				////trace("INDEX_MV = " + INDEX_MV);
				//trace("INDEX_Texture = " + INDEX_Texture);
				////trace("INDEX_MaskTexture = " + INDEX_MaskTexture);
				////trace("INDEX_MASK_BASE_VALUE = " + INDEX_MASK_BASE_VALUE);
				////trace("INDEX_ALPHA = " + INDEX_ALPHA);
				//trace("INDEX_R = " + INDEX_R);
				//trace("INDEX_G = " + INDEX_G);
				//trace("INDEX_B = " + INDEX_B);
				//trace("INDEX_A = " + INDEX_A);
				
			}
			//trace("---------------------");
		}
	}
	
	public function end():Void
	{
		context3D.present();
	}
}