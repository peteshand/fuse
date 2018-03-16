package fuse.render.shaders;
import mantle.notifier.Notifier;
import openfl.Lib;
import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Program3D;
import openfl.geom.Vector3D;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class FShader
{
	static var textureChannelData:Vector<Float>;
	static var posData:Vector<Float>;
	static var cameraData:Vector<Float>;
	static var fragmentData:Vector<Float>;
	
	static var agalMiniAssembler:AGALMiniAssembler;
	static var rgbaIndex:Array<String>;
	static var maskIndex:Array<String>;
	
	var context3D:Context3D;
	var numTextures:Int;
	var program:Program3D;
	var vertexCode:ByteArray;
	var fragmentCode:ByteArray;
	var setProgram = new Notifier<Bool>();
	
	public static function __init__():Void
	{
		
		// FRAGMENT
		fragmentData = Vector.ofArray([0, 255, 1.0, 2.0]);
		
		// VERTEX
		posData = Vector.ofArray([8.0, 0.0, 0.0, 1.0]);
		cameraData = Vector.ofArray([0.0, 0.0, 0.0, 0.0]);
		
		textureChannelData = Vector.ofArray(
		[
			1.0, 0.0, 0.0, 0.0,		0.0, 1.0, 0.0, 0.0,		0.0, 0.0, 1.0, 0.0,		0.0, 0.0, 0.0, 1.0,
			0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,		0.0, 0.0, 0.0, 0.0,
			1.0, 0.0, 0.0, 0.0,		0.0, 1.0, 0.0, 0.0,		0.0, 0.0, 1.0, 0.0,		0.0, 0.0, 0.0, 1.0
		]);
		
		FShader.agalMiniAssembler = new AGALMiniAssembler();
		
		rgbaIndex = ["v2.xxxx", "v2.yyyy", "v2.zzzz", "v2.wwww","v3.xxxx", "v3.yyyy", "v3.zzzz", "v3.wwww"];
		maskIndex = ["v4.x", "v4.y", "v4.z", "v4.w","v5.x", "v5.y", "v5.z", "v5.w"];
	}
	
	public function new(context3D:Context3D, numTextures:Int) 
	{
		this.context3D = context3D;
		this.numTextures = numTextures;
		
		vertexCode = agalMiniAssembler.assemble(Context3DProgramType.VERTEX, vertexString());
		fragmentCode = agalMiniAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentString());
		
		program = context3D.createProgram();
		program.upload(vertexCode, fragmentCode);
		
		setProgram.add(OnProgramConstantsChange);
	}
	
	function OnProgramConstantsChange() 
	{
		if (setProgram.value) {
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentData, 1);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, textureChannelData, 16);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 16, posData, 1);
			context3D.setProgram(program);
		}
		else {
			
		}
	}
	
	public function update() 
	{
		setProgram.value = true;
		//cameraData[0] += 0.0001;
		
		
		
		//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 17, matrix3D);
		//context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 17, cameraData, 1);
	}
	
	public function deactivate() 
	{
		setProgram.value = false;
	}
	
	function vertexString():String 
	{
		//"m44 op, va0, vc0\n"
		var agal:String = "";
		//agal += "add va0, va0, vc17			\n";// set x and y pos to vt0 + camera position
		agal += "mov vt0.zw, vc16.zw		\n"; // set z and w pos to vt0
		agal += "mov vt0.xy, va0.xy			\n"; // set x and y pos to vt0
		//agal += "add vt0.xy, vt0.xy, vc17.xy	\n"; // set x and y pos to vt0
		
		//agal += "m44 op, vt0, vc17 			\n"; // pos to clipspace
		//agal += "m44 vc0, va17, vc0 		\n"; // pos to clipspace
		agal += "mov op, vt0				\n"; // set vt0 to clipspace
		agal += "mov v1, va1				\n"; // + // copy RGB-UV && Mask-UVc
			
		agal += "mov vt1, va3				\n"; // copy RGB-TextureIndex | Mask-TextureIndex | Alpha Value
			
		agal += "mov vt2, vc[vt1.x]			\n"; // set textureIndex alpha multipliers
		agal += "sub vt2, vt2, vt1.wwww 	\n"; // substract inverted alpha from textureIndex alpha
		agal += "max vt2, vt2, vc16.z		\n"; // clamp above 0 // NEED TO SWITCH TO vc16
		agal += "min vt2, vt2, vc16.w		\n"; // clamp below 1 // NEED TO SWITCH TO vc16
		agal += "mov v2, vt2				\n"; // copy RGB-TextureIndex with alpha multipliers into v2
			
		agal += "add vt1.x, vt1.x, vc16.x	\n"; // Add offset (8) to index
		agal += "mov vt3, vc[vt1.x]			\n"; // set textureIndex alpha multipliers
		agal += "sub vt3, vt3, vt1.wwww 	\n"; // substract inverted alpha from textureIndex alpha
		agal += "max vt3, vt3, vc16.z		\n"; // clamp above 0 // NEED TO SWITCH TO vc16
		agal += "min vt3, vt3, vc16.w		\n"; // clamp below 1 // NEED TO SWITCH TO vc16
		agal += "mov v3, vt3				\n"; // copy RGB-TextureIndex with alpha multipliers into v2
			
		agal += "mov v7.xyzw, va2.zyxw		\n"; // copy tint colour data and flip Red and Blue
			
		agal += "mov vt4, vc[vt1.y]			\n"; // set mask textureIndex alpha multipliers
		agal += "mov v4, vt4				\n"; // 
			
		agal += "add vt1.y, vt1.y, vc16.x	\n"; // Add offset (8) to index
		agal += "mov vt5, vc[vt1.y]			\n"; // set mask textureIndex alpha multipliers
		agal += "mov v5, vt5				\n"; // 
			
		agal += "mov v6.xyzw, vt1.zzzz		\n";// copy maskBaseValue into v6
		
		return agal;
	}
	
	function fragmentString():String 
	{
		var alias:Array<AgalAlias> = [];
		alias.push( { alias:"ZERO.1", value:"fc0.x" } );
		alias.push( { alias:"TWO.3", value:"fc0.www" } );
		alias.push( { alias:"ONE.1", value:"fc0.z" } );
		alias.push( { alias:"ONE.3", value:"fc0.zzz" } );
		alias.push( { alias:"ONE.4", value:"fc0.zzzz" } );
		alias.push( { alias:"MASK_BASE.1", value:"v6.z" } );
		
		
		var agal:String = "\n";
			
			/////////////////////////////////////////////////////////////////
			// RGBA from 4 available textures ///////////////////////////////
			for (j in 0...numTextures) 
			{
				agal += "tex ft0, v1.xy, fs" + j + " <2d,clamp,linear>	\n";
				agal += "mul ft0.xyzw, ft0.xyzw, " + rgbaIndex[j] + "	\n";
				if (j == 0)	agal += "mov ft1, ft0						\n";
				else 		agal += "add ft1, ft1, ft0					\n";
			}
			////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////
			
			/////////////////////////////////////////////////////////////////
			// Add Colour ///////////////////////////////////////////////////
			agal += "mov ft0, v7										\n" +
			"mul ft0.w, ft0.w, ft1.w									\n" +
			"sub ft0.xyz, ONE.3, ft0.xyz								\n" +
			"mul ft0.xyz, ft0.xyz, ft0.www								\n" +
			"sub ft1.xyz, ft1.xyz, ft0.xyz								\n";
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			for (j in 0...numTextures) 
			{
				agal += "tex ft0, v1.zw, fs" + j + " <2d,clamp,linear>	\n";
				agal += "mul ft0.w, ft0.w, " + maskIndex[j] + 		"	\n";
				if (j == 0)	agal += "mov ft2, ft0						\n";
				else 		agal += "add ft2, ft2, ft0					\n";
			}
			// Multiply Alpha by Mask Value /////////////////////////////////
			
			agal += "add ft2.w, ft2.w, MASK_BASE.1					\n";
			agal += "min ft2.w, ft2.w, ONE.1						\n";
			agal += "mul ft1.xyzw, ft1.xyzw, ft2.wwww				\n";
			
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			
			agal += "mov oc0, ft1";
		
		for (i in 0...alias.length) 
		{
			agal = agal.split(alias[i].alias).join(alias[i].value);
		}
		//trace("agal = " + agal);
		return agal;
	}
}

typedef AgalAlias =
{
	value:String,
	alias:String
}