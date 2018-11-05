package fuse.core.assembler.batches.batch;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
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
	var renderIndices = new GcoArray<CoreImage>();
	var numItems:Int;
	public static var RENDER_INDEX:Int;
	
	public function new() 
	{
		super();
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
		
		var updateUVs:Bool		= vertexPositionHasMoved || coreTexture.uvsHaveChanged;
		var updatePosition:Bool	= vertexPositionHasMoved || image.updatePosition;
		var updateTexture:Bool	= vertexPositionHasMoved || image.updateTexture;// || image.textureChanged;
		var updateMask:Bool		= vertexPositionHasMoved || image.maskChanged;
		var updateColour:Bool	= vertexPositionHasMoved || image.updateColour;
		var updateAlpha:Bool	= vertexPositionHasMoved || image.updateAlpha;
		
		//if (VertexData.OBJECT_POSITION < 10){
			//trace([
				//"\n updateUVs = " + updateUVs,
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
			if (updateMask){
				if (image.mask != null) {
					vertexData.setMaskTexture(image.mask.textureIndex);
					//trace("setBatchProps mask: " + image.objectId);
				}
				else {
					vertexData.setMaskTexture(-1);
				}
			}
		}
		if (updateUVs) {
			//trace([coreTexture.uvTop, coreTexture.uvBottom]);
			//trace("updateUVs = " + updateUVs + " objectId = " + coreTexture.objectId);
			vertexData.setUV(0, coreTexture.uvLeft,		coreTexture.uvBottom);	// bottom left
			vertexData.setUV(1, coreTexture.uvLeft,		coreTexture.uvTop);		// top left
			vertexData.setUV(2, coreTexture.uvRight,	coreTexture.uvTop);		// top right
			vertexData.setUV(3, coreTexture.uvRight,	coreTexture.uvBottom);	// bottom right
			//image.updateUVs = false;
		}
		
		if (FShader.ENABLE_MASKS && image.mask != null) {
			
			//trace(image.mask.quadData);
			//trace(image.quadData);
			var offsetBottomLeftX:Float = calcOffsetX(image.mask.quadData.bottomLeftX, image.quadData.bottomLeftX, image);
			var offsetBottomLeftY:Float = calcOffsetY(image.quadData.bottomLeftY, image.mask.quadData.bottomLeftY, image);
			var offsetTopLeftX:Float = calcOffsetX(image.mask.quadData.topLeftX, image.quadData.topLeftX, image);
			var offsetTopLeftY:Float = calcOffsetY(image.quadData.topLeftY, image.mask.quadData.topLeftY, image);
			var offsetTopRightX:Float = calcOffsetX(image.mask.quadData.topRightX, image.quadData.topRightX, image);
			var offsetTopRightY:Float = calcOffsetY(image.quadData.topRightY, image.mask.quadData.topRightY, image);
			var offsetBottomRightX:Float = calcOffsetX(image.mask.quadData.bottomRightX, image.quadData.bottomRightX, image);
			var offsetBottomRightY:Float = calcOffsetY(image.quadData.bottomRightY, image.mask.quadData.bottomRightY, image);
			
			var rot = image.mask.displayData.rotation / 180 * Math.PI;
			var offsetBottomLeftX2:Float = (offsetBottomLeftX * -Math.cos(rot)) + (offsetBottomLeftY * Math.sin(rot));
			var offsetBottomLeftY2:Float = (offsetBottomLeftX * Math.sin(rot)) + (offsetBottomLeftY * Math.cos(rot));
			var offsetTopLeftX2:Float = (offsetTopLeftX * -Math.cos(rot)) + (offsetTopLeftY * Math.sin(rot));
			var offsetTopLeftY2:Float =  (offsetTopLeftX * Math.sin(rot)) + (offsetTopLeftY * Math.cos(rot));
			var offsetTopRightX2:Float = (offsetTopRightX * -Math.cos(rot)) + (offsetTopRightY * Math.sin(rot));
			var offsetTopRightY2:Float =  (offsetTopRightX * Math.sin(rot)) + (offsetTopRightY * Math.cos(rot));
			var offsetBottomRightX2:Float = (offsetBottomRightX * -Math.cos(rot)) + (offsetBottomRightY * Math.sin(rot));
			var offsetBottomRightY2:Float =  (offsetBottomRightX * Math.sin(rot)) + (offsetBottomRightY * Math.cos(rot));
			
			//trace([image.mask.coreTexture.uvLeft - offsetBottomLeftX2,	image.mask.coreTexture.uvBottom - offsetBottomLeftY2]);
			//trace([image.mask.coreTexture.uvLeft - offsetTopLeftX2,	image.mask.coreTexture.uvTop - offsetTopLeftY2]);
			//trace([image.mask.coreTexture.uvRight - offsetTopRightX2, image.mask.coreTexture.uvTop - offsetTopRightY2]);
			//trace([image.mask.coreTexture.uvRight - offsetBottomRightX2, image.mask.coreTexture.uvBottom - offsetBottomRightY2]);
			
			vertexData.setMaskUV(0, image.mask.coreTexture.uvLeft - offsetBottomLeftX2,	image.mask.coreTexture.uvBottom - offsetBottomLeftY2);	// bottom left
			vertexData.setMaskUV(1, image.mask.coreTexture.uvLeft - offsetTopLeftX2,	image.mask.coreTexture.uvTop - offsetTopLeftY2);	// top left
			vertexData.setMaskUV(2, image.mask.coreTexture.uvRight - offsetTopRightX2, image.mask.coreTexture.uvTop - offsetTopRightY2);	// top right
			vertexData.setMaskUV(3, image.mask.coreTexture.uvRight - offsetBottomRightX2, image.mask.coreTexture.uvBottom - offsetBottomRightY2);	// bottom right
		}
		
		if (updatePosition) {

			if (coreTexture.rotate) {
				vertexData.setXY(0, 	image.quadData.topLeftX,		image.quadData.topLeftY);
				vertexData.setXY(1, 	image.quadData.topRightX,		image.quadData.topRightY);
				vertexData.setXY(2,		image.quadData.bottomRightX,	image.quadData.bottomRightY);
				vertexData.setXY(3, 	image.quadData.bottomLeftX,		image.quadData.bottomLeftY);
				
			} else {
				vertexData.setXY(0, 	image.quadData.bottomLeftX,		image.quadData.bottomLeftY);
				vertexData.setXY(1, 	image.quadData.topLeftX,		image.quadData.topLeftY);
				vertexData.setXY(2, 	image.quadData.topRightX,		image.quadData.topRightY);
				vertexData.setXY(3,		image.quadData.bottomRightX,	image.quadData.bottomRightY);
			}
		}
		//else {
			//trace("resize");	
			//vertexData.setXY(0, ResizeX(image.bottomLeft.x),	ResizeY(image.bottomLeft.y));
			//vertexData.setXY(1, ResizeX(image.topLeft.x),	ResizeY(image.topLeft.y));
			//vertexData.setXY(2, ResizeX(image.topRight.x),	ResizeY(image.topRight.y));
			//vertexData.setXY(3, ResizeX(image.bottomRight.x),ResizeY(image.bottomRight.y));
		//}
		
		if (updateColour){
			vertexData.setColor(0, image.displayData.colorBL);
			vertexData.setColor(1, image.displayData.colorTL);
			vertexData.setColor(2, image.displayData.colorTR);
			vertexData.setColor(3, image.displayData.colorBR);
		}
		if (updateAlpha){
			vertexData.setAlpha(image.alpha);
		}
		
		image.setUpdates(false);
		
		image.drawIndex = VertexData.OBJECT_POSITION;
		image.batchType = BatchType.DIRECT;
		VertexData.OBJECT_POSITION++;
		image.parentNonStatic = false;
		
		numItems++;
		//trace([image.isRotating, image.isMoving, image.isStatic]);
	}
	
	function calcOffsetX(maskPosX:Float, posX:Float, image:CoreImage) 
	{
		return (posX - maskPosX) * 0.5 * Fuse.current.stage.stageWidth / image.mask.coreTexture.textureData.activeData.p2Width / image.mask.displayData.scaleX;
	}
	
	function calcOffsetY(posY:Float, maskPosY:Float, image:CoreImage) 
	{
		return (posY - maskPosY) * 0.5 * Fuse.current.stage.stageHeight / image.mask.coreTexture.textureData.activeData.p2Height / image.mask.displayData.scaleY;
	}
}