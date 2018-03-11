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
	static var buckets:Array<Int>;
	
	static public function init(context3D:Context3D) 
	{
		ShaderPrograms.context3D = context3D;
		
		buckets = [
			250,
			500,
			1000,
			2000,
			3000,
			4000,
			5000,
			10000
		];
		
		programs = new Map<Int, ShaderProgram>();
		for (i in 0...buckets.length) getProgram(buckets[i]);
		
		ShaderProgram.init();
	}
	
	public static function getProgram(numItems:Int):ShaderProgram
	{
		//var id:Int = getGroupId(numItems);
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
	
	public static function getGroupId(numItems:Int) 
	{
		for (i in 0...buckets.length) 
		{
			if (numItems < buckets[i]) return buckets[i];
		}
		return numItems;
	}
	
	public static function clear():Void
	{
		if (currentProgram != null) {
			currentProgram.clear();
		}
		lastProgram = currentProgram = null;
	}
}