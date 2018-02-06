package fuse.render.shader;

/**
 * ...
 * @author P.J.Shand
 */
class FuseShaders
{
	static var shaders:Map<Int, FuseShader>;
	public static var currentShader:FuseShader;
	
	public static function init():Void
	{
		shaders = new Map<Int, FuseShader>();
		//for (i in 1...8) setCurrentShader(i);
	}
	
	public static function setCurrentShader(numTextures:Int):Void
	{
		currentShader = getShader(numTextures);
	}
	
	static function getShader(numTextures:Int):FuseShader
	{
		var currentProgram:FuseShader = shaders.get(numTextures);
		if (currentProgram == null) {
			currentProgram = new FuseShader(numTextures);
			shaders.set(numTextures, currentProgram);
		}
		return currentProgram;
	}
}