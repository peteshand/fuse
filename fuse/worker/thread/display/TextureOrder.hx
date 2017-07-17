package fuse.worker.thread.display;

import fuse.core.memory.data.textureData.ITextureData;
import fuse.core.memory.data.textureData.TextureData;
import fuse.core.memory.data.vertexData.VertexData;
import fuse.texture.ITexture;
import fuse.texture.RenderTexture;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.memory.data.batchData.BatchData;
import fuse.worker.thread.display.TextureRenderBatch.RenderBatchDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class TextureOrder
{
	public var textureStartIndex:Null<Int>;
	public var textureEndIndex:Null<Int>;
	private var textureId:Int;
	private var renderTargetId:Int;
	
	var textureDefPool:Array<TextureDef> = [];
	var currentTextureDef:TextureDef;
	//var drawIndex:Int;
	var textureData:ITextureData;
	public var textureDefArray = new GcoArray<TextureDef>([]);
	
	public function new() 
	{
		
	}
	
	public function begin() 
	{
		//trace("begin");
		textureId = -2;
		renderTargetId = -2;
		
		textureStartIndex = VertexData.basePosition;
		textureEndIndex = textureStartIndex + VertexData.BYTES_PER_ITEM;
		
		//if (WorkerEntryPoint.hierarchyBuildRequired){
			textureDefArray.clear();
		//}
		
		//renderBatchDefs.clear();
		
		//trace("renderBatchDefs.length = " + renderBatchDefs.length);
		
		currentTextureDef = null;
		//currentRenderBatchDef = null;
	}
	
	public function setValues(textureId:Int, textureData:ITextureData):TextureDef
	{
		textureStartIndex = VertexData.basePosition;
		textureEndIndex = textureStartIndex + VertexData.BYTES_PER_ITEM;
		if (this.textureId != textureId || this.renderTargetId != RenderTexture.currentRenderTargetId)
		{
			//trace("setValues");
			currentTextureDef = getTextureDef(textureDefArray.length);
			currentTextureDef.startIndex = textureStartIndex;
			currentTextureDef.textureId = this.textureId = textureId;
			currentTextureDef.renderTargetId = this.renderTargetId = RenderTexture.currentRenderTargetId;
			currentTextureDef.drawIndex = VertexData.OBJECT_POSITION;
			currentTextureDef.textureData = this.textureData = textureData;
			//currentTextureDef.workerDisplays.clear();
			currentTextureDef.numItems = 0;
			
			textureDefArray[textureDefArray.length] = currentTextureDef;
		}
		currentTextureDef.numItems++;
		
		VertexData.OBJECT_POSITION++;
		return currentTextureDef;
	}
	
	public function end() 
	{
		trace("end");
	}
	
	/*public function addWorkerDisplay(workerDisplay:WorkerDisplay):Void
	{
		currentTextureDef.workerDisplays.push(workerDisplay);
	}*/
	
	function getTextureDef(index:Int):TextureDef
	{
		if (textureDefPool.length <= index) {
			textureDefPool[index] = { 
				index:index,
				startIndex:-1,
				textureId:-1,
				renderTargetId:-1,
				drawIndex:-1,
				textureData:null,
				//workerDisplays:new GcoArray<WorkerDisplay>([]),
				numItems:0,
				renderBatchDef:null,
				renderBatchIndex:0,
				textureIndex:0
			};
		}
		return textureDefPool[index];
	}
	
	public function getTextureDefByDrawIndex(drawIndex:Int):TextureDef
	{
		for (i in 0...textureDefPool.length) 
		{
			if (textureDefPool[i].drawIndex == drawIndex) {
				return textureDefPool[i];
			}
		}
		return null;
	}
	
	
}

typedef TextureDef =
{
	index:Int,
	startIndex:Int,
	textureId:Int,
	renderTargetId:Int,
	drawIndex:Int,
	textureData:ITextureData,
	//workerDisplays:GcoArray<WorkerDisplay>,
	numItems:Int,
	renderBatchDef:RenderBatchDef,
	renderBatchIndex:Int,
	textureIndex:Int
}