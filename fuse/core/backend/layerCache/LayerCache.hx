package fuse.core.backend.layerCache;
import fuse.core.communication.data.CommsObjGen;
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

@:access(fuse.texture.RenderTexture)
@:access(fuse.core.communication.data.vertexData.VertexData)
class LayerCache extends StaticLayerGroup
{
	var vertexData:VertexData;
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
			vertexData.setUV(0, left, bottom);
			vertexData.setUV(1, left, top);
			vertexData.setUV(2, right, top);
			vertexData.setUV(3, right, bottom);
			
			bottomLeft.setTo(textureData.x, textureData.y + Core.STAGE_HEIGHT);
			topLeft.setTo(textureData.x, textureData.y);
			topRight.setTo(textureData.x + Core.STAGE_WIDTH, textureData.y);
			bottomRight.setTo(textureData.x + Core.STAGE_WIDTH, textureData.y + Core.STAGE_HEIGHT);
			
			//trace([bottomLeft.x, bottomRight.x, topLeft.y, bottomLeft.y]);
			
			vertexData.setXY(0, transformX(bottomLeft.x), transformY(bottomLeft.y));
			vertexData.setXY(1, transformX(topLeft.x), transformY(topLeft.y));
			vertexData.setXY(2, transformX(topRight.x), transformY(topRight.y));
			vertexData.setXY(3, transformX(bottomRight.x), transformY(bottomRight.y));
			
			vertexData.setColor(0, 0x0);
			vertexData.setColor(1, 0x0);
			vertexData.setColor(2, 0x0);
			vertexData.setColor(3, 0x0);
			//for (i in 0...4) 
			//{
				//vertexData.setR(i, 0);
				//vertexData.setG(i, 0);
				//vertexData.setB(i, 0);
				//vertexData.setA(i, 0);
			//}
			vertexData.setAlpha(1);
			
			// don't draw masks while drawing cached layer //
			vertexData.setMaskTexture(-1);
			
			//vertexData.batchTextureIndex = textureDef.textureIndex;
			vertexData.setTexture(textureDef.textureIndex);
		}
		
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
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