package kea2.worker.thread.display;
import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;

/**
 * ...
 * @author P.J.Shand
 */
class ShaderProgram
{
	public var vertexbuffer:VertexBuffer3D;
	public var indexbuffer:IndexBuffer3D;
	public var indices:Vector<UInt>;
	
	public function new(context3D:Context3D, bufferSize:Int) 
	{
		var indexCount:Int = 6;// bufferSize * 3 * 2;
		indices = new Vector<UInt>(bufferSize * indexCount);
		for (i in 0...bufferSize) {
			indices[i * 3 * 2 + 0] = i * 4 + 0;
			indices[i * 3 * 2 + 1] = i * 4 + 1;
			indices[i * 3 * 2 + 2] = i * 4 + 2;
			indices[i * 3 * 2 + 3] = i * 4 + 0;
			indices[i * 3 * 2 + 4] = i * 4 + 2;
			indices[i * 3 * 2 + 5] = i * 4 + 3;
		}
		
		vertexbuffer = context3D.createVertexBuffer(4 * bufferSize, 7, Context3DBufferUsage.DYNAMIC_DRAW);
		indexbuffer = context3D.createIndexBuffer(6 * bufferSize);
		
	}
}