package fuse.render;

import fuse.core.front.memory.data.conductorData.ConductorData;
import fuse.core.front.memory.data.vertexData.VertexData;
import fuse.core.worker.thread.display.TextureRenderBatch;
import fuse.core.front.memory.data.batchData.IBatchData;
import fuse.core.worker.thread.display.ShaderPrograms;
import fuse.core.worker.thread.display.ShaderProgram;
import fuse.render.program.Context3DProgram;
import fuse.render.texture.Context3DTexture;
import fuse.display.effects.BlendMode;
import fuse.core.front.memory.KeaMemory;
import fuse.core.front.texture.Textures;
import fuse.texture.Texture;
import fuse.utils.Notifier;
import fuse.Color;
import fuse.Fuse;

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
	var shaderPrograms:ShaderPrograms;
	var conductorData:ConductorData;
	var baseShader:BaseShader;
	var context3D:Context3D;
	var program:Program3D;
	var sharedContext:Bool;
	var programChanged:Bool;
	
	var m:Matrix3D = new Matrix3D();
	var currentBlendMode:Int = -1;
	var targetTextureId = new Notifier<Int>(-2);
	var shaderProgram = new Notifier<ShaderProgram>();
	
	public function new(context3D:Context3D, sharedContext:Bool) 
	{
		this.context3D = context3D;
		this.sharedContext = sharedContext;
		
		if (!sharedContext){
			context3D.configureBackBuffer(Fuse.current.stage.stageWidth, Fuse.current.stage.stageHeight, 0);
			
		}
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		//context3D.setScissorRectangle(new Rectangle(0, 0, 1600, 900));
		context3D.setCulling(Context3DTriangleFace.BACK);
		
		#if debug
			context3D.enableErrorChecking = true;
		#end
		
		conductorData = new ConductorData();
		context3DTexture = new Context3DTexture(context3D);
		context3DProgram = new Context3DProgram(context3D);
		shaderPrograms = new ShaderPrograms(context3D);
		textureRenderBatch = new TextureRenderBatch();
		
		Textures.init(context3D);
		
		baseShader = new BaseShader();
		program = context3D.createProgram();
		program.upload(baseShader.vertexCode, baseShader.fragmentCode);
		
		targetTextureId.add(OnTargetTextureIdChange);
		shaderProgram.add(OnShaderProgramChange);
	}
	
	function OnShaderProgramChange() 
	{
		if (shaderProgram.value == null) return;
		
		programChanged = true;
		
		var numItems:Int = conductorData.numberOfRenderables;
		
		// vertex x y position to attribute register 0
		context3D.setVertexBufferAt(0, shaderProgram.value.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		// UV to attribute register 1 x,y
		context3D.setVertexBufferAt(1, shaderProgram.value.vertexbuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		// Texture Index attribute register 1 z
		context3D.setVertexBufferAt(2, shaderProgram.value.vertexbuffer, 4, Context3DVertexBufferFormat.FLOAT_1);
		// Colour to attribute register 2
		//context3D.setVertexBufferAt(2, shaderProgram.value.vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
		
		shaderProgram.value.indexbuffer.uploadFromVector(shaderProgram.value.indices, 0, 6 * numItems);
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, baseShader.textureChannelData, 4);
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, baseShader.fragData, 1);
		
		// assign shader program
		context3DProgram.setProgram(program);
	}
	
	function OnTargetTextureIdChange() 
	{
		if (targetTextureId.value == -1) {
			context3D.setRenderToTexture(null, false, 0, 0);
		}
		else {
			var texture:Texture = Textures.getTexture(targetTextureId.value);
			context3D.setRenderToTexture(texture.nativeTexture, false, 0, 0);
			
			if (texture._clear) {
				texture._clear = false;
				context3D.clear(0, 0, 0, 0);
			}
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
			begin(true, 0xFF0000);
			drawBuffer();
			end();
		}
		
	}
	
	public function begin(clear:Bool = true, clearColor:Color = null):Void
	{
		//context3D.clear(clearColor.R, clearColor.G, clearColor.B, 0.3);
		context3D.clear(0, 0, 0, 1);
	}
	
	function drawBuffer() 
	{
		var numItems:Int = conductorData.numberOfRenderables;
		//trace("total numItems = " + numItems);
		
		if (numItems == 0) return;
		
		
		
		programChanged = false;
		shaderProgram.value = shaderPrograms.getProgram(numItems);
		
		
		
		//trace("conductorData.isStatic = " + conductorData.isStatic);
		
		var batchData:IBatchData = textureRenderBatch.getBatchData(0);
		if (batchData != null && (conductorData.isStatic == 0 || programChanged)) {
			shaderProgram.value.vertexbuffer.uploadFromByteArray(KeaMemory.memory, batchData.startIndex, 0, 4 * numItems);
		}
		
		var itemCount:Int = 0;
		//trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			//trace("Batch: " + i);
			
			
			var batchData:IBatchData = textureRenderBatch.getBatchData(i);
			var numItemsInBatch:Int = batchData.numItems;
			if (numItemsInBatch == 0) continue;
			
			targetTextureId.value = batchData.renderTargetId;
			
			
			//trace("numItemsInBatch = " + numItemsInBatch);
			//trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
			//trace("targetTextureId = " + targetTextureId.value);
			//
			//
			//for (j in 0...numItemsInBatch) 
			//{
				//KeaMemory.memory.position = batchData.startIndex + (j * VertexData.BYTES_PER_ITEM);
				////trace("KeaMemory.memory.position = " + KeaMemory.memory.position);
				//
				//var INDEX_X1:Float = KeaMemory.memory.readFloat();
				//var INDEX_Y1:Float = KeaMemory.memory.readFloat();
				//var INDEX_U1:Float = KeaMemory.memory.readFloat();
				//var INDEX_V1:Float = KeaMemory.memory.readFloat();
				//var INDEX_T1:Float = KeaMemory.memory.readFloat();
				//
				///*trace("INDEX_X1 = " + INDEX_X1);
				//trace("INDEX_Y1 = " + INDEX_Y1);
				//trace("INDEX_Z1 = " + INDEX_Z1);
				//trace("INDEX_U1 = " + INDEX_U1);
				//trace("INDEX_V1 = " + INDEX_V1);
				//trace("INDEX_T1 = " + INDEX_T1);*/
				//
				//var INDEX_X2:Float = KeaMemory.memory.readFloat();
				//var INDEX_Y2:Float = KeaMemory.memory.readFloat();
				//var INDEX_U2:Float = KeaMemory.memory.readFloat();
				//var INDEX_V2:Float = KeaMemory.memory.readFloat();
				//var INDEX_T2:Float = KeaMemory.memory.readFloat();
				//
				///*trace("INDEX_X2 = " + INDEX_X2);
				//trace("INDEX_Y2 = " + INDEX_Y2);
				//trace("INDEX_Z2 = " + INDEX_Z2);
				//trace("INDEX_U2 = " + INDEX_U2);
				//trace("INDEX_V2 = " + INDEX_V2);
				//trace("INDEX_T2 = " + INDEX_T2);*/
				//
				//var INDEX_X3:Float = KeaMemory.memory.readFloat();
				//var INDEX_Y3:Float = KeaMemory.memory.readFloat();
				//var INDEX_U3:Float = KeaMemory.memory.readFloat();
				//var INDEX_V3:Float = KeaMemory.memory.readFloat();
				//var INDEX_T3:Float = KeaMemory.memory.readFloat();
				//
				///*trace("INDEX_X3 = " + INDEX_X3);
				//trace("INDEX_Y3 = " + INDEX_Y3);
				//trace("INDEX_Z3 = " + INDEX_Z3);
				//trace("INDEX_U3 = " + INDEX_U3);
				//trace("INDEX_V3 = " + INDEX_V3);
				//trace("INDEX_T3 = " + INDEX_T3);*/
				//
				//var INDEX_X4:Float = KeaMemory.memory.readFloat();
				//var INDEX_Y4:Float = KeaMemory.memory.readFloat();
				//var INDEX_U4:Float = KeaMemory.memory.readFloat();
				//var INDEX_V4:Float = KeaMemory.memory.readFloat();
				//var INDEX_T4:Float = KeaMemory.memory.readFloat();
				//
				///*trace("INDEX_X4 = " + INDEX_X4);
				//trace("INDEX_Y4 = " + INDEX_Y4);
				//trace("INDEX_Z4 = " + INDEX_Z4);
				//trace("INDEX_U4 = " + INDEX_U4);
				//trace("INDEX_V4 = " + INDEX_V4);
				//trace("INDEX_T4 = " + INDEX_T4);*/
				//
				//
				////trace([INDEX_U1, INDEX_V1]);
				////trace([INDEX_U2, INDEX_V2]);
				////trace([INDEX_U3, INDEX_V3]);
				////trace([INDEX_U4, INDEX_V4]);
				////
				//trace([INDEX_X1, INDEX_Y1]);
				//trace([INDEX_X2, INDEX_Y2]);
				//trace([INDEX_X3, INDEX_Y3]);
				//trace([INDEX_X4, INDEX_Y4]);
				//
				////
				//
				////var INDEX_BATCH_ID:Float = KeaMemory.memory.readFloat();
				////trace("INDEX_BATCH_ID = " + INDEX_BATCH_ID);
				//
				//
				//
				//
				//
				////if (conductorData.numberOfBatches == 2) {
					//
					//trace(["T Index", INDEX_T1]);
					//
				////}
			//}
			
			
			
			
			
			context3DTexture.setContextTexture(0, batchData.textureId1);
			context3DTexture.setContextTexture(1, batchData.textureId2);
			context3DTexture.setContextTexture(2, batchData.textureId3);
			context3DTexture.setContextTexture(3, batchData.textureId4);
			
			// TODO: move this logic into worker
			var newBlendMode:Int = 0;
			if (currentBlendMode != newBlendMode) {
				currentBlendMode = newBlendMode;
				var blendFactors:BlendFactors = BlendMode.getBlendFactors(currentBlendMode);
				context3D.setBlendFactors(blendFactors.sourceFactor, blendFactors.destinationFactor);
			}
			
			//m.appendRotation(Lib.getTimer()/40, Vector3D.Z_AXIS);
			//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			
			context3D.drawTriangles(shaderProgram.value.indexbuffer, itemCount, numItemsInBatch * 2);
			itemCount += numItemsInBatch * 6;
		}
	}
	
	public function end():Void
	{
		context3D.present();
	}
}