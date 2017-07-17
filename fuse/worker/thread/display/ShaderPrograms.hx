package fuse.worker.thread.display;
import fuse.core.memory.data.batchData.BatchData;
import fuse.core.memory.data.vertexData.VertexData;
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
	
	public function getProgram(numItems:Int):ShaderProgram
	{
		if (!programs.exists(numItems)) {
			programs.set(numItems, new ShaderProgram(context3D, numItems));
		}
		return programs.get(numItems);
	}
	
}