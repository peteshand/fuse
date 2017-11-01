package fuse.core.backend.atlas;

import fuse.core.communication.data.indices.IndicesData;
import fuse.core.backend.texture.TextureOrder;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.ITexture;
import fuse.texture.RenderTexture;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.backend.texture.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.RenderTexture)
class AtlasDrawOrder
{
	public var textureStartIndex:Null<Int>;
	public var textureEndIndex:Null<Int>;
	private var textureId:Int;
	private var renderTargetId:Int;
	
	var textureDefPool:Array<TextureDef> = [];
	var currentTextureDef:TextureDef;
	var drawIndex:Int;
	var textureData:ITextureData;
	public var textureDefs = new GcoArray<TextureDef>([]);
	
	public function new() 
	{
		
	}
	
	public function begin() 
	{
		textureId = -2;
		renderTargetId = -2;
		
		//if (WorkerEntryPoint.hierarchyBuildRequired){
			textureDefs.clear();
		//}
		
		//renderBatchDefs.clear();
		
		//trace("renderBatchDefs.length = " + renderBatchDefs.length);
		
		currentTextureDef = null;
		//currentRenderBatchDef = null;
	}
	
	function OnTextureStateChange() 
	{
		currentTextureDef = getTextureDef(textureDefs.length);
		currentTextureDef.startIndex = textureStartIndex;
		currentTextureDef.textureId = textureId;
		currentTextureDef.renderTargetId = renderTargetId;
		currentTextureDef.drawIndex = drawIndex;
		currentTextureDef.textureData = textureData;
		
		textureDefs[textureDefs.length] = currentTextureDef;
	}
	
	public function end() 
	{
		
	}
	
	public function setValues(textureData:ITextureData):Void
	{
		textureStartIndex = VertexData.basePosition;
		textureEndIndex = textureStartIndex + VertexData.BYTES_PER_ITEM;
		//trace(["setValues", textureStartIndex, textureEndIndex]);
		if (this.textureId != textureData.textureId || this.renderTargetId != RenderTexture.currentRenderTargetId)
		{
			this.textureId = textureData.textureId;
			this.renderTargetId = RenderTexture.currentRenderTargetId;
			this.drawIndex = VertexData.OBJECT_POSITION;
			this.textureData = textureData;
			
			OnTextureStateChange();
		}
		
		VertexData.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
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