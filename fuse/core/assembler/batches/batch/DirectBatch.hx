package fuse.core.assembler.batches.batch;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.display.CoreMask;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.render.shaders.FShader;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.backend.display)
class DirectBatch extends BaseBatch implements IBatch
{
	var uvItem:UVItem;
	var renderIndices = new GcoArray<CoreImage>();
	var numItems:Int;
	public static var RENDER_INDEX:Int;
	
	public function new() 
	{
		super();
		uvItem = {
			uvLeft:0,
			uvTop:0,
			uvRight:0,
			uvBottom:0,

			offsetU:0,
			offsetV:0,
			scaleU:1,
			scaleV:1
		}
	}
	
	override function getTextureIndex(renderable:ICoreRenderable) 
	{
		if (renderable.coreTexture == null || renderable.coreTexture.textureData.textureAvailable != 1) {
			return batchTextures.getTextureIndex(0);
		}
		else {
			return batchTextures.getTextureIndex(renderable.coreTexture.textureData.atlasData.textureId);
		}
	}
	
	override public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool
	{
		if (batchType != BatchType.DIRECT) return false;
		return super.add(renderable, renderTarget, batchType);
	}
	
	public function writeVertex():Bool
	{
		//trace("hasChanged = " + hasChanged);
		setBatchProps();
		
		numItems = 0;
		
		
		//trace("renderables.length = " + renderables.length);
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			writeLayerVertex(cast renderables[i]);
		}
		
		batchData.numItems = numItems;
		
		return true;
	}
	
	function writeLayerVertex(image:CoreImage)
	{
		image.renderIndex = RENDER_INDEX++;
		
		if (!image.visible || image.alpha == 0 || image.isMask || image.coreTexture == null) {
			image.setUpdates(false);
			image.drawIndex = -1;
			return;
		}
		//if (image.displayData.visible == 0) return;
		
		var mask:CoreMask = image.mask;

		var vertexData:IVertexData = image.vertexData;
		var coreTexture:CoreTexture = image.coreTexture;
		
		
		//var vertexPositionHasMoved:Bool = false;
		if (renderIndices[VertexData.OBJECT_POSITION] != image) {
			if (renderIndices[VertexData.OBJECT_POSITION] != null) {
				renderIndices[VertexData.OBJECT_POSITION].drawIndex = -1;
			}
			renderIndices[VertexData.OBJECT_POSITION] = image;
			//vertexPositionHasMoved = true;
		}
		
		var batchTypeHasChanged:Bool = image.batchType != BatchType.DIRECT;
		var vertexPositionHasMoved:Bool = (image.drawIndex != VertexData.OBJECT_POSITION) || batchTypeHasChanged;
		
		var updateTextureUVs:Bool = vertexPositionHasMoved || coreTexture.uvsHaveChanged;
		var updateImageUVs:Bool = vertexPositionHasMoved || image.updateUVs;
		var updatePosition:Bool	= vertexPositionHasMoved || image.updatePosition;
		var updateTexture:Bool	= vertexPositionHasMoved || image.updateTexture;// || image.textureChanged;
		var updateMask:Bool		= vertexPositionHasMoved || image.maskChanged;
		var updateColour:Bool	= vertexPositionHasMoved || image.updateColour;
		var updateAlpha:Bool	= vertexPositionHasMoved || image.updateAlpha;
		
		if (mask != null) {
			updateAlpha = updateAlpha || mask.mask.updateAlpha;
		}

		//if (VertexData.OBJECT_POSITION < 10){
			//trace([
				//"\n updateTextureUVs = " + updateTextureUVs,
				//"\n updatePosition = " + updatePosition,
				//"\n updateTexture = " + updateTexture,
				//"\n updateMask = " + updateMask,
				//"\n updateColour = " + updateColour,
				//"\n updateAlpha = " + updateAlpha,
				//"\n image.updatePosition = " + image.updatePosition,
				//"\n image.updateAny = " + image.updateAny,
				//"\n image.drawIndex = " + image.drawIndex,
				//"\n VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION
			//]);
		//}
		//image.textureChanged = false;
		image.maskChanged = false;
		
		if (updateTexture){ // currently issues when texture index order changes
			vertexData.setTexture(image.textureIndex);
		}
		
		if (FShader.ENABLE_MASKS) {
			//if (updateMask){
				if (mask != null) {
					vertexData.setMaskTexture(mask.mask.textureIndex);
					//trace("setBatchProps mask: " + image.objectId);
				}
				else {
					vertexData.setMaskTexture(-1);
				}
			//}
		}

		if (updateTextureUVs || updateImageUVs) {
			
			uvItem.offsetU = image.displayData.offsetU;
			uvItem.offsetV = image.displayData.offsetV;
			uvItem.scaleU = image.displayData.scaleU;
			uvItem.scaleV = image.displayData.scaleV;
			
			coreTexture.getUVData(uvItem);

			vertexData.setUV(0, uvItem.uvLeft,	uvItem.uvBottom);	// bottom left
			vertexData.setUV(1, uvItem.uvLeft,	uvItem.uvTop);		// top left
			vertexData.setUV(2, uvItem.uvRight,	uvItem.uvTop);		// top right
			vertexData.setUV(3, uvItem.uvRight,	uvItem.uvBottom);	// bottom right
			
		}
		
		
		if (FShader.ENABLE_MASKS && mask != null) {
			
			mask.updateUVs();
			vertexData.setMaskUV(0, mask.uvs[0].x, mask.uvs[0].y);	// bottom left
			vertexData.setMaskUV(1, mask.uvs[1].x, mask.uvs[1].y);	// top left
			vertexData.setMaskUV(2, mask.uvs[2].x, mask.uvs[2].y);	// top right
			vertexData.setMaskUV(3, mask.uvs[3].x, mask.uvs[3].y);	// bottom right
		}
		
		if (updatePosition) {

			if (coreTexture.rotate) {
				vertexData.setRect(0, 	image.quadData.topLeftX,		image.quadData.topLeftY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(1, 	image.quadData.topRightX,		image.quadData.topRightY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(2,	image.quadData.bottomRightX,	image.quadData.bottomRightY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(3, 	image.quadData.bottomLeftX,		image.quadData.bottomLeftY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				
			} else {
				vertexData.setRect(0, 	image.quadData.bottomLeftX,		image.quadData.bottomLeftY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(1, 	image.quadData.topLeftX,		image.quadData.topLeftY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(2, 	image.quadData.topRightX,		image.quadData.topRightY, image.displayData.width, image.displayData.height, image.absoluteRotation());
				vertexData.setRect(3,	image.quadData.bottomRightX,	image.quadData.bottomRightY, image.displayData.width, image.displayData.height, image.absoluteRotation());
			}
		}
		
		if (updateColour){
			vertexData.setColor(0, image.displayData.colorBL);
			vertexData.setColor(1, image.displayData.colorTL);
			vertexData.setColor(2, image.displayData.colorTR);
			vertexData.setColor(3, image.displayData.colorBR);
		}
		if (updateAlpha){
			var alpha:Float = image.alpha;
			//if (mask != null) alpha *= mask.alpha;
			vertexData.setAlpha(alpha);
		}
		
		image.setUpdates(false);
		
		image.drawIndex = VertexData.OBJECT_POSITION;
		image.batchType = BatchType.DIRECT;
		VertexData.OBJECT_POSITION++;
		image.parentNonStatic = false;
		
		numItems++;
		//trace([image.isRotating, image.isMoving, image.isStatic]);
	}
}