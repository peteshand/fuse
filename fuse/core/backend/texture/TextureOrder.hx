package fuse.core.backend.texture;

import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.ITexture;
import fuse.texture.RenderTexture;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.backend.texture.TextureRenderBatch.RenderBatchDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.RenderTexture)
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
	public var textureDefs = new GcoArray<TextureDef>([]);
	
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
			textureDefs.clear();
		//}
		
		//renderBatchDefs.clear();
		
		//trace("renderBatchDefs.length = " + renderBatchDefs.length);
		
		currentTextureDef = null;
		//currentRenderBatchDef = null;
	}
	
	public function setValues(textureId:Int, textureData:ITextureData, visible:Bool):TextureDef
	{
		//trace("VertexData.basePosition = " + VertexData.basePosition);
		
		textureStartIndex = VertexData.basePosition;
		//trace("textureStartIndex = " + textureStartIndex);
		textureEndIndex = textureStartIndex + VertexData.BYTES_PER_ITEM;
		if (this.textureId != textureId || this.renderTargetId != RenderTexture.currentRenderTargetId)
		{
			//trace("setValues");
			currentTextureDef = getTextureDef(textureDefs.length);
			currentTextureDef.startIndex = textureStartIndex;
			//trace("currentTextureDef.startIndex = " + currentTextureDef.startIndex);
			currentTextureDef.textureId = this.textureId = textureId;
			currentTextureDef.renderTargetId = this.renderTargetId = RenderTexture.currentRenderTargetId;
			//trace("currentTextureDef.renderTargetId = " + currentTextureDef.renderTargetId);
			currentTextureDef.drawIndex = VertexData.OBJECT_POSITION;
			currentTextureDef.textureData = this.textureData = textureData;
			//currentTextureDef.workerDisplays.clear();
			currentTextureDef.numItems = 0;
			
			textureDefs[textureDefs.length] = currentTextureDef;
		}
		if (visible) {
			currentTextureDef.numItems++;
			VertexData.OBJECT_POSITION++;
			//IndicesData.OBJECT_POSITION++;
		}
		
		//trace("VertexData.basePosition = " + VertexData.basePosition);
		
		return currentTextureDef;
	}
	
	public function end() 
	{
		trace("end");
	}
	
	/*public function addWorkerDisplay(coreDisplay:IWorkerDisplay):Void
	{
		currentTextureDef.workerDisplays.push(coreDisplay);
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
	numItems:Int,
	renderBatchDef:RenderBatchDef,
	renderBatchIndex:Int,
	textureIndex:Int
}