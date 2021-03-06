package fuse.core.assembler.batches.batch;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.backend.display)
class CacheBakeBatch extends BaseBatch implements IBatch {
	var startVertexIndex:Int = -1;
	var numRenderables:Int = -1;

	public function new() {
		super();
	}

	override function getTextureIndex(renderable:ICoreRenderable) {
		trace("textureId = " + renderable.coreTexture.textureData.atlasData.textureId);
		return batchTextures.getTextureIndex(renderable.coreTexture.textureData.atlasData.textureId);
	}

	override public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool {
		if (batchType != BatchType.CACHE_BAKE)
			return false;
		return super.add(renderable, renderTarget, batchType);
	}

	public function writeVertex():Bool {
		// trace("hasChanged = " + hasChanged);
		if (hasChanged == false) {
			batchData.skip = 1;
			return false;
		}

		// trace(this);

		// if (LayerBufferAssembler.STATE == LayerState.WRITE) return;

		// trace("batchId = " + batchId);

		// if (startVertexIndex == VertexWriter.VERTEX_COUNT && numRenderables == renderables.length) {
		//
		// return false;
		// }

		// trace("startVertexIndex = " + startVertexIndex);
		// trace("VertexWriter.VERTEX_COUNT = " + VertexWriter.VERTEX_COUNT);
		//
		// trace("numRenderables = " + numRenderables);
		// trace("renderables.length = " + renderables.length);

		startVertexIndex = VertexWriter.VERTEX_COUNT;
		numRenderables = renderables.length;

		setBatchProps();

		// if (startVertexIndex == VertexWriter.VERTEX_COUNT && numRenderables == renderables.length) {
		// VertexWriter.VERTEX_COUNT += (VertexData.BYTES_PER_ITEM * renderables.length);
		// return;
		// }

		for (i in 0...renderables.length) {
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			// renderables[i].writeVertex();
			writeLayerVertex(cast renderables[i]);
		}

		return true;
	}

	override function get_active():Bool {
		return hasChanged;
	}

	override function get_hasChanged():Bool {
		return true;
	}

	/*override public function updateHasChanged():Void 
		{
			hasChanged = true;
	}*/
	function writeLayerVertex(image:CoreImage) {
		if (image.displayData.visible == 0)
			return;

		// trace("objectId = " + image.objectId);

		var vertexData:IVertexData = image.vertexData;
		var coreTexture:CoreTexture = image.coreTexture;

		// if (image.updateAny == false || image.drawIndex != VertexData.OBJECT_POSITION) {

		// trace("bake to cache layer");

		vertexData.setTexture(image.textureIndex);

		if (image.mask == null)
			vertexData.setMaskTexture(-1);
		else {
			// TODO: update value to point to correct batch textureIndex
			vertexData.setMaskTexture(0);
		}

		// if (updateUVs < 5) {
		// trace([coreTexture.uvTop, coreTexture.uvBottom]);

		vertexData.setUV(0, coreTexture.uvLeft, coreTexture.uvBottom); // bottom left
		vertexData.setUV(1, coreTexture.uvLeft, coreTexture.uvTop); // top left
		vertexData.setUV(2, coreTexture.uvRight, coreTexture.uvTop); // top right
		vertexData.setUV(3, coreTexture.uvRight, coreTexture.uvBottom); // bottom right

		if (image.mask != null) {
			vertexData.setMaskUV(0, image.mask.mask.coreTexture.uvLeft, image.mask.mask.coreTexture.uvBottom); // bottom left
			vertexData.setMaskUV(1, image.mask.mask.coreTexture.uvLeft, image.mask.mask.coreTexture.uvTop); // top left
			vertexData.setMaskUV(2, image.mask.mask.coreTexture.uvRight, image.mask.mask.coreTexture.uvTop); // top right
			vertexData.setMaskUV(3, image.mask.mask.coreTexture.uvRight, image.mask.mask.coreTexture.uvBottom); // bottom right
		}

		// image.updateUVs = false;
		// }

		// if (renderTarget == -1) {
		// trace("back buffer");
		// vertexData.setRect(0, image.bottomLeft.x,	image.bottomLeft.y);
		// vertexData.setRect(1, image.topLeft.x,	image.topLeft.y);
		// vertexData.setRect(2, image.topRight.x,	image.topRight.y);
		// vertexData.setRect(3, image.bottomRight.x,image.bottomRight.y);
		// }
		// else {
		// trace("resize");
		vertexData.setRect(0, ResizeX(image.quadData.bottomLeftX), ResizeY(image.quadData.bottomLeftY));
		vertexData.setRect(1, ResizeX(image.quadData.topLeftX), ResizeY(image.quadData.topLeftY));
		vertexData.setRect(2, ResizeX(image.quadData.topRightX), ResizeY(image.quadData.topRightY));
		vertexData.setRect(3, ResizeX(image.quadData.bottomRightX), ResizeY(image.quadData.bottomRightY));
		// }
		vertexData.setColor(0, image.displayData.colorBL);
		vertexData.setColor(1, image.displayData.colorTL);
		vertexData.setColor(2, image.displayData.colorTR);
		vertexData.setColor(3, image.displayData.colorBR);

		vertexData.setAlpha(image.alpha);
		// }

		// image.updateAll = false;
		image.setUpdates(false);

		image.drawIndex = VertexData.OBJECT_POSITION;
		image.batchType = BatchType.CACHE_BAKE;
		VertexData.OBJECT_POSITION++;
		image.parentNonStatic = false;
	}

	function ResizeX(value:Float):Float {
		// return value;
		return ((value + 1) * (Fuse.current.stage.stageWidth / Fuse.MAX_TEXTURE_SIZE)) - 1;
	}

	function ResizeY(value:Float):Float {
		// return value;
		return ((value - 1) * (Fuse.current.stage.stageHeight / Fuse.MAX_TEXTURE_SIZE)) + 1;
	}
}
