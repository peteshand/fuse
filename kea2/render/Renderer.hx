package kea2.render;

import kea2.core.memory.KeaMemory;
import kea2.core.memory.data.batchData.BatchData;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.core.memory.data.MemoryPool;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.core.texture.Textures;
import kea2.display.containers.IDisplay;
import kea2.display.effects.BlendMode;
import kea2.worker.thread.Conductor;
import kea2.worker.thread.display.ShaderProgram;
import kea2.worker.thread.display.ShaderPrograms;
import kea2.worker.thread.display.TextureOrder;
import kha.Color;
import kha.FastFloat;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import openfl.Assets;
import openfl.Lib;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display3D.textures.Texture;
import openfl.geom.Matrix3D;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class Renderer
{
	public static var bufferSize:Int = 2000;
	
	var stage3D:Stage3D;
	var context3D:Context3D;
	
	var transformations:Array<FastMatrix3>;
	var _opacity:Float = 1;
	var opacities:Array<Float>;
	
	var bufferIndex:Int;
	//var indices:Vector<UInt>;
	
	var program:Program3D;
	var m:Matrix3D = new Matrix3D();
	var numberOfDisplays:Int = 1;
	
	var textureOrder:TextureOrder;
	var shaderPrograms:ShaderPrograms;
	
	//public var vertexbuffer:VertexBuffer3D;
	//public var indexbuffer:IndexBuffer3D;
	
	/** Texture the scene is rendered to */
	private var sceneTexture:Texture;
	var vertexDataPool:MemoryPool;
	var conductorDataAccess:ConductorData;
	var currentBlendMode:Int = -1;
	var textureChannelData:Vector<Float>;
	
	public function new(stage3D:Stage3D) 
	{
		
		
		vertexDataPool = Kea.current.keaMemory.vertexDataPool;
		
		this.stage3D = stage3D;
		context3D = stage3D.context3D;
		context3D.configureBackBuffer(1600, 900, 0);
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		
		conductorDataAccess = new ConductorData();
		textureOrder = new TextureOrder();
		shaderPrograms = new ShaderPrograms(context3D);
		
		sceneTexture = context3D.createTexture(
			2048,
			2048,
			Context3DTextureFormat.BGRA,
			true
		);
		Textures.init(context3D);
		
		bufferIndex = 0;
		transformations = new Array<FastMatrix3>();
		transformations.push(FastMatrix3.identity());
		
		textureChannelData = Vector.ofArray(
		[
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		]);
		
		//var indexCount:Int = 6;// bufferSize * 3 * 2;
		//indices = new Vector<UInt>(bufferSize * indexCount);
		//for (i in 0...bufferSize) {
			//indices[i * 3 * 2 + 0] = i * 4 + 0;
			//indices[i * 3 * 2 + 1] = i * 4 + 1;
			//indices[i * 3 * 2 + 2] = i * 4 + 2;
			//indices[i * 3 * 2 + 3] = i * 4 + 0;
			//indices[i * 3 * 2 + 4] = i * 4 + 2;
			//indices[i * 3 * 2 + 5] = i * 4 + 3;
		//}
		
		var baseShader:BaseShader = new BaseShader();
		program = context3D.createProgram();
		program.upload(baseShader.vertexCode, baseShader.fragmentCode);
		
		var numVertex:Int = 4;
		//var floatsPerVectex:Int = (2 + 3 /*+ 4*/);
		
		//rectVertices = new Vector<Float>(bufferSize * floatsPerVectex * numVertex);
		
		
		//// Create VertexBuffer3D. 4 vertices, of 5 Numbers each
		//vertexbuffer = context3D.createVertexBuffer(4 * bufferSize, 5, Context3DBufferUsage.DYNAMIC_DRAW);
		//// Upload VertexBuffer3D to GPU. Offset 0, 4 vertices
		////vertexbuffer.uploadFromVector(rectVertices, 0, 4 * bufferSize);				
		////vertexbuffer.uploadFromByteArray(vertexData, 0, 0, 4);				
		//
		//
		//// Create IndexBuffer3D. Total of 3 indices. 1 triangle of 3 vertices
		//indexbuffer = context3D.createIndexBuffer(6 * bufferSize);	
		//// Upload IndexBuffer3D to GPU. Offset 0, count 3
		//indexbuffer.uploadFromVector (indices, 0, 6 * bufferSize);
	}
	
	public function begin(clear:Bool = true, clearColor:Color = null):Void
	{
		context3D.clear(clearColor.R, clearColor.G, clearColor.B);
	}
	
	public function update() 
	{
		
		//context3D.setRenderToTexture(sceneTexture);
		
		begin(true, 0xFF0000);
		drawBuffer();
		end();
		
		//conductorDataAccess.processIndex++;
		
		//context3D.setRenderToBackBuffer();
		//
		//// Render a full-screen quad with the scene texture to the actual screen
		////context3D.setProgram(program);
		////context3D.setTextureAt(0, sceneTexture);
		//context3D.clear(0, 0, 0, 0);
		////context3D.setVertexBufferAt(0, postFilterVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		//context3D.setVertexBufferAt(1, null);
		////context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, POST_FILTER_VERTEX_CONSTANTS);
		///*if (fragConsts)
		//{
			//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragConsts);
		//}*/
		//context3D.drawTriangles(indexbuffer);
	}
	
	function drawBuffer() 
	{
		if (conductorDataAccess.numberOfRenderables == 0) return;
		
		//trace(conductorDataAccess.numberOfRenderables);
		
		var shaderProgram:ShaderProgram = shaderPrograms.getProgram(conductorDataAccess.numberOfRenderables);
		
		
		var batchData:BatchData = textureOrder.getBatchData(0);
		
		shaderProgram.vertexbuffer.uploadFromByteArray(KeaMemory.memory, batchData.startIndex, 0, 4 * conductorDataAccess.numberOfRenderables);		
		// vertex position to attribute register 0
		context3D.setVertexBufferAt(0, shaderProgram.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		// UV to attribute register 1 x,y and Texture Index attribute register 1 z
		context3D.setVertexBufferAt(1, shaderProgram.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
		
		// Colour to attribute register 2
		//context3D.setVertexBufferAt(2, shaderProgram.vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
		
		shaderProgram.indexbuffer.uploadFromVector(shaderProgram.indices, 0, 6 * conductorDataAccess.numberOfRenderables);
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, textureChannelData, 4);
		// assign shader program
		context3D.setProgram(program);
		
		var firstIndex:Int = 0;
		
		for (i in 0...conductorDataAccess.numberOfBatches) 
		{
			batchData = textureOrder.getBatchData(i);
			/*trace("batchData.textureId = " + batchData.textureId);
			trace("batchData.startIndex = " + batchData.startIndex);
			trace("batchData.length = " + batchData.length);*/
			var numItems:Int = Math.floor(batchData.length / VertexData.BYTES_PER_ITEM);
			
			
			
			
			
			// assign texture to texture sampler 0
			//context3D.setTextureAt(0, Textures.getTexture(batchData.textureId));
			//context3D.setTextureAt(0, null);
			
			//trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
			context3D.setTextureAt(0, Textures.getTexture(batchData.textureId1));
			context3D.setTextureAt(1, Textures.getTexture(batchData.textureId2));
			context3D.setTextureAt(2, Textures.getTexture(batchData.textureId3));
			context3D.setTextureAt(3, Textures.getTexture(batchData.textureId4));
			
			// TODO: move this logic into worker
			var newBlendMode:Int = 0;
			if (currentBlendMode != newBlendMode) {
				currentBlendMode = newBlendMode;
				//context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				//context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				
				var blendFactors:BlendFactors = BlendMode.getBlendFactors(currentBlendMode);
				context3D.setBlendFactors(blendFactors.sourceFactor, blendFactors.destinationFactor);
			}
			
			
			//context3D.setSamplerStateAt(0, Context3DWrapMode.CLAMP, Context3DTextureFilter.NEAREST, Context3DMipFilter.MIPNONE);
			
			
			
			
			//m.appendRotation(Lib.getTimer()/40, Vector3D.Z_AXIS);
			//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			
			
			context3D.drawTriangles(shaderProgram.indexbuffer, firstIndex, numItems * 2);
			firstIndex += numItems * 6;
		}
		
		//trace("vertexDataPool.start = " + vertexDataPool.start);
		/*
		vertexbuffer.uploadFromByteArray(KeaMemory.memory, vertexDataPool.start, 0, 4 * bufferSize);		
		// UV to attribute register 1
		context3D.setVertexBufferAt(1, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		// vertex position to attribute register 0
		context3D.setVertexBufferAt(0, vertexbuffer, 2, Context3DVertexBufferFormat.FLOAT_3);
		// Colour to attribute register 2
		//context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
		// assign texture to texture sampler 0
		context3D.setTextureAt(0, Textures.getTexture(0));
		//context3D.setTextureAt(0, null);
		
		//context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		//context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		
		//context3D.setSamplerStateAt(0, Context3DWrapMode.CLAMP, Context3DTextureFilter.NEAREST, Context3DMipFilter.MIPNONE);
		
		// assign shader program
		context3D.setProgram(program);
		
		
		//m.appendRotation(Lib.getTimer()/40, Vector3D.Z_AXIS);
		//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
		
		context3D.drawTriangles(indexbuffer, 0, bufferSize * 2);
		*/
		
		bufferIndex = 0;
	}
	
	public function end():Void
	{
		context3D.present();
	}
}