package fuse.render.buffers;

import fuse.core.communication.memory.SharedMemory;
import fuse.render.shaders.FShader;
import mantle.notifier.Notifier;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import fuse.core.communication.data.vertexData.VertexData;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
/**
 * ...
 * @author P.J.Shand
 */
class Buffer
{
	public static var VERTICES_PER_QUAD:Int = 4;
	public static var INDICES_PER_QUAD:Int = 6;
	
	var context3D:Context3D;
	var bufferSize:Int;
	var indicesData:ByteArray;
	
	var vertexbuffer:VertexBuffer3D;
	var indexbuffer:IndexBuffer3D;
	var bufferCount:Int;
	var bufferPosition:Int;
	var formatLength = new Map<Context3DVertexBufferFormat, Int>();
	
	public function new(context3D:Context3D, bufferSize:Int) 
	{
		formatLength.set(Context3DVertexBufferFormat.BYTES_4, 1);
		formatLength.set(Context3DVertexBufferFormat.FLOAT_1, 1);
		formatLength.set(Context3DVertexBufferFormat.FLOAT_2, 2);
		formatLength.set(Context3DVertexBufferFormat.FLOAT_3, 3);
		formatLength.set(Context3DVertexBufferFormat.FLOAT_4, 4);
		
		
		this.bufferSize = bufferSize;
		this.context3D = context3D;
		
		indicesData = new ByteArray();
		indicesData.endian = Endian.LITTLE_ENDIAN;
		indicesData.position = 0;
		indicesData.length = bufferSize * 2;
		
		for (i in 0...bufferSize) {
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 0);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 1);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 2);
			
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 0);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 2);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 3);
		}
		
		indexbuffer = context3D.createIndexBuffer(Buffer.INDICES_PER_QUAD * bufferSize, Context3DBufferUsage.STATIC_DRAW);
		vertexbuffer = context3D.createVertexBuffer(Buffer.VERTICES_PER_QUAD * bufferSize, VertexData.VALUES_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
	}
	
	public function activate():Void
	{
		// new order
		bufferCount = 0;
		bufferPosition = 0;
		
		addToVertexBuffer(Context3DVertexBufferFormat.FLOAT_2); // INDEX_X, INDEX_Y
		addToVertexBuffer(Context3DVertexBufferFormat.FLOAT_4); // INDEX_TEXTURE, INDEX_ALPHA, INDEX_U, INDEX_V
		addToVertexBuffer(Context3DVertexBufferFormat.BYTES_4); // INDEX_COLOR
		if (FShader.ENABLE_MASKS){
			addToVertexBuffer(Context3DVertexBufferFormat.FLOAT_4); // INDEX_MU, INDEX_MV, INDEX_MASK_TEXTURE, INDEX_MASK_BASE_VALUE
		}
		
		updateIndices();
	}
	
	function addToVertexBuffer(bufferFormat:Context3DVertexBufferFormat) 
	{
		context3D.setVertexBufferAt(bufferCount, vertexbuffer, bufferPosition, bufferFormat);
		bufferPosition += formatLength.get(bufferFormat);
		bufferCount++;
	}
	
	inline function updateIndices() 
	{
		indexbuffer.uploadFromByteArray(
			indicesData, 
			0, 
			0,
			Buffer.INDICES_PER_QUAD * bufferSize
		);
	}
	
	public function deactivate():Void
	{
		context3D.setVertexBufferAt(0, null);
		context3D.setVertexBufferAt(1, null);
		context3D.setVertexBufferAt(2, null);
		context3D.setVertexBufferAt(3, null);
	}
	
	public inline function update():Void
	{
		if (Fuse.current.conductorData.changeAvailable == 1) {
			updateVertices();
		}
	}
	
	inline function updateVertices() 
	{		
		vertexbuffer.uploadFromByteArray(
			SharedMemory.memory, 
			0,
			0, 
			Buffer.VERTICES_PER_QUAD * bufferSize
		);
	}
	
	public function drawTriangles(firstIndex:Int = 0, numTriangles:Int = -1):Void 
	{
		context3D.drawTriangles(indexbuffer, firstIndex, numTriangles);
	}
}