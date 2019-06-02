package fuse.core.assembler.batches.batch;

import fuse.core.assembler.layers.layer.LayerBuffer.RenderablesData;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class BaseBatch {
	var batchTextures:BatchTextures;

	public var batchData:IBatchData;
	public var index:Int = -1;

	var renderablesData = new RenderablesData();

	public var renderables(get, null):GcoArray<ICoreRenderable>;
	// public var renderables:GcoArray<ICoreRenderable>;
	// public var lastRenderables:GcoArray<ICoreRenderable>;
	public var renderTarget:Null<Int>;
	public var blendMode:Null<Int> = null;
	public var shaderId:Null<Int> = null;
	public var active(get, null):Bool;

	static var count:Int = 0;

	var batchId:Int;

	// true if the order of renderables or which renderables are included in the batch have changed
	// public var hasChanged:Bool = false;
	public var hasChanged(get, null):Bool;

	public function new() {
		batchId = count++;
		batchTextures = new BatchTextures();
		// renderables = new GcoArray<ICoreRenderable>([]);
		// lastRenderables = new GcoArray<ICoreRenderable>([]);
	}

	public function init(index:Int):Void {
		renderTarget = null;
		renderables.clear();
		batchTextures.clear();
		this.nextFrame();
		if (this.index == index)
			return;

		this.index = index;
		batchData = CommsObjGen.getBatchData(index);
	}

	public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool {
		// trace("renderTarget = " + renderTarget);
		var textureIndex:Int = getTextureIndex(renderable);

		if (textureIndex == -1)
			return false;
		renderable.textureIndex = textureIndex;

		if (blendMode != null && blendMode != renderable.blendMode)
			return false;
		blendMode = renderable.blendMode;

		if (shaderId != null && shaderId != renderable.shaderId)
			return false;
		shaderId = renderable.shaderId;

		if (renderTargetChanged(renderTarget))
			return false;

		renderables.push(renderable);
		return true;
	}

	function getTextureIndex(renderable:ICoreRenderable) {
		return batchTextures.getTextureIndex(renderable.sourceTextureId);
	}

	function renderTargetChanged(renderTarget:Int) {
		if (this.renderTarget == renderTarget)
			return false;
		if (this.renderTarget != null)
			return true;
		this.renderTarget = renderTarget;
		return false;
	}

	inline function setBatchProps() {
		// batchData.clearRenderTarget =						// Currently not set anywhere
		// batchData.height = 								// Not sure if this is needed
		// batchData.length = 								// Not sure if this is needed

		// trace("renderTarget = " + renderTarget);

		batchData.skip = 0;

		batchData.numItems = renderables.length;
		batchData.numTextures = batchTextures.textureIds.length;
		batchData.renderTargetId = renderTarget;
		batchData.startIndex = VertexWriter.VERTEX_COUNT;

		// trace("batchTextures.textureIds = " + batchTextures.textureIds);

		batchData.blendMode = blendMode;
		batchData.shaderId = shaderId;

		batchData.textureId1 = batchTextures.textureId1;
		batchData.textureId2 = batchTextures.textureId2;
		batchData.textureId3 = batchTextures.textureId3;
		batchData.textureId4 = batchTextures.textureId4;
		batchData.textureId5 = batchTextures.textureId5;
		batchData.textureId6 = batchTextures.textureId6;
		batchData.textureId7 = batchTextures.textureId7;
		batchData.textureId8 = batchTextures.textureId8;
		// batchData.width = 								// Not sure if this is needed
	}

	public function toString():String {
		return Type.getClassName(Type.getClass(this)) + "\nindex = " + index + "\nrenderTarget = " + renderTarget + " \nbatchTextures = " + batchTextures
			+ " \nnumItems = " + renderables.length;
	}

	/*public function updateHasChanged():Void 
		{

			hasChanged = false;
			if (lastRenderables.length != renderables.length) {
				hasChanged = true;
			}
			else {
				for (i in 0...renderables.length)
				{
					if (renderables[i] != lastRenderables[i]) {
						hasChanged = true;
						break;
					}
				}
			}
			lastRenderables.clear();
			for (i in 0...renderables.length)
			{
				lastRenderables.push(renderables[i]);
			}
	}*/
	public function nextFrame():Void {
		renderablesData.nextFrame();
	}

	function get_hasChanged():Bool {
		return renderablesData.hasChanged;
	}

	function get_renderables():GcoArray<ICoreRenderable> {
		return renderablesData.renderables;
	}

	function get_active():Bool {
		return true;
	}
}
