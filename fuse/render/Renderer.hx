package fuse.render;

import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.front.texture.Textures;
import fuse.render.buffers.Buffer;
import fuse.render.buffers.Buffers;
import fuse.render.shaders.FShaders;
import fuse.utils.Color;
import fuse.Fuse;
import mantle.managers.resize.Resize;
import openfl.geom.Rectangle;

import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
//@:access(fuse)
class Renderer
{
	//var m:Matrix3D = new Matrix3D();
	var conductorData:WorkerConductorData;
	var context3D:Context3D;
	var sharedContext:Bool;
	var numItemsInBatch:Int;
	var scissorRectangle:Rectangle;
	
	public function new(context3D:Context3D, sharedContext:Bool) 
	{
		this.context3D = context3D;
		this.sharedContext = sharedContext;
		
		scissorRectangle = new Rectangle();
		
		if (!sharedContext){
			Resize.add(OnResize);
			OnResize();
		}
		
		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		context3D.setCulling(Context3DTriangleFace.BACK);
		
		conductorData = new WorkerConductorData();
		
		Context3DRenderTarget.init(context3D);
		Context3DTexture.init(context3D);
		//Context3DProgram.init(context3D);
		//ShaderPrograms.init(context3D);
		BatchRenderer.init(context3D);
		Textures.init(context3D);
		//FuseShaders.init();
		
		//trace("supports8kTexture = " + Reflect.getProperty(Context3D, "supports8kTexture"));
		//trace("supports8kTexture = " + Reflect.getProperty(context3D, "supports8kTexture"));
		//trace("supports8kTexture = " + Reflect.field(Context3D, "supports8kTexture"));
		//trace("supports8kTexture = " + Reflect.field(context3D, "supports8kTexture"));
		
		Buffers.init(context3D);
		FShaders.init(context3D);
		
		//ShaderPrograms.clear();
	}
	
	function OnResize() 
	{
		context3D.configureBackBuffer(Fuse.current.stage.stageWidth, Fuse.current.stage.stageHeight, 0, false);
		scissorRectangle.setTo(0, 0, Fuse.current.stage.stageWidth, Fuse.current.stage.stageHeight);
		//context3D.setScissorRectangle(scissorRectangle);
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
		
		//trace("conductorData.highestNumTextures = " + conductorData.highestNumTextures);
		//trace("conductorData.numberOfRenderables = " + conductorData.numberOfRenderables);
		
		if (conductorData.numberOfRenderables == 0) return;
		
		Buffers.currentBuffer = Buffers.getBuffer(conductorData.numberOfRenderables);
		Buffers.currentBuffer.update();
		
		Context3DRenderTarget.begin();
		
		if (Fuse.current.cleanContext) {
			BatchRenderer.clear();
		}
	}
	
	function drawBuffer() 
	{
		BatchRenderer.begin(conductorData);
		var traceOutput:Bool = false;
		if (conductorData.numberOfBatches > 1){
			//trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
			//traceOutput = true;
		}
		
		for (i in 0...conductorData.numberOfBatches) 
		{
			BatchRenderer.drawBuffer(i, conductorData, context3D, traceOutput);
		}
		//if (traceOutput){
			//trace("-------------------");
		//}
	}
	
	public function end():Void
	{
		if (Fuse.current.cleanContext) {
			Context3DTexture.clear();
			//ShaderPrograms.clear();
			//Context3DProgram.clear();
			BatchRenderer.clear();
			Context3DRenderTarget.clear();
			
			Buffers.deactivate();
			FShaders.deactivate();
		}
		
		if (!sharedContext) {
			// Doesn't execute if context3D.present is being handled externally
			context3D.present();
		}
	}
}