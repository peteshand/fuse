package fuse.render.shader;

import openfl.Vector;
import openfl.display3D.Context3DProgramType;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class FuseShader
{
	var VERTEX_CODE:ByteArray;
	var FRAGMENT_CODE:ByteArray;
	var numTextures:Int;
	
	static var agalMiniAssembler:AGALMiniAssembler;
	static var rgbaIndex:Array<String>;
	static var maskIndex:Array<String>;
	
	public var vertexCode(get, null):ByteArray;
	public var fragmentCode(get, null):ByteArray;
	
	static function init():Void
	{
		if (FuseShader.agalMiniAssembler == null) {		
			FuseShader.agalMiniAssembler = new AGALMiniAssembler();
			
			rgbaIndex = [
				"v2.xxxx", 
				"v2.yyyy", 
				"v2.zzzz", 
				"v2.wwww",
				"v3.xxxx", 
				"v3.yyyy", 
				"v3.zzzz", 
				"v3.wwww"
			];
			
			maskIndex = [
				"v4.xxxx", 
				"v4.yyyy", 
				"v4.zzzz", 
				"v4.wwww",
				"v5.xxxx", 
				"v5.yyyy", 
				"v5.zzzz", 
				"v5.wwww"
			];
		}
	}
	
	public function new(numTextures:Int) 
	{
		this.numTextures = numTextures;
		FuseShader.init();
		
		VERTEX_CODE = agalMiniAssembler.assemble(Context3DProgramType.VERTEX, VERTEX_STRING());
		FRAGMENT_CODE = agalMiniAssembler.assemble(Context3DProgramType.FRAGMENT, FRAGMENT_STRING());
	}
	
	function get_vertexCode():ByteArray 
	{
		return VERTEX_CODE;
	}
	
	function get_fragmentCode():ByteArray 
	{
		return FRAGMENT_CODE;
	}
	
	// Override
	public function FRAGMENT_STRING():String 
	{
		var alias:Array<AgalAlias> = [];
		alias.push( { alias:"TWO.3", value:"fc0.www" } );
		alias.push( { alias:"ONE.1", value:"fc0.z" } );
		alias.push( { alias:"ONE.3", value:"fc0.zzz" } );
		alias.push( { alias:"ONE.4", value:"fc0.zzzz" } );
		alias.push( { alias:"MASK_BASE.1", value:"v6.z" } );
		
		
		var agal:String = "\n";
			
			/////////////////////////////////////////////
			// RGBA from 4 available textures ///////////
			
			for (j in 0...numTextures) 
			{
				agal += "tex ft0, v1.xy, fs" + j + " <2d,clamp,linear>	\n";
				agal += "mul ft0.xyzw, ft0.xyzw, " + rgbaIndex[j] + "	\n";
				if (j == 0)	agal += "mov ft1, ft0						\n";
				else 		agal += "add ft1, ft1, ft0					\n";
			}
			
			for (j in 0...numTextures) 
			{
				agal += "tex ft0, v1.zw, fs" + j + " <2d,clamp,linear>	\n";
				agal += "mul ft0.xyzw, ft0.xyzw, " + maskIndex[j] + "	\n";
				if (j == 0)	agal += "mov ft2, ft0						\n";
				else 		agal += "add ft2, ft2, ft0					\n";
			}
			//for (k in numTextures...8) 
			//{
				//agal += "tex ft0, v1.xy, fs" + k + " <2d,clamp,linear>	\n";
			//}
			
			/////////////////////////////////////////////
			/////////////////////////////////////////////
			
			/////////////////////////////////////////////
			// Multiply Alpha by Mask Value /////////////
			agal += "add ft2.w, ft2.w, MASK_BASE.1						\n" +
			"mul ft1.xyzw, ft1.xyzw, ft2.w								\n" +
			
			
			
			
			//"sub ft2.w, ONE.1, ft2.w				\n" + // Invert Mask
			//"add ft2.w, ft2.w, MASK_BASE.1		\n" + // Add maskBaseValue to mask multiplier value
			//"mul ft1.w, ft1.w, ft2.w				\n" +
			//"max ft1, ft1, fc0.z	\n" + // clamp above 0
			//"min ft1, ft1, fc0.x	\n" + // clamp below 1
			
			//"sub ft1.zw, ft1.zw, ft2.xx		\n" + // Test. Sub blue channel from alpha
			//"mov ft1.w, ft2.x						\n" + // Test. Sub blue channel from alpha
			
			/////////////////////////////////////////////
			// Add Colour ///////////////////////////////
			//"mov ft0, v7							\n" +
			//"mul ft0.xyz, ft0.xyz, TWO.3			\n" + // Mul by 2
			//"sub ft0.xyz, ft0.xyz, ONE.3			\n" + // Subtract 1
			//"mul ft0.w, ft0.w, ft1.w				\n" +
			//"mul ft0.xyz, ft0.xyz, ft0.www			\n" +
			//"add ft1.xyz, ft1.xyz, ft0.xyz			\n" +
			/////////////////////////////////////////////
			/////////////////////////////////////////////
			
			"mov ft0, v7							\n" +
			"mul ft0.w, ft0.w, ft1.w				\n" +
			"sub ft0.xyz, ONE.3, ft0.xyz			\n" +
			"mul ft0.xyz, ft0.xyz, ft0.www			\n" +
			"sub ft1.xyz, ft1.xyz, ft0.xyz			\n" +
			
			//"mov oc0, ft1							\n" +
			"mov oc0, ft1";
		
		for (i in 0...alias.length) 
		{
			agal = agal.split(alias[i].alias).join(alias[i].value);
		}
		//trace("agal = " + agal);
		return agal;
	}
	
	function VERTEX_STRING():String 
	{
		var agal:String = "mov vt0.zw, vc16.zw	\n" + // set z and w pos to vt0
			"mov vt0.xy, va0.xy		\n" + // set x and y pos to vt0
			"mov op, vt0			\n" + // set vt0 to clipspace
			"mov v1, va1			\n" + // + // copy RGB-UV && Mask-UVc
			
			"mov vt1, va3			\n" + // copy RGB-TextureIndex | Mask-TextureIndex | Alpha Value
			
			"mov vt2, vc[vt1.x]		\n" + // set textureIndex alpha multipliers
			"sub vt2, vt2, vt1.wwww \n" + // substract inverted alpha from textureIndex alpha
			"max vt2, vt2, vc16.z	\n" + // clamp above 0 // NEED TO SWITCH TO vc16
			"min vt2, vt2, vc16.w	\n" + // clamp below 1 // NEED TO SWITCH TO vc16
			"mov v2, vt2			\n" + // copy RGB-TextureIndex with alpha multipliers into v2
			
			"add vt1.x, vt1.x, vc16.x	\n" + // Add offset (8) to index
			"mov vt3, vc[vt1.x]			\n" + // set textureIndex alpha multipliers
			"sub vt3, vt3, vt1.wwww 	\n" + // substract inverted alpha from textureIndex alpha
			"max vt3, vt3, vc16.z		\n" + // clamp above 0 // NEED TO SWITCH TO vc16
			"min vt3, vt3, vc16.w		\n" + // clamp below 1 // NEED TO SWITCH TO vc16
			"mov v3, vt3				\n" + // copy RGB-TextureIndex with alpha multipliers into v2
			
			"mov v7.xyzw, va2.zyxw	\n"	+ // copy tint colour data and flip Red and Blue
			
			"mov vt4, vc[vt1.y]		\n" + // set mask textureIndex alpha multipliers
			"mov v4, vt4			\n"	+ // 
			
			"add vt1.y, vt1.y, vc16.x	\n" + // Add offset (8) to index
			"mov vt5, vc[vt1.y]		\n" + // set mask textureIndex alpha multipliers
			"mov v5, vt5			\n"	+ // 
			
			"mov v6.xyzw, vt1.zzzz	";// copy maskBaseValue into v6
		
		return agal;
	}
	
}

typedef AgalAlias =
{
	value:String,
	alias:String
}