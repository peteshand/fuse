package fuse.render.program;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.render.program.ShaderProgram;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class ShaderPrograms
{
	var context3D:Context3D;
	public var programs = new Map<Int, ShaderProgram>();
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		
	}
	
	public function getProgram(numItems:Int, numTriangles:Int):ShaderProgram
	{
		if (!programs.exists(numItems)) {
			programs.set(numItems, new ShaderProgram(context3D, numItems, numTriangles));
		}
		return programs.get(numItems);
	}
	
}