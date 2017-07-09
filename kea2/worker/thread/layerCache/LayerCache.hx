package kea2.worker.thread.layerCache;
import kea2.worker.thread.layerCache.groups.LayerGroup.LayerGroupState;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup;
import kea2.core.atlas.packer.AtlasPartition;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.texture.RenderTexture;
import kea2.worker.thread.atlas.SheetPacker;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplay.StaticDef;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
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
	var textureDefIndex:Int;
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
		textureData.width = 1600;
		textureData.height = 900;
		textureData.p2Width = 2048;
		textureData.p2Height = 2048;
		
		left = textureData.x;
		top = textureData.y;
		
	}
	
	public function setTextures(/*staticDef:StaticDef*/) 
	{
		count++;
		if (count < length) return false;
		count = 0;
		
		RenderTexture.currentRenderTargetId = -1;
		textureDefIndex = WorkerCore.textureOrder.setValues(textureData.textureId, textureData);
		return true;
	}
	
	public function setVertexData() 
	{
		if (drawIndex != VertexData.OBJECT_POSITION)
		{	
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
			
			batchIndex = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
			textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, textureData.textureId);
			vertexData.batchTextureIndex = textureIndex;
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