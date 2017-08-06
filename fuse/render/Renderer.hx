package fuse.render;

import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.render.program.ShaderPrograms;
import fuse.render.program.ShaderProgram;
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
	var context3D:Context3D;
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
		
		targetTextureId.add(OnTargetTextureIdChange);
		shaderProgram.add(OnShaderProgramChange);
	}
	
	function OnShaderProgramChange() 
	{
		if (shaderProgram.value == null) return;
		
		programChanged = true;
		var numItems:Int = conductorData.numberOfRenderables;
		shaderProgram.value.indexbuffer.uploadFromByteArray(KeaMemory.memory, Fuse.current.keaMemory.indicesDataPool.start, 0, 6 * numItems);
		
		// assign shader program
		context3DProgram.setProgram(shaderProgram.value.program);
	}
	
	function OnTargetTextureIdChange() 
	{
		if (targetTextureId.value == -1) {
			#if flash
				context3D.setRenderToTexture(null, false, 0, 0);
			#else
				context3D.setRenderToBackBuffer();
			#end
		}
		else {
			var texture:Texture = Textures.getTexture(targetTextureId.value);
			context3D.setRenderToTexture(texture.nativeTexture, false, 0, 0);
			
			if (texture._clear) {
				texture._clear = false;
				context3D.clear(texture.red, texture.green, texture.blue, 0);
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
			begin(true, Fuse.current.stage.color);
			drawBuffer();
			end();
		}
		
	}
	
	public function begin(clear:Bool = true, clearColor:Color):Void
	{
		context3D.clear(clearColor.R, clearColor.G, clearColor.B, 1);
	}
	
	function drawBuffer() 
	{
		var numItems:Int = conductorData.numberOfRenderables;
		var numTriangles:Int = conductorData.numTriangles;
		//trace("total numItems = " + numItems);
		
		if (numItems == 0) return;
		
		programChanged = false;
		shaderProgram.value = shaderPrograms.getProgram(numItems, numTriangles);
		
		var batchData:IBatchData = textureRenderBatch.getBatchData(0);
		if (batchData != null && (conductorData.isStatic == 0 || programChanged)) {
			shaderProgram.value.vertexbuffer.uploadFromByteArray(KeaMemory.memory, batchData.startIndex, 0, 4 * numItems);
		}
		
		var itemCount:Int = 0;
		
		//trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			var batchData:IBatchData = textureRenderBatch.getBatchData(i);
			var numItemsInBatch:Int = batchData.numItems;
			if (numItemsInBatch == 0) continue;
			
			targetTextureId.value = batchData.renderTargetId;
			
			//debugData(i, batchData, numItemsInBatch);
			
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
			
			//trace("itemCount = " + itemCount);
			
			context3D.drawTriangles(shaderProgram.value.indexbuffer, itemCount, numItemsInBatch * 2);
			#if flash
				itemCount += numItemsInBatch * 6;
			#else
				itemCount += numItemsInBatch * 6 * 2;
			#end
		}
	}
	
	inline function debugData(i:Int, batchData:IBatchData, numItemsInBatch:Int) 
	{
		/*for (k in 0...numItems) 
		{
			KeaMemory.memory.position = Fuse.current.keaMemory.indicesDataPool.start + (k * IndicesData.BYTES_PER_ITEM);
			var i1:Int = KeaMemory.memory.readShort();
			var i2:Int = KeaMemory.memory.readShort();
			var i3:Int = KeaMemory.memory.readShort();
			var i4:Int = KeaMemory.memory.readShort();
			var i5:Int = KeaMemory.memory.readShort();
			var i6:Int = KeaMemory.memory.readShort();
			trace([i1, i2, i3, i4, i5, i6]);
		}*/
		
		trace("Batch: " + i);
		trace("batchData.startIndex = " + batchData.startIndex);
		trace("numItemsInBatch = " + numItemsInBatch);
		trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
		trace("targetTextureId = " + targetTextureId.value);
		
		for (j in 0...numItemsInBatch) 
		{
			KeaMemory.memory.position = batchData.startIndex + (j * VertexData.BYTES_PER_ITEM);
			//trace("KeaMemory.memory.position = " + KeaMemory.memory.position);
			
			for (k in 0...1) 
			{
				var INDEX_X:Float = KeaMemory.memory.readFloat();
				var INDEX_Y:Float = KeaMemory.memory.readFloat();
				var INDEX_U:Float = KeaMemory.memory.readFloat();
				var INDEX_V:Float = KeaMemory.memory.readFloat();
				var INDEX_T:Float = KeaMemory.memory.readFloat();
				var INDEX_ALPHA:Float = KeaMemory.memory.readFloat();
				var INDEX_R:Float = KeaMemory.memory.readFloat();
				var INDEX_G:Float = KeaMemory.memory.readFloat();
				var INDEX_B:Float = KeaMemory.memory.readFloat();
				var INDEX_A:Float = KeaMemory.memory.readFloat();
				
				//trace("INDEX_X = " + INDEX_X);
				//trace("INDEX_Y = " + INDEX_Y);
				//trace("INDEX_U = " + INDEX_U);
				//trace("INDEX_V = " + INDEX_V);
				trace("INDEX_T = " + INDEX_T);
				//trace("INDEX_ALPHA = " + INDEX_ALPHA);
				//trace("INDEX_R = " + INDEX_R);
				//trace("INDEX_G = " + INDEX_G);
				//trace("INDEX_B = " + INDEX_B);
				//trace("INDEX_A = " + INDEX_A);
				
			}
			
		}
	}
	
	public function end():Void
	{
		context3D.present();
	}
}