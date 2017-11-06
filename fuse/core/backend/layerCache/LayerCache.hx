package fuse.core.backend.layerCache;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.backend.texture.TextureOrder;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.Core;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.core.backend.layerCache.groups.StaticLayerGroup;
import fuse.core.backend.atlas.partition.AtlasPartition;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.RenderTexture;
import fuse.core.backend.atlas.SheetPacker;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreDisplayObject.StaticDef;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse.texture.RenderTexture)
@:access(fuse.core.communication.data.vertexData.VertexData)
class LayerCache extends StaticLayerGroup
{
	var vertexData:VertexData;
	var indicesData:IIndicesData;
	var textureData:ITextureData;
	var count:Int = 0;
	
	var bottomLeft:Point = new Point();
	var topLeft:Point = new Point();
	var topRight:Point = new Point();
	var bottomRight:Point = new Point();
	
	var drawIndex:Int = -1;
	var textureDef:TextureDef;
	var textureIndex:Int;
	var batchIndex:Int;
	
	var left:Float;
	var top:Float;
	var right:Float;
	var bottom:Float;
	
	public function new(textureId:Int) 
	{
		super();
		this.textureId = textureId;
		vertexData = new VertexData();
		indicesData = new IndicesData();
		textureData = CommsObjGen.getTextureData(textureId);
		textureData.x = textureData.y = 0;
		//textureData.width = WorkerCore.STAGE_WIDTH;
		//textureData.height = WorkerCore.STAGE_HEIGHT;
		textureData.p2Width = Fuse.MAX_TEXTURE_SIZE;
		textureData.p2Height = Fuse.MAX_TEXTURE_SIZE;
		
		
		left = textureData.x;
		top = textureData.y;
		
	}
	
	public function setTextures() 
	{
		count++;
		if (count < length) return false;
		count = 0;
		
		RenderTexture.currentRenderTargetId = -1;
		textureDef = Core.textureOrder.setValues(textureData.textureId, textureData, true);
		return true;
	}
	
	public function setVertexData() 
	{
		if (drawIndex != VertexData.OBJECT_POSITION)
		{	
			//trace("LayerCache");
			//textureData.width = WorkerCore.STAGE_WIDTH;
			//textureData.height = WorkerCore.STAGE_HEIGHT;
			//trace([Core.STAGE_WIDTH, Core.STAGE_HEIGHT]);
			
			right = Core.STAGE_WIDTH / textureData.p2Width;
			bottom = Core.STAGE_HEIGHT / textureData.p2Height;
			
			//trace([left, right, bottom, top]);
			
			// Where to sample from source texture
			vertexData.setU(0, left);	// BOTTOM LEFT
			vertexData.setV(0, bottom);	// BOTTOM LEFT
			vertexData.setU(1, left);	// TOP LEFT
			vertexData.setV(1, top);	// TOP LEFT
			vertexData.setU(2, right);	// TOP RIGHT
			vertexData.setV(2, top);	// TOP RIGHT
			vertexData.setU(3, right);	// BOTTOM RIGHT
			vertexData.setV(3, bottom);	// BOTTOM RIGHT
			
			bottomLeft.setTo(textureData.x, textureData.y + Core.STAGE_HEIGHT);
			topLeft.setTo(textureData.x, textureData.y);
			topRight.setTo(textureData.x + Core.STAGE_WIDTH, textureData.y);
			bottomRight.setTo(textureData.x + Core.STAGE_WIDTH, textureData.y + Core.STAGE_HEIGHT);
			
			//trace([bottomLeft.x, bottomRight.x, topLeft.y, bottomLeft.y]);
			
			vertexData.setX(0, transformX(bottomLeft.x));
			vertexData.setY(0, transformY(bottomLeft.y));
			vertexData.setX(1, transformX(topLeft.x));
			vertexData.setY(1, transformY(topLeft.y));
			vertexData.setX(2, transformX(topRight.x));
			vertexData.setY(2, transformY(topRight.y));
			vertexData.setX(3, transformX(bottomRight.x));
			vertexData.setY(3, transformY(bottomRight.y));
			
			vertexData.setColor(0x0);
			vertexData.setAlpha(1);
			
			// don't draw masks while drawing cached layer //
			vertexData.setMaskTexture(-1);
			
			//vertexData.batchTextureIndex = textureDef.textureIndex;
			vertexData.setTexture(textureDef.textureIndex);
			
			// TODO: only update when you need to
			indicesData.setIndex(0, 0);
			indicesData.setIndex(1, 1);
			indicesData.setIndex(2, 2);
			indicesData.setIndex(3, 0);
			indicesData.setIndex(4, 2);
			indicesData.setIndex(5, 3);
		}
		
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
	}
	
	public function isLastItem(staticDef:StaticDef):Bool
	{
		count++;
		if (count < length) return false;
		count = 0;
		return true;
	}
	
	function transformX(x:Float):Float 
	{
		return ((x / textureData.p2Width) * 2 * (textureData.p2Width / Core.STAGE_WIDTH)) - 1;
	}
	
	function transformY(y:Float):Float
	{
		return 1 - ((y / textureData.p2Height) * 2 * (textureData.p2Height / Core.STAGE_HEIGHT));
	}
}