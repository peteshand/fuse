package fuse.render;
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
	public var posData:Vector<Float>;
	public var fragmentData:Vector<Float>;
	public var vertexCode(get, null):ByteArray;
	public var fragmentCode(get, null):ByteArray;
	
	public function new() 
	{
		textureChannelData = Vector.ofArray(
		[
			1.0, 0.0, 0.0, 0.0,
			0.0, 1.0, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0
		]);
		posData = Vector.ofArray(
		[
			0.0, 0.0, 0.0, 1.0
		]);
		fragmentData = Vector.ofArray(
		[
			0, 0, 1.0, 2.0
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
		/*return "\n" +
			"tex ft0, v1, fs0 <2d,repeat,linear>	\n" +
			"tex ft2, v1, fs1 <2d,repeat,linear>	\n" +
			"tex ft1, v1, fs2 <2d,repeat,linear>	\n" +
			"tex ft4, v1, fs3 <2d,repeat,linear>	\n" +
			
			"mov ft0.xyzw, fc0.xyzw					\n" +
			
			"mov oc, ft0";*/
		var alias:Array<AgalAlias> = [];
		alias.push( { alias:"TWO.3", value:"fc0.www" } );
		alias.push( { alias:"ONE.3", value:"fc0.zzz" } );
		alias.push( { alias:"ONE.4", value:"fc0.zzzz" } );
		
		var agal:String = "\n" +
			"tex ft1, v1, fs0 <2d,repeat,linear>	\n" +
			"mul ft0.xyzw, ft1.xyzw, v2.xxxx		\n" +
			
			"tex ft1, v1, fs1 <2d,repeat,linear>	\n" +
			"mul ft1.xyzw, ft1.xyzw, v2.yyyy		\n" +
			"add ft0, ft0, ft1						\n" +
			
			"tex ft1, v1, fs2 <2d,repeat,linear>	\n" +
			"mul ft1.xyzw, ft1.xyzw, v2.zzzz		\n" +
			"add ft0, ft0, ft1						\n" +
			
			"tex ft1, v1, fs3 <2d,repeat,linear>	\n" +
			"mul ft1.xyzw, ft1.xyzw, v2.wwww		\n" +
			"add ft0, ft0, ft1						\n" +
			
			//"mul ft0.xyz, ft0.xyz, v4.xxx			\n" +
			//"mov ft0.w, fc0.y			\n" +
			
			//"mov ft1, v3							\n" +
			//"mul ft1.xyz, ft1.xyz, TWO.3			\n" + // Mul by 2
			//"sub ft1.xyz, ft1.xyz, ONE.3			\n" + // Subtract 1
			//"add ft1.w, ft1.w, ft0.w				\n" +
			//"mul ft1.xyz, ft1.xyz, ft1.www		\n" +
			//"add ft0, ft0, ft1					\n" +
			
			"mov ft1, v3							\n" +
			//"sub ft2, ONE.4, v3						\n" +
			
			//"mov ft1.xyw, fc0.xxx						\n" +
			
			"mul ft1.xyz, ft1.xyz, TWO.3			\n" + // Mul by 2
			"sub ft1.xyz, ft1.xyz, ONE.3			\n" + // Subtract 1
			"mul ft1.w, ft1.w, ft0.w				\n" +
			"mul ft1.xyz, ft1.xyz, ft1.www			\n" +
			//"mul ft1.xyz, ft1.xyz, ft1.www			\n" +
			//"mov ft0.xyz, ft1.xyz			\n" +
			"add ft0.xyz, ft0.xyz, ft1.xyz			\n" +
			//"mul ft0.xyw, ft0.xyw, v4.xxx					\n" +
			//"mul ft0.w, ft0.w, v4.x					\n" +
			
			//"mul ft3.xyzw, ft0.xyzw, ft1.wwww		\n" +
			//"mul ft4.xyzw, ft0.xyzw, ft2.wwww		\n" +
			//"add ft0, ft3, ft4						\n" +
			
			//"mov ft0.y, v3.y					\n" +
			
			//"mul ft0, v3.xyz, v3.www			\n" +
			//"add ft0, ft0, ft5					\n" +
			
			"mov oc, ft0";
		
		for (i in 0...alias.length) 
		{
			agal = agal.split(alias[i].alias).join(alias[i].value);
		}
		//trace("agal = " + agal);
		return agal;
	}
	
	function get_vertexString():String 
	{
		return "mov vt0.zw, vc4.zw	\n" + // set z and w pos to vt0
			"mov vt0.xy, va0.xy		\n" + // set x and y pos to vt0
			"mov op, vt0			\n" + // set vt0 to clipspace
			"mov v1, va1			\n" + // + // copy UV
			
			"mov vt2, va2			\n" + // copy Texture Index
			"mov vt3, vc[vt2.x]		\n" + // set textureIndex alpha multipliers
			"sub vt3, vt3, vt2.yyyy \n" + // substract inverted alpha from textureIndex alpha
			"max vt3, vt3, vc0.w \n" + // clamp above 0
			"min vt3, vt3, vc0.x \n" + // clamp below 1
			
			"mov v2, vt3		\n" + // copy textureIndex alpha multipliers into v2
			
			"mov v3, va3			";// copy colour data
			//"mov v4, va4			"; 	  // copy alpha data
			
			//"mov v2, va2"; // copy Colour
		
		/*return "mov op, va0	\n" + // pos to clipspace
			"mov v1, va1	\n" + // + // copy UV
			
			"mov vt2, va2	\n" + // copy Texture Index
			
			"mov v2.xyzw, vc[vt2.x].xyzw"; // copy Texture Index
			//"mov v2, va2"; // copy Colour
			*/
	}
	
}

typedef AgalAlias =
{
	value:String,
	alias:String
}