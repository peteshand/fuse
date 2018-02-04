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
	static var context3D:Context3D;
	public static var programs:Map<Int, ShaderProgram>;
	public static var currentProgram:ShaderProgram;
	public static var lastProgram:ShaderProgram;
	
	static public function init(context3D:Context3D) 
	{
		ShaderPrograms.context3D = context3D;
		programs = new Map<Int, ShaderProgram>();
		for (i in 1...8) getProgram(i);
	}
	
	public static function getProgram(numItems:Int):ShaderProgram
	{
		currentProgram = programs.get(numItems);
		if (currentProgram == null) {
			currentProgram = new ShaderProgram(context3D, numItems);
			programs.set(numItems, currentProgram);
		}
		
		if (lastProgram != currentProgram) {
			currentProgram.update();
		}
		
		currentProgram.setBaseShader();
		
		lastProgram = currentProgram;
		return currentProgram;
	}
	
	public static function clear():Void
	{
		if (currentProgram != null) {
			currentProgram.clear();
		}
		lastProgram = currentProgram = null;
	}
}