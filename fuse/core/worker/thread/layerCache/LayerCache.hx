package fuse.core.worker.thread.layerCache;
import fuse.core.worker.thread.display.TextureOrder;
import fuse.core.worker.thread.display.TextureOrder.TextureDef;
import fuse.core.worker.thread.layerCache.groups.LayerGroup;
import fuse.core.worker.thread.WorkerCore;
import fuse.core.worker.thread.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.core.worker.thread.layerCache.groups.StaticLayerGroup;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.core.front.memory.data.textureData.TextureData;
import fuse.core.front.memory.data.vertexData.VertexData;
import fuse.texture.RenderTexture;
import fuse.core.worker.thread.atlas.SheetPacker;
import fuse.core.worker.thread.display.WorkerDisplay;
import fuse.core.worker.thread.display.WorkerDisplay.StaticDef;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class LayerCache extends StaticLayerGroup
{
	var vertexData:VertexData;
	var textureData:TextureData;
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
		textureData = new TextureData(textureId);
		textureData.x = textureData.y = 0;
		//textureData.width = WorkerCore.STAGE_WIDTH;
		//textureData.height = WorkerCore.STAGE_HEIGHT;
		textureData.p2Width = 2048;
		textureData.p2Height = 2048;
		
		
		left = textureData.x;
		top = textureData.y;
		
	}
	
	public function setTextures() 
	{
		count++;
		if (count < length) return false;
		count = 0;
		
		RenderTexture.currentRenderTargetId = -1;
		textureDef = WorkerCore.textureOrder.setValues(textureData.textureId, textureData);
		return true;
	}
	
	public function setVertexData() 
	{
		if (drawIndex != VertexData.OBJECT_POSITION)
		{	
			//textureData.width = WorkerCore.STAGE_WIDTH;
			//textureData.height = WorkerCore.STAGE_HEIGHT;
			trace([WorkerCore.STAGE_WIDTH, WorkerCore.STAGE_HEIGHT]);
			
			right = WorkerCore.STAGE_WIDTH / textureData.p2Width;
			bottom = WorkerCore.STAGE_HEIGHT / textureData.p2Height;
			
			// Where to sample from source texture
			vertexData.u1 = left;	// BOTTOM LEFT
			vertexData.v1 = bottom;	// BOTTOM LEFT
			vertexData.u2 = left;	// TOP LEFT
			vertexData.v2 = top;	// TOP LEFT
			vertexData.u3 = right;	// TOP RIGHT
			vertexData.v3 = top;	// TOP RIGHT
			vertexData.u4 = right;	// BOTTOM RIGHT
			vertexData.v4 = bottom;	// BOTTOM RIGHT
			
			bottomLeft.setTo(textureData.x, textureData.y + WorkerCore.STAGE_HEIGHT);
			topLeft.setTo(textureData.x, textureData.y);
			topRight.setTo(textureData.x + WorkerCore.STAGE_WIDTH, textureData.y);
			bottomRight.setTo(textureData.x + WorkerCore.STAGE_WIDTH, textureData.y + WorkerCore.STAGE_HEIGHT);
			
			vertexData.x1 = transformX(bottomLeft.x);
			vertexData.y1 = transformY(bottomLeft.y);
			vertexData.x2 = transformX(topLeft.x);
			vertexData.y2 = transformY(topLeft.y);
			vertexData.x3 = transformX(topRight.x);
			vertexData.y3 = transformY(topRight.y);
			vertexData.x4 = transformX(bottomRight.x);
			vertexData.y4 = transformY(bottomRight.y);
			
			//batchIndex = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDef.index);
			//textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(textureDef.renderBatchIndex, textureData.textureId);
			vertexData.batchTextureIndex = textureDef.textureIndex;
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
		return ((x / textureData.p2Width) * 2 * (textureData.p2Width / WorkerCore.STAGE_WIDTH)) - 1;
	}
	
	function transformY(y:Float):Float
	{
		return 1 - ((y / textureData.p2Height) * 2 * (textureData.p2Height / WorkerCore.STAGE_HEIGHT));
	}
}