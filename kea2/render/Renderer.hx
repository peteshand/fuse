package kea2.render;

import kea2.core.memory.KeaMemory;
import kea2.core.memory.data.batchData.BatchData;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.core.memory.data.MemoryPool;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.core.texture.Textures;
import kea2.display.containers.IDisplay;
import kea2.display.effects.BlendMode;
import kea2.render.program.Context3DProgram;
import kea2.render.texture.Context3DTexture;
import kea2.texture.Texture;
import kea2.utils.Notifier;
import kea2.worker.thread.Conductor;
import kea2.worker.thread.display.ShaderProgram;
import kea2.worker.thread.display.ShaderPrograms;
import kea2.worker.thread.display.TextureOrder;
import kea2.worker.thread.display.TextureRenderBatch;
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
import openfl.display3D.textures.Texture as NativeTexture;
import openfl.events.TimerEvent;
import openfl.geom.Matrix3D;
import openfl.utils.ByteArray;
import openfl.utils.Timer;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class Renderer
{
	var renderIndex:Int = 0;
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
	var textureRenderBatch:TextureRenderBatch;
	var shaderPrograms:ShaderPrograms;
	
	//public var vertexbuffer:VertexBuffer3D;
	//public var indexbuffer:IndexBuffer3D;
	
	/** Texture the scene is rendered to */
	private var sceneTexture:NativeTexture;
	var vertexDataPool:MemoryPool;
	public var conductorData:ConductorData;
	var currentBlendMode:Int = -1;
	var currentTextureId = new Notifier<Int>(-2);
	
	var context3DTexture:Context3DTexture;
	var context3DProgram:Context3DProgram;
	var baseShader:BaseShader;
	var shaderProgram = new Notifier<ShaderProgram>();
	
	public function new(stage3D:Stage3D) 
	{
		vertexDataPool = Kea.current.keaMemory.vertexDataPool;
		
		
		this.stage3D = stage3D;
		context3D = stage3D.context3D;
		context3D.configureBackBuffer(1600, 900, 0);
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		
		#if debug
			context3D.enableErrorChecking = true;
		#end
		
		context3DTexture = new Context3DTexture(context3D);
		context3DProgram = new Context3DProgram(context3D);
		
		
		conductorData = new ConductorData();
		textureOrder = new TextureOrder();
		textureRenderBatch = new TextureRenderBatch();
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
		
		baseShader = new BaseShader();
		program = context3D.createProgram();
		program.upload(baseShader.vertexCode, baseShader.fragmentCode);
		
		currentTextureId.add(OnCurrentTextureIdChange);
		shaderProgram.add(OnShaderProgramChange);
	}
	
	function OnShaderProgramChange() 
	{
		if (shaderProgram.value == null) return;
		
		var numItems:Int = conductorData.numberOfRenderables;
		
		// vertex position to attribute register 0
		context3D.setVertexBufferAt(0, shaderProgram.value.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		// UV to attribute register 1 x,y
		context3D.setVertexBufferAt(1, shaderProgram.value.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		// Texture Index attribute register 1 z
		context3D.setVertexBufferAt(2, shaderProgram.value.vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_2);
		// Colour to attribute register 2
		//context3D.setVertexBufferAt(2, shaderProgram.value.vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
		
		shaderProgram.value.indexbuffer.uploadFromVector(shaderProgram.value.indices, 0, 6 * numItems);
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, baseShader.textureChannelData, 4);
		// assign shader program
		context3DProgram.setProgram(program);
	}
	
	function OnCurrentTextureIdChange() 
	{
		
		if (currentTextureId.value == -1) {
		//	trace("OnCurrentTextureIdChange: setRenderToBackBuffer");
			context3D.setRenderToBackBuffer();
		}
		else {
		//	trace("OnCurrentTextureIdChange: setRenderToTexture");
			var texture:Texture = Textures.getTexture(currentTextureId.value);
			context3D.setRenderToTexture(texture.nativeTexture, true);
			if (texture._clear) {
				texture._clear = false;
				context3D.clear(0, 0, 0, 0);
			}
		}
	}
	
	public function update() 
	{
		//context3D.setRenderToTexture(sceneTexture);
		
		//trace("frameIndex = " + conductorData.frameIndex);
		//trace("renderIndex = " + renderIndex);
		
		//currentTextureId._value = -2;
		currentTextureId.value = -1;
		
		
		begin(true, 0xFF0000);
		drawBuffer();
		end();
		
	}
	
	public function begin(clear:Bool = true, clearColor:Color = null):Void
	{
		//context3D.clear(clearColor.R, clearColor.G, clearColor.B, 0.3);
		context3D.clear(0, 0, 0, 1);
	}
	
	function drawBuffer() 
	{
		var numItems:Int = conductorData.numberOfRenderables;
		if (numItems == 0) return;
		//trace("total numItems = " + numItems);
		
		shaderProgram.value = shaderPrograms.getProgram(numItems);
		
		var batchData:BatchData = textureRenderBatch.getBatchData(0);
		if (batchData != null){
			shaderProgram.value.vertexbuffer.uploadFromByteArray(KeaMemory.memory, batchData.startIndex, 0, 4 * numItems);
		}
		
		var itemCount:Int = 0;
		
		//trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			
			var batchData:BatchData = textureRenderBatch.getBatchData(i);
			var numItemsInBatch:Int = batchData.numItems;
			
			//trace("numItemsInBatch = " + numItemsInBatch);
			
			if (numItemsInBatch == 0) continue;
			
			currentTextureId.value = batchData.renderTargetId;
			
			//trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
			
			
			context3DTexture.setContextTexture(0, batchData.textureId1);
			context3DTexture.setContextTexture(1, batchData.textureId2);
			context3DTexture.setContextTexture(2, batchData.textureId3);
			context3DTexture.setContextTexture(3, batchData.textureId4);
			
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
			//trace("itemCount = " + itemCount);
			//trace(numItemsInBatch * 2);
			
			context3D.drawTriangles(shaderProgram.value.indexbuffer, itemCount, numItemsInBatch * 2);
			
			itemCount += numItemsInBatch * 6;
		}
		
		bufferIndex = 0;
	}
	
	
	
	
	
	public function end():Void
	{
		context3D.present();
	}
	
	//public function start() 
	//{
		//var timer:Timer = new Timer(1, 0);
		//timer.addEventListener(TimerEvent.TIMER, OnTick);
		//timer.start();
	//}
	//
	//private function OnTick(e:TimerEvent):Void 
	//{
		///*var i:Int = 0;
		//while (renderIndex == conductorData.frameIndex) {
			//// wait
			//i++;
		//}*/
		//if (renderIndex != conductorData.frameIndex) {
			//update();
			//renderIndex = conductorData.frameIndex;
		//}
	//}
}