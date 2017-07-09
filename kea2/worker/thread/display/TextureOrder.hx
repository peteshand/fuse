package kea2.worker.thread.display;

import kea2.core.memory.data.textureData.ITextureData;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.texture.ITexture;
import kea2.texture.RenderTexture;
import kea2.utils.GcoArray;
import kea2.utils.Notifier;
import kea2.core.memory.data.batchData.BatchData;
import kea2.worker.thread.display.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class TextureOrder
{
	public var textureStartIndex:Null<Int>;
	public var textureEndIndex:Null<Int>;
	private var textureId:Int;
	private var renderTargetId:Int;
	
	var textureDefPool:Array<TextureDef> = [];
	var currentTextureDef:TextureDef;
	var drawIndex:Int;
	var textureData:ITextureData;
	public var textureDefArray = new GcoArray<TextureDef>([]);
	
	public function new() 
	{
		
	}
	
	public function begin() 
	{
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
	
	function OnTextureStateChange() 
	{
		currentTextureDef = getTextureDef(textureDefArray.length);
		currentTextureDef.startIndex = textureStartIndex;
		currentTextureDef.textureId = textureId;
		currentTextureDef.renderTargetId = renderTargetId;
		currentTextureDef.drawIndex = drawIndex;
		currentTextureDef.textureData = textureData;
		//currentTextureDef.workerDisplays.clear();
		currentTextureDef.numItems = 0;
		
		textureDefArray[textureDefArray.length] = currentTextureDef;
	}
	
	
	
	public function end() 
	{
		
	}
	
	public function setValues(textureId:Int, textureData:ITextureData):Int
	{
		textureStartIndex = VertexData.basePosition;
		textureEndIndex = textureStartIndex + VertexData.BYTES_PER_ITEM;
		if (this.textureId != textureId || this.renderTargetId != RenderTexture.currentRenderTargetId)
		{
			this.textureId = textureId;
			this.renderTargetId = RenderTexture.currentRenderTargetId;
			this.drawIndex = VertexData.OBJECT_POSITION;
			this.textureData = textureData;
			
			OnTextureStateChange();
		}
		currentTextureDef.numItems++;
		
		VertexData.OBJECT_POSITION++;
		return currentTextureDef.index;
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
				numItems:0
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
	numItems:Int
}