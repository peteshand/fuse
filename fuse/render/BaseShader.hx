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
	static var VERTEX_CODE:ByteArray;
	static var FRAGMENT_CODE:ByteArray;
	
	static var vertexShaderAssembler:AGALMiniAssembler;
	static var fragmentShaderAssembler:AGALMiniAssembler;
	//var _vertexCode:ByteArray;
	//var _fragmentCode:ByteArray;
	
	//var vertexString(get, null):String;
	//var fragmentString(get, null):String;
	
	public var textureChannelData:Vector<Float>;
	public var posData:Vector<Float>;
	public var fragmentData:Vector<Float>;
	public var vertexCode(get, null):ByteArray;
	public var fragmentCode(get, null):ByteArray;
	
	static function init():Void
	{
		if (BaseShader.vertexShaderAssembler == null) {		
			BaseShader.vertexShaderAssembler = new AGALMiniAssembler();
			BaseShader.fragmentShaderAssembler = new AGALMiniAssembler();
			
			BaseShader.VERTEX_CODE = vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, VERTEX_STRING());
			BaseShader.FRAGMENT_CODE = fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, FRAGMENT_STRING());
		}
	}
	
	public function new() 
	{
		BaseShader.init();
		
		// FRAGMENT
		fragmentData = Vector.ofArray(
		[
			0, 255, 1.0, 2.0
		]);
		
		// VERTEX
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
		
	}
	
	function get_vertexCode():ByteArray 
	{
		return BaseShader.VERTEX_CODE;
		//if (_vertexCode == null) _vertexCode = vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, vertexString);
		//return _vertexCode;
	}
	
	function get_fragmentCode():ByteArray 
	{
		return BaseShader.FRAGMENT_CODE;
		//if (_fragmentCode == null) _fragmentCode = fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT, fragmentString);
		//return _fragmentCode;
	}
	
	// Override
	static function FRAGMENT_STRING():String 
	{
		var alias:Array<AgalAlias> = [];
		alias.push( { alias:"TWO.3", value:"fc0.www" } );
		alias.push( { alias:"ONE.1", value:"fc0.z" } );
		alias.push( { alias:"ONE.3", value:"fc0.zzz" } );
		alias.push( { alias:"ONE.4", value:"fc0.zzzz" } );
		alias.push( { alias:"MASK_BASE.1", value:"v5.z" } );
		
		
		var agal:String = "\n" +
			
			/////////////////////////////////////////////
			// RGBA from 4 available textures ///////////
			"tex ft0, v1.xy, fs0 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v2.xxxx		\n" +
			"mov ft1, ft0							\n" +
			
			"tex ft0, v1.xy, fs1 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v2.yyyy		\n" +
			"add ft1, ft1, ft0						\n" +
			
			"tex ft0, v1.xy, fs2 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v2.zzzz		\n" +
			"add ft1, ft1, ft0						\n" +
			
			"tex ft0, v1.xy, fs3 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v2.wwww		\n" +
			"add ft1, ft1, ft0						\n" +
			/////////////////////////////////////////////
			/////////////////////////////////////////////
			
			
			/////////////////////////////////////////////
			// Mask from 4 available textures ///////////
			"tex ft0, v1.zw, fs0 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v4.xxxx		\n" +
			"mov ft2, ft0							\n" +
			
			"tex ft0, v1.zw, fs1 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v4.yyyy		\n" +
			"add ft2, ft2, ft0						\n" +
			
			"tex ft0, v1.zw, fs2 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v4.zzzz		\n" +
			"add ft2, ft2, ft0						\n" +
			
			"tex ft0, v1.zw, fs3 <2d,clamp,linear>	\n" +
			"mul ft0.xyzw, ft0.xyzw, v4.wwww		\n" +
			"add ft2, ft2, ft0						\n" +
			/////////////////////////////////////////////
			/////////////////////////////////////////////
			
			/////////////////////////////////////////////
			// Multiply Alpha by Mask Value /////////////
			"add ft2.w, ft2.w, MASK_BASE.1			\n" +
			"mul ft1.xyzw, ft1.xyzw, ft2.w			\n" +
			
			//"sub ft2.w, ONE.1, ft2.w				\n" + // Invert Mask
			//"add ft2.w, ft2.w, MASK_BASE.1		\n" + // Add maskBaseValue to mask multiplier value
			//"mul ft1.w, ft1.w, ft2.w				\n" +
			//"max ft1, ft1, fc0.z	\n" + // clamp above 0
			//"min ft1, ft1, fc0.x	\n" + // clamp below 1
			
			//"sub ft1.zw, ft1.zw, ft2.xx		\n" + // Test. Sub blue channel from alpha
			//"mov ft1.w, ft2.x						\n" + // Test. Sub blue channel from alpha
			
			/////////////////////////////////////////////
			// Add Colour ///////////////////////////////
			//"mov ft0, v3							\n" +
			//"mul ft0.xyz, ft0.xyz, TWO.3			\n" + // Mul by 2
			//"sub ft0.xyz, ft0.xyz, ONE.3			\n" + // Subtract 1
			//"mul ft0.w, ft0.w, ft1.w				\n" +
			//"mul ft0.xyz, ft0.xyz, ft0.www			\n" +
			//"add ft1.xyz, ft1.xyz, ft0.xyz			\n" +
			/////////////////////////////////////////////
			/////////////////////////////////////////////
			
			"mov ft0, v3							\n" +
			//"mul ft0.xyz, ft0.xyz, TWO.3			\n" + // Mul by 2
			//"sub ft0.xyz, ft0.xyz, ONE.3			\n" + // Subtract 1
			"mul ft0.w, ft0.w, ft1.w				\n" +
			"sub ft0.xyz, ONE.3, ft0.xyz			\n" +
			"mul ft0.xyz, ft0.xyz, ft0.www			\n" +
			"sub ft1.xyz, ft1.xyz, ft0.xyz			\n" +
			
			"mov oc, ft1";
		
		for (i in 0...alias.length) 
		{
			agal = agal.split(alias[i].alias).join(alias[i].value);
		}
		//trace("agal = " + agal);
		return agal;
	}
	
	static function VERTEX_STRING():String 
	{
		var agal:String = "mov vt0.zw, vc4.zw	\n" + // set z and w pos to vt0
			"mov vt0.xy, va0.xy		\n" + // set x and y pos to vt0
			"mov op, vt0			\n" + // set vt0 to clipspace
			"mov v1, va1			\n" + // + // copy RGB-UV && Mask-UVc
			
			"mov vt2, va3			\n" + // copy RGB-TextureIndex | Mask-TextureIndex | Alpha Value
			
			"mov vt3, vc[vt2.x]		\n" + // set textureIndex alpha multipliers
			"mov vt4, vc[vt2.y]		\n" + // set mask textureIndex alpha multipliers
			
			"sub vt3, vt3, vt2.wwww \n" + // substract inverted alpha from textureIndex alpha
			"max vt3, vt3, vc4.z	\n" + // clamp above 0 // NEED TO SWITCH TO vc4
			"min vt3, vt3, vc4.w	\n" + // clamp below 1 // NEED TO SWITCH TO vc4
			
			"mov v2, vt3			\n" + // copy RGB-TextureIndex with alpha multipliers into v2
			"mov v3.xyzw, va2.zyxw	\n"	+ // copy tint colour data and flip Red and Blue
			"mov v4, vt4			\n"	+ // 
			"mov v5.xyzw, vt2.zzzz	";// copy maskBaseValue into v5
		
		return agal;
	}
	
}

typedef AgalAlias =
{
	value:String,
	alias:String
}