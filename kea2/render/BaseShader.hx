package kea2.render;
import openfl.display3D.Context3DProgramType;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class BaseShader
{
	var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
	var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
	var _vertexCode:ByteArray;
	var _fragmentCode:ByteArray;
	
	var vertexString(get, null):String;
	var fragmentString(get, null):String;
	
	public var vertexCode(get, null):ByteArray;
	public var fragmentCode(get, null):ByteArray;
	
	public function new() 
	{
		
	}
	
	function get_vertexCode():ByteArray 
	{
		if (_vertexCode == null) _vertexCode = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, vertexString);
		return _vertexCode;
	}
	
	function get_fragmentCode():ByteArray 
	{
		if (_fragmentCode == null) _fragmentCode = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT, fragmentString);
		return _fragmentCode;
	}
	
	// Override
	function get_fragmentString():String 
	{
		/*return //
			"tex ft0, v0, fs0 <2d>\n" +
			"mul ft1, v1, ft0 \n" +
			//"mov ft1, v1 \n" +
			"mov oc, ft1";
			
		return "mov oc, v0 ";*/
		
		//return "tex ft1, v0, fs[fc0.x] <2d,repeat,linear>\n" +
		return "tex ft1, v0, fs0 <2d,repeat,linear>	\n" +
			"tex ft2, v0, fs1 <2d,repeat,linear>\n" +
			"tex ft3, v0, fs2 <2d,repeat,linear>\n" +
			"tex ft4, v0, fs3 <2d,repeat,linear>\n" +
			//"div ft1.xyz, ft1.xyz, ft1.w \n" +  // un-premultiply png
			
			//"mov ft3.xxxx, v1.xxxx		\n" +
			//"mov ft4.xxxx, fc[ft3.x].xxxx		\n" +
			//"mov ft5.xyzw, fc[ft3.x].xxxx		\n" +
			
			"mul ft1.xyzw, ft1.xyzw, v1.xxxx		\n" +
			"mul ft2.xyzw, ft2.xyzw, v1.yyyy		\n" +
			
			"add ft1, ft1, ft2						\n" +
			
			"mov oc, ft1";
	}
	
	// Override
	function get_vertexString():String 
	{
		return "mov op, va0	\n" + // pos to clipspace
			"mov v0, va1	\n" + // + // copy UV
			
			"mov vt0, va1	\n" + // copy Texture Index
			
			"mov v1.xyzw, vc[vt0.z].xyzw"; // copy Texture Index
			//"mov v1, va2"; // copy Colour
			
	}
	
}
//
////First, here's the most basic texture sampling shader you can get
//fragmentShader = "tex oc, v1, fs0 <2d,repeat,linear>"; //sample texture and output RGB
 //
////Here's what it looks like un-multiplied
//fragmentShader = 
//"tex ft0, v1, fs0 <2d,repeat,linear> \n" + //sample texture
//"div ft0.rgb, ft0.rgb, ft0.a \n" +  // un-premultiply png
//"mov oc, ft0" //output fixed RGB