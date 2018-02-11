package fuse.render.program;

import fuse.utils.Notifier;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;

/**
 * ...
 * @author P.J.Shand
 */
class Context3DProgram
{
	static var currentProgram = new Notifier<Program3D>();
	static var context3D:Context3D;
	
	public static function init(context3D:Context3D) 
	{
		Context3DProgram.context3D = context3D;
		currentProgram.add(OnProgramChnge);
	}
	
	public static inline function setProgram(program:Program3D) 
	{
		currentProgram.value = program;
	}
	
	static public function clear() 
	{
		Context3DProgram.setProgram(null);
	}
	
	static inline function OnProgramChnge() 
	{
		//trace("setProgram");
		context3D.setProgram(currentProgram.value);
	}
}