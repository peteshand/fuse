package fuse.render.program;
import fuse.core.communication.data.indices.IndicesData;
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
	public var vertexbuffer:VertexBuffer3D;
	public var indexbuffer:IndexBuffer3D;
	//public var indices:Vector<UInt>;
	//public var indices:ByteArray;
	
	var indicesData:IndicesData;
	
	var baseShader:BaseShader;
	var program:Program3D;
	
	public function new(context3D:Context3D, numOfQuads:Int, numTriangles:Int=0) 
	{
		indicesData = new IndicesData();
		
		
		baseShader = new BaseShader();
		
		context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, baseShader.fragmentData, 1);
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, baseShader.textureChannelData, 4);
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, baseShader.posData, 1);
		
		var verticesPerQuad:Int = 4;
		var indicesPerQuad:Int = 6;
		var valuesPerVertex:Int = 10;
		
		for (i in 0...numOfQuads) {
			
			/*IndicesData.OBJECT_POSITION = i;
			indicesData.setIndex(0, 0);
			indicesData.setIndex(1, 1);
			indicesData.setIndex(2, 2);
			indicesData.setIndex(3, 0);
			indicesData.setIndex(4, 2);
			indicesData.setIndex(5, 3);*/
			
			/*indicesData.i1 = i * 4 + 0;
			indicesData.i2 = i * 4 + 1;
			indicesData.i3 = i * 4 + 2;
			indicesData.i4 = i * 4 + 0;
			indicesData.i5 = i * 4 + 2;
			indicesData.i6 = i * 4 + 3;*/
		}
		
		vertexbuffer = context3D.createVertexBuffer(verticesPerQuad * numOfQuads, valuesPerVertex, Context3DBufferUsage.DYNAMIC_DRAW);
		indexbuffer = context3D.createIndexBuffer(indicesPerQuad * numOfQuads);
		
		program = context3D.createProgram();
		program.upload(baseShader.vertexCode, baseShader.fragmentCode);
		
		// vertex x y position to attribute register 0
		context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		// UV to attribute register 1 x,y
		context3D.setVertexBufferAt(1, vertexbuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		// Texture Index attribute register 2 z & Alpha
		context3D.setVertexBufferAt(2, vertexbuffer, 4, Context3DVertexBufferFormat.FLOAT_2);
		// Colour to attribute, R G B A
		context3D.setVertexBufferAt(3, vertexbuffer, 6, Context3DVertexBufferFormat.FLOAT_4);
		
	}
}