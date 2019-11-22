package fuse.core.render;

import signals.Signal;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.front.texture.Textures;
import fuse.core.render.batch.BatchRenderer;
import fuse.core.render.Context3DBlendMode;
import fuse.core.render.buffers.Buffer;
import fuse.core.render.buffers.Buffers;
import fuse.core.render.shaders.FShaders;
import fuse.core.render.Context3DRenderTarget;
import fuse.core.render.Context3DTexture;
import fuse.utils.Color;
import fuse.Fuse;
import resize.Resize;
import openfl.geom.Rectangle;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3D;

/**
 * ...
 * @author P.J.Shand
 */
// @:access(fuse)
class Renderer {
	// var m:Matrix3D = new Matrix3D();
	var conductorData:WorkerConductorData;

	public var context3D:Context3D;

	var sharedContext:Bool;
	var numItemsInBatch:Int;
	var scissorRectangle:Rectangle;
	var batchRenderers:Array<BatchRenderer> = [];

	public var onPresent = new Signal();

	public function new(context3D:Context3D, sharedContext:Bool) {
		this.context3D = context3D;
		this.sharedContext = sharedContext;

		scissorRectangle = new Rectangle();

		if (!sharedContext) {
			Resize.add(resize);
			resize();
		}

		context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
		context3D.setCulling(Context3DTriangleFace.NONE);

		conductorData = new WorkerConductorData();

		Context3DRenderTarget.init(context3D);
		Context3DTexture.init(context3D);
		// Context3DProgram.init(context3D);
		// ShaderPrograms.init(context3D);
		// BatchRenderer.init(context3D);
		Textures.init(context3D);
		// FuseShaders.init();

		// trace("supports8kTexture = " + Reflect.getProperty(Context3D, "supports8kTexture"));
		// trace("supports8kTexture = " + Reflect.getProperty(context3D, "supports8kTexture"));
		// trace("supports8kTexture = " + Reflect.field(Context3D, "supports8kTexture"));
		// trace("supports8kTexture = " + Reflect.field(context3D, "supports8kTexture"));

		Context3DBlendMode.init(context3D);
		Buffers.init(context3D);
		FShaders.init(context3D);

		// ShaderPrograms.clear();
	}

	public function resize() {
		if (Fuse.current.stage == null)
			return;
		context3D.configureBackBuffer(Fuse.current.stage.windowWidth, Fuse.current.stage.windowHeight, 2, true);
		scissorRectangle.setTo(0, 0, Fuse.current.stage.windowWidth, Fuse.current.stage.windowHeight);
		// context3D.setScissorRectangle(scissorRectangle);
	}

	public function update() {
		if (context3D.driverInfo == "Disposed")
			return;
		drawBuffer();
	}

	public function begin(clear:Bool = true, clearColor:Color):Void {
		// trace("begin");
		if (!sharedContext) {
			// Doesn't execute if context3D.clear is being handled externally
			context3D.clear(clearColor.red / 255, clearColor.green / 255, clearColor.blue / 255, clearColor.alpha / 255);
		}

		// trace("conductorData.highestNumTextures = " + conductorData.highestNumTextures);
		// trace("conductorData.numberOfRenderables = " + conductorData.numberOfRenderables);

		if (conductorData.numberOfRenderables == 0)
			return;

		// Buffers.currentBuffer = Buffers.getBuffer(conductorData.numberOfRenderables);
		// Buffers.currentBuffer.update();

		Context3DRenderTarget.begin();

		if (Fuse.current.cleanContext) {
			clearBatches();
		}
	}

	function drawBuffer() {
		BatchRenderer.begin(conductorData);
		var traceOutput:Bool = false;
		// trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		// if (conductorData.numberOfBatches > 1){
		// trace("conductorData.numberOfBatches = " + conductorData.numberOfBatches);
		// traceOutput = true;
		// }

		for (i in 0...conductorData.numberOfBatches) {
			var batchRenderer:BatchRenderer = getBatchRenderer(i);
			batchRenderer.drawBuffer(i, conductorData, context3D, traceOutput);
			// BatchRenderer.drawBuffer(i, conductorData, context3D, traceOutput);
		}
		// if (traceOutput){
		// trace("-------------------");
		// }
	}

	function getBatchRenderer(index:Int) {
		if (batchRenderers.length <= index) {
			batchRenderers[index] = new BatchRenderer(index, context3D);
		}
		return batchRenderers[index];
	}

	public function end():Void {
		if (Fuse.current.cleanContext) {
			Context3DTexture.clear();
			// ShaderPrograms.clear();
			// Context3DProgram.clear();
			// BatchRenderer.clear();
			clearBatches();

			Context3DRenderTarget.clear();

			Buffers.deactivate();
			FShaders.deactivate();
		}

		if (!sharedContext) {
			// Doesn't execute if context3D.present is being handled externally
			context3D.present();
			onPresent.dispatch();
		}
	}

	function clearBatches() {
		for (i in 0...batchRenderers.length) {
			batchRenderers[i].clear();
		}
	}
}
