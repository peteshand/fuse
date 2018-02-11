package fuse.render.program;

import fuse.core.communication.data.vertexData.VertexData;
import fuse.render.shader.FuseShader;
import fuse.render.shader.FuseShaders;
import fuse.utils.Notifier;
import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
class ShaderProgram
{
	public static var VERTICES_PER_QUAD:Int = 4;
	public static var INDICES_PER_QUAD:Int = 6;
	static var BASE_INDICES:ByteArray;
	
	public var vertexbuffer:VertexBuffer3D;
	public var indexbuffer:IndexBuffer3D;
	public var indices:ByteArray;
	
	var baseShader = new Notifier<FuseShader>();
	public var program:Program3D;
	var numOfQuads:Int;
	var context3D:Context3D;
	
	static var textureChannelData:Vector<Float>;
	static var posData:Vector<Float>;
	static var fragmentData:Vector<Float>;
	
	public static function init():Void
	{
		if (BASE_INDICES != null) return;
		
		// FRAGMENT
		fragmentData = Vector.ofArray(
		[
			0, 255, 1.0, 2.0
		]);
		
		// VERTEX
		textureChannelData = Vector.ofArray(
		[
			1.0, 0.0, 0.0, 0.0,
			0.0, 1.0, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0,
			
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,
			
			1.0, 0.0, 0.0, 0.0,
			0.0, 1.0, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0
		]);
		
		posData = Vector.ofArray(
		[
			8.0, 0.0, 0.0, 1.0
		]);
		
		BASE_INDICES = new ByteArray();
		BASE_INDICES.endian = Endian.LITTLE_ENDIAN;
	}
	
	public function new(context3D:Context3D, numOfQuads:Int) 
	{
		ShaderProgram.init();
		
		this.context3D = context3D;
		this.numOfQuads = numOfQuads;
		
		indices = ShaderProgram.BASE_INDICES;
		indices.position = 0;
		indices.length = numOfQuads * 2;
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentData, 1);
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, textureChannelData, 16);
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 16, posData, 1);
		
		for (i in 0...numOfQuads) {
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 0);
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 1);
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 2);
			
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 0);
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 2);
			indices.writeShort((i * ShaderProgram.VERTICES_PER_QUAD) + 3);
		}
		
		vertexbuffer = context3D.createVertexBuffer(VERTICES_PER_QUAD * numOfQuads, VertexData.VALUES_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
		indexbuffer = context3D.createIndexBuffer(INDICES_PER_QUAD * numOfQuads, Context3DBufferUsage.STATIC_DRAW);
		
		indexbuffer.uploadFromByteArray(
			indices, 
			0, 
			0, 
			ShaderProgram.INDICES_PER_QUAD * numOfQuads
		);
		
		program = context3D.createProgram();
		
		baseShader.add(OnShaderChange);
		baseShader.value = FuseShaders.currentShader;
		
		#if debug
		debugIndex(indices, numOfQuads, 0);
		#end
	}
	
	function OnShaderChange() 
	{
		//trace("Upload Program: " + baseShader.value.numTextures);
		program.upload(baseShader.value.vertexCode, baseShader.value.fragmentCode);
		
	}
	
	//function OnCurrentShaderChange() 
	//{
		//baseShader = FuseShaders.CURRENT_SHADER.value;
		//program.upload(baseShader.vertexCode, baseShader.fragmentCode);
	//}
	
	public function update() 
	{
		//FuseShaders.CURRENT_SHADER.change.add(OnCurrentShaderChange);
		// Vertex x y position x,y
		context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		// RGB-UV x,y | Mask-UV
		context3D.setVertexBufferAt(1, vertexbuffer, 2, Context3DVertexBufferFormat.FLOAT_4);
		// Tint Colour RGBA x,y,z,w
		context3D.setVertexBufferAt(2, vertexbuffer, 6, Context3DVertexBufferFormat.BYTES_4);
		// RGB-TextureIndex x | Mask-TextureIndex y | Alpha Value z
		context3D.setVertexBufferAt(3, vertexbuffer, 7, Context3DVertexBufferFormat.FLOAT_4);
	}
	
	public function setBaseShader() 
	{
		baseShader.value = FuseShaders.currentShader;
	}
	
	#if debug
	function debugIndex(indices:ByteArray, numItemsInBatch:Int, startIndex:Int) 
	{
		indices.position = startIndex;
		for (i in 0...numItemsInBatch) 
		{
			var i1:Int = indices.readShort();
			var i2:Int = indices.readShort();
			var i3:Int = indices.readShort();
			var i4:Int = indices.readShort();
			var i5:Int = indices.readShort();
			var i6:Int = indices.readShort();
			//trace([i1, i2, i3, i4, i5, i6]);
		}
		//trace("debugIndex");
	}
	#end
	
	public function clear():Void
	{
		//FuseShaders.CURRENT_SHADER.change.remove(OnCurrentShaderChange);
		context3D.setVertexBufferAt(0, null);
		context3D.setVertexBufferAt(1, null);
		context3D.setVertexBufferAt(2, null);
		context3D.setVertexBufferAt(3, null);
	}
}