package fuse.render.shaders;

import fuse.shader.BaseShader;
import fuse.shader.ColorTransformShader;
import fuse.shader.IShader;
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
 @:access(fuse.shader.BaseShader)
class FShader
{
	public static inline var ENABLE_MASKS:Bool = true;
	
	static var textureChannelData:Vector<Float>;
	static var posData:Vector<Float>;
	static var cameraData:Vector<Float>;
	//static var colorTransform:Vector<Float>;
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
	public var shaderId:Int = 0;
	static var shaders:Array<IShader> = [];

	public static function init():Void
	{
		//colorTransform = new ColorTransformShader(1, 0, 0);
		// FRAGMENT
		fragmentData = Vector.ofArray([0, 255, 1.0, -1.0]);
		//colorTransform = Vector.ofArray([1.0, 0.0, 0.0, 1.0, 0.0, 0.25, 0.25, 0.0]);
		
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
	
	public function new(context3D:Context3D, numTextures:Int, shaderId:Int) 
	{
		this.context3D = context3D;
		this.numTextures = numTextures;
		this.shaderId = shaderId;

		shaders = BaseShader.getShaders(shaderId);
		createAndUploadShaderProgram();
	}

	function createAndUploadShaderProgram()
	{
		//if (program != null) return;
		program = context3D.createProgram();
		vertexCode = agalMiniAssembler.assemble(Context3DProgramType.VERTEX, vertexString());
		fragmentCode = agalMiniAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentString());
		program.upload(vertexCode, fragmentCode);
		setProgram.add(OnProgramConstantsChange);
		OnProgramConstantsChange();
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
	
	public function update(move:Bool=false) 
	{
		setProgram.value = true;
		//trace("Fuse.current.conductorData.backIsStatic: " + Fuse.current.conductorData.backIsStatic);
		//if (Fuse.current.conductorData.backIsStatic == 0){
			if (Fuse.current.stage.camera.hasUpdate){
				if (move) {
					cameraData[0] = -Fuse.current.stage.camera.x / (Lib.current.stage.stageWidth / 2);
					cameraData[1] = Fuse.current.stage.camera.y / (Lib.current.stage.stageHeight / 2);
				}
				else {
					cameraData[0] = 0;
					cameraData[1] = 0;
				}
				//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 17, matrix3D);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 17, cameraData, 1);
				
				
				Fuse.current.stage.camera.hasUpdate = false;
			}
			//colorTransform = BaseShader.map.get(1);
			//trace("shaderId = " + shaderId);
			

			for (i in 0...shaders.length) {
				shaders[i].activate(context3D);
			}
			//trace("1 colorTransform = " + colorTransform);
			//if (colorTransform != null) colorTransform.activate(context3D);
			//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, colorTransform, 2);
		//}
	}
	
	public function deactivate() 
	{
		setProgram.value = false;
	}
	
	function vertexString():String 
	{
		var alias:Array<AgalAlias> = [];
		alias.push( { value:"va0.x", alias:"INDEX_X" } );
		alias.push( { value:"va0.y", alias:"INDEX_Y" } );
		
		alias.push( { value:"va1.x", alias:"INDEX_TEXTURE" } );
		alias.push( { value:"va1.y", alias:"INDEX_ALPHA" } );
		alias.push( { value:"va1.zzzz", alias:"INDEX_U" } );
		alias.push( { value:"va1.w", alias:"INDEX_V" } );
		
		alias.push( { value:"va2.zyxw", alias:"INDEX_COLOR" } );
		
		alias.push( { value:"va3.x", alias:"INDEX_MU" } );
		alias.push( { value:"va3.y", alias:"INDEX_MV" } );
		alias.push( { value:"va3.z", alias:"INDEX_MASK_TEXTURE" } );
		alias.push( { value:"va3.w", alias:"INDEX_MASK_BASE_VALUE" } );
		
		alias.push( { value:"vc17", alias:"CAMERA_POSITION" } );
		
		var agal:String = "";
		agal += "mov vt0.zw, vc16.zw				\n"; // set z and w pos to vt0
		agal += "mov vt0.x, INDEX_X					\n"; // set x and y pos to vt0
		agal += "mov vt0.y, INDEX_Y					\n"; // set x and y pos to vt0
		
		agal += "add vt0.x, vt0.x, CAMERA_POSITION.x	\n"; // set x and y pos to vt0
		agal += "add vt0.y, vt0.y, CAMERA_POSITION.y	\n"; // set x and y pos to vt0
		
		agal += "mov op, vt0						\n"; // set vt0 to clipspace
		
		agal += "mov v1.xyzw, INDEX_U				\n";
		agal += "mov v1.y, INDEX_V					\n";
		agal += "mov vt1.x, INDEX_TEXTURE			\n";
		agal += "mov vt1.w, INDEX_ALPHA				\n";
		
		agal += "mov vt2, vc[vt1.x]					\n"; // set textureIndex alpha multipliers
		agal += "sub vt2, vt2, vt1.wwww 			\n"; // substract inverted alpha from textureIndex alpha
		agal += "max vt2, vt2, vc16.z				\n"; // clamp above 0 // NEED TO SWITCH TO vc16
		agal += "min vt2, vt2, vc16.w				\n"; // clamp below 1 // NEED TO SWITCH TO vc16
		agal += "mov v2, vt2						\n"; // copy RGB-TextureIndex with alpha multipliers into v2
		
		agal += "add vt1.x, vt1.x, vc16.x			\n"; // Add offset (8) to index
		agal += "mov vt3, vc[vt1.x]					\n"; // set textureIndex alpha multipliers
		agal += "sub vt3, vt3, vt1.wwww 			\n"; // substract inverted alpha from textureIndex alpha
		agal += "max vt3, vt3, vc16.z				\n"; // clamp above 0 // NEED TO SWITCH TO vc16
		agal += "min vt3, vt3, vc16.w				\n"; // clamp below 1 // NEED TO SWITCH TO vc16
		agal += "mov v3, vt3						\n"; // copy RGB-TextureIndex with alpha multipliers into v2
			
		agal += "mov v7.xyzw, INDEX_COLOR			\n"; // copy tint colour data and flip Red and Blue
		
		if (FShader.ENABLE_MASKS){
		// Mask stuff
			agal += "mov v1.z, INDEX_MU					\n";
			agal += "mov v1.w, INDEX_MV					\n";
			
			agal += "mov vt1.y, INDEX_MASK_TEXTURE		\n";
			agal += "mov vt1.z, INDEX_MASK_BASE_VALUE	\n";
			
			agal += "mov vt4, vc[vt1.y]					\n"; // set mask textureIndex alpha multipliers
			agal += "mov v4, vt4						\n"; // 
				
			agal += "add vt1.y, vt1.y, vc16.x			\n"; // Add offset (8) to index
			agal += "mov vt5, vc[vt1.y]					\n"; // set mask textureIndex alpha multipliers
			agal += "mov v5, vt5						\n"; // 
				
			agal += "mov v6.xyzw, vt1.zzzz				\n";// copy maskBaseValue into v6
		}
		
		for (i in 0...alias.length) 
		{
			agal = agal.split(alias[i].alias).join(alias[i].value);
		}
		
		return agal;
	}
	
	function fragmentString():String 
	{
		var alias:Array<AgalAlias> = [];
		alias.push( { alias:"ZERO.1", value:"fc0.x" } );
		alias.push( { alias:"ZERO.4", value:"fc0.xxxx" } );
		alias.push( { alias:"ONE.1", value:"fc0.z" } );
		alias.push( { alias:"ONE.3", value:"fc0.zzz" } );
		alias.push( { alias:"ONE.4", value:"fc0.zzzz" } );
		alias.push( { alias:"NEG_ONE.4", value:"fc0.wwwww" } );
		alias.push( { alias:"MASK_BASE.1", value:"v6.z" } );
		alias.push( { alias:"COLOR_TRANSFORM_MULTIPLIER", value:"fc1" } );
		alias.push( { alias:"COLOR_TRANSFORM_OFFSET", value:"fc2" } );
		
		
		var agal:String = "\n";
			
			/////////////////////////////////////////////////////////////////
			// RGBA from 4 available textures ///////////////////////////////
			for (j in 0...numTextures) 
			{
				agal += "tex ft0, v1.xy, fs" + j + " <2d,clamp,linear>	\n"; // nearest
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
			// Mark from 4 available textures ///////////////////////////////
			if (FShader.ENABLE_MASKS){
				for (j in 0...numTextures) 
				{
					agal += "tex ft0, v1.zw, fs" + j + " <2d,clamp,linear>	\n"; // nearest
					agal += "mul ft0.w, ft0.w, " + maskIndex[j] + 		"	\n";
					if (j == 0)	agal += "mov ft2, ft0						\n";
					else 		agal += "add ft2, ft2, ft0					\n";
				}
				// Multiply Alpha by Mask Value /////////////////////////////////
				
				agal += "add ft2.w, ft2.w, MASK_BASE.1						\n";
				agal += "min ft2.w, ft2.w, ONE.1							\n";
				agal += "mul ft1.xyzw, ft1.xyzw, ft2.wwww					\n";
			}
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			
			//agal += "mul ft1, ft1, COLOR_TRANSFORM_MULTIPLIER				\n";
			
			//agal += "min ft1, ft1, ONE.4									\n";
			//agal += "min ft1, NEG_ONE.4, ft1								\n";

			//agal += "add ft1, ft1, COLOR_TRANSFORM_OFFSET					\n";
			
			//trace("2 colorTransform = " + colorTransform);
			//if (colorTransform != null) agal += colorTransform.fragmentString();
			for (i in 0...shaders.length) {
				agal += shaders[i].fragmentString();
			}

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