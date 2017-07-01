package kea2.worker.thread.display;

import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.texture.ITexture;
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
	var textureData:TextureData;
	public var textureDefArray = new GcoArray<TextureDef>([]);
	
	public function new() 
	{
		
	}
	
	public function begin() 
	{
		textureId = -2;
		renderTargetId = -2;
		
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
		
		textureDefArray[textureDefArray.length] = currentTextureDef;
	}
	
	
	
	public function end() 
	{
		
	}
	
	public function setValues(drawIndex:Int, textureId:Int, renderTargetId:Int, textureData:TextureData):Void
	{
		if (this.textureId != textureId || this.renderTargetId != renderTargetId)
		{
			this.textureId = textureId;
			this.renderTargetId = renderTargetId;
			this.drawIndex = drawIndex;
			this.textureData = textureData;
			
			OnTextureStateChange();
		}
		//return currentRenderBatchDef.index;
	}
	
	function getTextureDef(index:Int):TextureDef
	{
		if (textureDefPool.length <= index) {
			textureDefPool[index] = { 
				index:index,
				startIndex:-1,
				textureId:-1,
				renderTargetId:-1,
				drawIndex:-1,
				textureData:null
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
	textureData:TextureData
}

/*typedef RenderBatchDef =
{
	index:Int,
	startIndex:Int,
	renderTargetId:Int,
	textureIdArray:GcoArray<Int>,
	?numItems:Int,
	?length:Int
}*/