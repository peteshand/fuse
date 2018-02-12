package fuse.render;

import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.front.texture.Textures;
import fuse.render.program.Context3DProgram;
import fuse.render.program.ShaderPrograms;
import fuse.render.shader.FuseShaders;
import fuse.utils.Color;
import fuse.Fuse;

import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class Renderer
{
	//var m:Matrix3D = new Matrix3D();
	var conductorData:WorkerConductorData;
	var context3D:Context3D;
	var sharedContext:Bool;
	var numItemsInBatch:Int;
	
	public function new(context3D:Context3D, sharedContext:Bool) 
	{
		this.context3D = context3D;
		this.sharedContext = sharedContext;
		
		if (!sharedContext){
			context3D.configureBackBuffer(Fuse.current.stage.stageWidth, Fuse.current.stage.stageHeight, 0, false);
		}
		
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		//context3D.setScissorRectangle(new Rectangle(0, 0, 1600, 900));
		context3D.setCulling(Context3DTriangleFace.BACK);
		
		conductorData = new WorkerConductorData();
		
		Context3DRenderTarget.init(context3D);
		Context3DTexture.init(context3D);
		Context3DProgram.init(context3D);
		ShaderPrograms.init(context3D);
		BatchRenderer.init(context3D);
		Textures.init(context3D);
		FuseShaders.init();
	}
	
	public function update() 
	{
		begin(true, Fuse.current.stage.color);
		drawBuffer();
		end();
	}
	
	public function begin(clear:Bool = true, clearColor:Color):Void
	{
		if (!sharedContext) {
			// Doesn't execute if context3D.clear is being handled externally
			context3D.clear(clearColor.red / 255, clearColor.green / 255, clearColor.blue / 255, 1);
		}
		
		Context3DRenderTarget.begin();
		
		if (Fuse.current.cleanContext) {
			BatchRenderer.clear();
		}
	}
	
	function drawBuffer() 
	{
		BatchRenderer.begin(conductorData);
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			BatchRenderer.drawBuffer(i, conductorData, context3D);
		}
	}
	
	public function end():Void
	{
		if (Fuse.current.cleanContext) {
			Context3DTexture.clear();
			ShaderPrograms.clear();
			Context3DProgram.clear();
			BatchRenderer.clear();
			Context3DRenderTarget.clear();
		}
		
		if (!sharedContext) {
			// Doesn't execute if context3D.present is being handled externally
			context3D.present();
		}
	}
}