package kea2.worker.thread.layerCache;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup;
import kea2.core.atlas.packer.AtlasPartition;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.texture.RenderTexture;
import kea2.worker.thread.atlas.SheetPacker;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplay.StaticDef;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup.StaticGroupState;
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
	//var partition:AtlasPartition;
	var count:Int = 0;
	var bottomLeft:Point = new Point();
	var topLeft:Point = new Point();
	var topRight:Point = new Point();
	var bottomRight:Point = new Point();
	var drawIndex:Int = -1;
	
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
		
		//partition = new AtlasPartition(-1, 0, 0, 1600, 900);
	}
	
	public function setTextures(staticDef:StaticDef/*, workerDisplay:WorkerDisplay*/) 
	{
		count++;
		if (count < length) return false;
		count = 0;
		
		RenderTexture.currentRenderTargetId = -1;
		
		WorkerCore.textureOrder.setValues(textureData.textureId, textureData);
		//rkerCore.textureOrder.addWorkerDisplay(workerDisplay);
		
		return true;
	}
	
	public function setVertexData(staticDef:StaticDef) 
	{
		count++;
		//trace("count = " + count);
		//trace("length = " + length);
		
		if (count < length) return false;
		count = 0;
		
		/*trace("index = " + this.index);
		trace("textureId = " + this.textureId);
		trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);*/
		//return;
		
		if (staticDef.state != StaticGroupState.ALREADY_ADDED || drawIndex != VertexData.OBJECT_POSITION) {
			//trace("Draw");
			
			var left:Float = textureData.x;
			var top:Float = textureData.y;
			var right:Float = WorkerCore.STAGE_WIDTH / textureData.p2Width;
			var bottom:Float = WorkerCore.STAGE_HEIGHT / textureData.p2Height;
			
			// Where to sample from source texture
			// BOTTOM LEFT
			vertexData.u1 = left;
			vertexData.v1 = bottom;
			
			// TOP LEFT
			vertexData.u2 = left;
			vertexData.v2 = top;
			
			// TOP RIGHT
			vertexData.u3 = right;
			vertexData.v3 = top;
			
			// BOTTOM RIGHT
			vertexData.u4 = right;
			vertexData.v4 = bottom;
			
			
			
			
			
			
			var mulX:Float = SheetPacker.bufferWidth / 2;
			var mulY:Float = SheetPacker.bufferHeight / 2;
			
			var offsetX:Float = -mulX;
			var offsetY:Float = -mulY;
			
			bottomLeft.setTo(textureData.x, textureData.y + WorkerCore.STAGE_HEIGHT);
			topLeft.setTo(textureData.x, textureData.y);
			topRight.setTo(textureData.x + WorkerCore.STAGE_WIDTH, textureData.y);
			bottomRight.setTo(textureData.x + WorkerCore.STAGE_WIDTH, textureData.y + WorkerCore.STAGE_HEIGHT);
			
			vertexData.x1 = transformX(bottomLeft.x);
			vertexData.y1 = transformY(bottomLeft.y);
			//vertexData.z1 = 0;
			
			vertexData.x2 = transformX(topLeft.x);
			vertexData.y2 = transformY(topLeft.y);
			//vertexData.z2 = 0;
			
			vertexData.x3 = transformX(topRight.x);
			vertexData.y3 = transformY(topRight.y);
			//vertexData.z3 = 0;
			
			vertexData.x4 = transformX(bottomRight.x);
			vertexData.y4 = transformY(bottomRight.y);
			
			/*trace([vertexData.u1, vertexData.v1]);
			trace([vertexData.u2, vertexData.v2]);
			trace([vertexData.u3, vertexData.v3]);
			trace([vertexData.u4, vertexData.v4]);
			
			trace([vertexData.x1, vertexData.y1]);
			trace([vertexData.x2, vertexData.y2]);
			trace([vertexData.x3, vertexData.y3]);
			trace([vertexData.x4, vertexData.y4]);*/
			
			//textureData.atlasTextureId
			//var batchIndex:Int = WorkerCore.textureRenderBatch.findIndex(staticDef.index, textureData.textureId);
			//vertexData.batchTextureIndex = batchIndex;// textureData.textureId;
			//vertexData.renderBatchIndex = 0;
			
		}
		/*else {
			
			trace("Skip");
		}*/
		//RenderTexture.currentRenderTargetId = -1;
		
		
		if (staticDef.state == StaticGroupState.ALREADY_ADDED) {
			drawIndex = VertexData.OBJECT_POSITION;
		}
		VertexData.OBJECT_POSITION++;
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		//
		return true;
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
		//return ((x / textureData.p2Width) * 2) - 1;
		//return ((x / WorkerCore.STAGE_WIDTH) * 2 * (WorkerCore.STAGE_WIDTH / targetWidth)) - 1;
	}
	
	function transformY(y:Float):Float
	{
		return 1 - ((y / textureData.p2Height) * 2 * (textureData.p2Height / WorkerCore.STAGE_HEIGHT));
		//return 1 - ((y / textureData.p2Height) * 2);
		//return 1 - ((y / WorkerCore.STAGE_HEIGHT) * 2 * (WorkerCore.STAGE_HEIGHT / targetHeight));
	}
}