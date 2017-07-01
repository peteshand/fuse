package kea2.render;
import openfl.Vector;
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
	
	public var textureChannelData:Vector<Float>;
	public var vertexCode(get, null):ByteArray;
	public var fragmentCode(get, null):ByteArray;
	
	public function new() 
	{
		textureChannelData = Vector.ofArray(
		[
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		]);
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
		return "\n" +
			"tex ft1, v0, fs0 <2d,repeat,linear>	\n" +
			"tex ft2, v0, fs1 <2d,repeat,linear>	\n" +
			"tex ft3, v0, fs2 <2d,repeat,linear>	\n" +
			"tex ft4, v0, fs3 <2d,repeat,linear>	\n" +
			
			"mul ft1.xyzw, ft1.xyzw, v1.xxxx		\n" +
			"mul ft2.xyzw, ft2.xyzw, v1.yyyy		\n" +
			"mul ft3.xyzw, ft3.xyzw, v1.zzzz		\n" +
			"mul ft4.xyzw, ft4.xyzw, v1.wwww		\n" +
			
			"add ft1, ft1, ft2						\n" +
			"add ft1, ft1, ft3						\n" +
			"add ft1, ft1, ft4						\n" +
			
			"mov oc, ft1";
	}
	
	function get_vertexString():String 
	{
		return "mov op, va0	\n" + // pos to clipspace
			"mov v0, va1	\n" + // + // copy UV
			
			"mov vt2, va2	\n" + // copy Texture Index
			
			"mov v1.xyzw, vc[vt2.x].xyzw"; // copy Texture Index
			//"mov v1, va2"; // copy Colour
			
	}
	
}