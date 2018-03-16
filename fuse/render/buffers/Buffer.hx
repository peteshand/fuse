package fuse.render.buffers;

import fuse.core.communication.memory.SharedMemory;
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
	var numOfQuads:Int;
	var indicesData:ByteArray;
	
	var vertexbuffer:VertexBuffer3D;
	var indexbuffer:IndexBuffer3D;
	
	public function new(context3D:Context3D, numOfQuads:Int) 
	{
		this.numOfQuads = numOfQuads;
		this.context3D = context3D;
		trace("numOfQuads = " + numOfQuads);
		
		indicesData = new ByteArray();
		indicesData.endian = Endian.LITTLE_ENDIAN;
		indicesData.position = 0;
		indicesData.length = numOfQuads * 2;
		
		for (i in 0...numOfQuads) {
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 0);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 1);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 2);
			
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 0);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 2);
			indicesData.writeShort((i * Buffer.VERTICES_PER_QUAD) + 3);
		}
		
		indexbuffer = context3D.createIndexBuffer(Buffer.INDICES_PER_QUAD * numOfQuads, Context3DBufferUsage.STATIC_DRAW);
		vertexbuffer = context3D.createVertexBuffer(Buffer.VERTICES_PER_QUAD * numOfQuads, VertexData.VALUES_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
	}
	
	public function activate():Void
	{
		context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // Vertex x y position x,y
		context3D.setVertexBufferAt(1, vertexbuffer, 2, Context3DVertexBufferFormat.FLOAT_4); // RGB-UV x,y | Mask-UV
		context3D.setVertexBufferAt(2, vertexbuffer, 6, Context3DVertexBufferFormat.BYTES_4); // Tint Colour RGBA x,y,z,w
		context3D.setVertexBufferAt(3, vertexbuffer, 7, Context3DVertexBufferFormat.FLOAT_4); // RGB-TextureIndex x | Mask-TextureIndex y | Alpha Value z
		
		updateIndices();
	}
	
	inline function updateIndices() 
	{
		indexbuffer.uploadFromByteArray(
			indicesData, 
			0, 
			0,
			Buffer.INDICES_PER_QUAD * numOfQuads
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
		updateVertices();
	}
	
	inline function updateVertices() 
	{
		vertexbuffer.uploadFromByteArray(
			SharedMemory.memory, 
			0,
			0, 
			Buffer.VERTICES_PER_QUAD * numOfQuads
		);
	}
	
	public function drawTriangles(firstIndex:Int = 0, numTriangles:Int = -1):Void 
	{
		context3D.drawTriangles(indexbuffer, firstIndex, numTriangles);
	}
}