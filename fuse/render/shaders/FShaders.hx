package fuse.render.shaders;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
class FShaders
{
	static var context3D:Context3D;
	static private var lastShader:FShader;
	static private var currentShader:FShader;
	public static var shaders:Map<Int, FShader>;
	
	static public function init(context3D:Context3D) 
	{
		FShaders.context3D = context3D;
		
		FShader.init();
		
		shaders = new Map<Int, FShader>();
		/*for (i in 0...8) 
		{
			getShader(i+1, 0);
		}*/
	}
	
	public function new() 
	{
		
	}
	
	public static function getShader(numTextures:Int, shaderId:Int):FShader
	{
		lastShader = currentShader;

		var id:Int = numTextures + Math.floor(numTextures * shaderId);
		
		currentShader = shaders.get(id);
		
		if (lastShader != currentShader && lastShader != null) {
			lastShader.deactivate();
		}
		if (currentShader == null) {
			currentShader = new FShader(context3D, numTextures, shaderId);
			shaders.set(id, currentShader);
		}
		
		return currentShader;
	}
	
	static public function deactivate() 
	{
		if (currentShader != null) {
			currentShader.deactivate();
		}
		currentShader = null;
	}
}