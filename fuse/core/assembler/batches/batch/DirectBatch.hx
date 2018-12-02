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
	var uvItem:UVItem;
	var uvMaskItem:UVItem;
	//var uvLeft:Float;
	//var uvTop:Float;
	//var uvRight:Float;
	//var uvBottom:Float;

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
		uvMaskItem = {
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
			if (updateMask){
				if (image.mask != null) {
					vertexData.setMaskTexture(image.mask.display.textureIndex);
					//trace("setBatchProps mask: " + image.objectId);
				}
				else {
					vertexData.setMaskTexture(-1);
				}
			}
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
		
		if (FShader.ENABLE_MASKS && image.mask != null) {
			

			/*uvMaskItem.offsetU = image.mask.display.displayData.offsetU;
			uvMaskItem.offsetV = image.mask.display.displayData.offsetV;
			uvMaskItem.scaleU = image.mask.display.displayData.scaleU;
			uvMaskItem.scaleV = image.mask.display.displayData.scaleV;
			
			image.mask.display.coreTexture.getUVData(uvMaskItem);*/

			
			//trace(image.mask.display.quadData);
			//trace(image.quadData);
			var offsetBottomLeftX:Float = calcOffsetX(image.mask.display.quadData.bottomLeftX, image.quadData.bottomLeftX, image);
			var offsetBottomLeftY:Float = calcOffsetY(image.quadData.bottomLeftY, image.mask.display.quadData.bottomLeftY, image);

			var offsetTopLeftX:Float = calcOffsetX(image.mask.display.quadData.topLeftX, image.quadData.topLeftX, image);
			var offsetTopLeftY:Float = calcOffsetY(image.quadData.topLeftY, image.mask.display.quadData.topLeftY, image);

			var offsetTopRightX:Float = calcOffsetX(image.mask.display.quadData.topRightX, image.quadData.topRightX, image);
			var offsetTopRightY:Float = calcOffsetY(image.quadData.topRightY, image.mask.display.quadData.topRightY, image);

			var offsetBottomRightX:Float = calcOffsetX(image.mask.display.quadData.bottomRightX, image.quadData.bottomRightX, image);
			var offsetBottomRightY:Float = calcOffsetY(image.quadData.bottomRightY, image.mask.display.quadData.bottomRightY, image);
			
			var rot:Float = 0;
			//if (image.coreTexture.rotate){
			//	rot = (image.mask.display.displayData.rotation + 90) / 180 * Math.PI;
			//} else {
				rot = image.mask.display.displayData.rotation / 180 * Math.PI;
			//}

			
			var offsetBottomLeftX2:Float = (offsetBottomLeftX * -Math.cos(rot)) + (offsetBottomLeftY * Math.sin(rot));
			var offsetBottomLeftY2:Float = (offsetBottomLeftX * Math.sin(rot)) + (offsetBottomLeftY * Math.cos(rot));
			var offsetTopLeftX2:Float = (offsetTopLeftX * -Math.cos(rot)) + (offsetTopLeftY * Math.sin(rot));
			var offsetTopLeftY2:Float =  (offsetTopLeftX * Math.sin(rot)) + (offsetTopLeftY * Math.cos(rot));
			var offsetTopRightX2:Float = (offsetTopRightX * -Math.cos(rot)) + (offsetTopRightY * Math.sin(rot));
			var offsetTopRightY2:Float =  (offsetTopRightX * Math.sin(rot)) + (offsetTopRightY * Math.cos(rot));
			var offsetBottomRightX2:Float = (offsetBottomRightX * -Math.cos(rot)) + (offsetBottomRightY * Math.sin(rot));
			var offsetBottomRightY2:Float =  (offsetBottomRightX * Math.sin(rot)) + (offsetBottomRightY * Math.cos(rot));
			
			//trace([image.mask.display.coreTexture.uvLeft - offsetBottomLeftX2,	image.mask.display.coreTexture.uvBottom - offsetBottomLeftY2]);
			//trace([image.mask.display.coreTexture.uvLeft - offsetTopLeftX2,	image.mask.display.coreTexture.uvTop - offsetTopLeftY2]);
			//trace([image.mask.display.coreTexture.uvRight - offsetTopRightX2, image.mask.display.coreTexture.uvTop - offsetTopRightY2]);
			//trace([image.mask.display.coreTexture.uvRight - offsetBottomRightX2, image.mask.display.coreTexture.uvBottom - offsetBottomRightY2]);
			
			/*if (image.coreTexture.rotate) {
				vertexData.setMaskUV(0, image.mask.display.coreTexture.uvLeft - offsetBottomLeftX2,	image.mask.display.coreTexture.uvTop - offsetBottomLeftY2);	// bottom left
				vertexData.setMaskUV(1, image.mask.display.coreTexture.uvRight - offsetTopLeftX2,	image.mask.display.coreTexture.uvTop - offsetTopLeftY2);	// top left
				vertexData.setMaskUV(2, image.mask.display.coreTexture.uvRight - offsetTopRightX2, image.mask.display.coreTexture.uvBottom - offsetTopRightY2);	// top right
				vertexData.setMaskUV(3, image.mask.display.coreTexture.uvLeft - offsetBottomRightX2, image.mask.display.coreTexture.uvBottom - offsetBottomRightY2);	// bottom right
			} else {*/
				vertexData.setMaskUV(0, image.mask.display.coreTexture.uvLeft - offsetBottomLeftX2,	image.mask.display.coreTexture.uvBottom - offsetBottomLeftY2);	// bottom left
				vertexData.setMaskUV(1, image.mask.display.coreTexture.uvLeft - offsetTopLeftX2,	image.mask.display.coreTexture.uvTop - offsetTopLeftY2);	// top left
				vertexData.setMaskUV(2, image.mask.display.coreTexture.uvRight - offsetTopRightX2, image.mask.display.coreTexture.uvTop - offsetTopRightY2);	// top right
				vertexData.setMaskUV(3, image.mask.display.coreTexture.uvRight - offsetBottomRightX2, image.mask.display.coreTexture.uvBottom - offsetBottomRightY2);	// bottom right
			//}
			
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
		return (posX - maskPosX) * 0.5 * Fuse.current.stage.stageWidth / image.mask.display.coreTexture.textureData.activeData.p2Width / image.mask.display.displayData.scaleX;
	}
	
	function calcOffsetY(posY:Float, maskPosY:Float, image:CoreImage) 
	{
		return (posY - maskPosY) * 0.5 * Fuse.current.stage.stageHeight / image.mask.display.coreTexture.textureData.activeData.p2Height / image.mask.display.displayData.scaleY;
	}
}