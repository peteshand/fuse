package fuse.render.program;

import fuse.core.communication.data.batchData.WorkerBatchData;
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
	public var currentProgram:ShaderProgram;
	public var lastProgram:ShaderProgram;
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		
	}
	
	public function getProgram(numItems:Int, numTriangles:Int):ShaderProgram
	{
		currentProgram = programs.get(numItems);
		if (currentProgram == null) {
			currentProgram = new ShaderProgram(context3D, numItems, numTriangles);
			programs.set(numItems, currentProgram);
		}
		
		if (lastProgram != currentProgram) {
			currentProgram.update();
		}
		
		lastProgram = currentProgram;
		return currentProgram;
	}
	
	public function clear():Void
	{
		if (currentProgram != null) {
			currentProgram.clear();
		}
		lastProgram = currentProgram = null;
	}
}