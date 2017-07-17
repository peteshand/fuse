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
	var currentProgram = new Notifier<Program3D>();
	var context3D:Context3D;
	
	public function new(context3D:Context3D) 
	{
		this.context3D = context3D;
		currentProgram.add(OnProgramChnge);
	}
	
	public function setProgram(program:Program3D) 
	{
		currentProgram.value = program;
	}
	
	function OnProgramChnge() 
	{
		context3D.setProgram(currentProgram.value);
	}
}