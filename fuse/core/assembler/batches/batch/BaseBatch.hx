package fuse.core.assembler.batches.batch;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class BaseBatch
{
	var batchTextures:BatchTextures;
	var batchData:IBatchData;
	public var index:Int = -1;
	public var renderables:GcoArray<ICoreRenderable>;
	public var renderTarget:Null<Int>;
	
	public function new() 
	{
		batchTextures = new BatchTextures();
		renderables = new GcoArray<ICoreRenderable>([]);
	}
	
	public function init(index:Int):Void
	{
		renderTarget = null;
		renderables.clear();
		batchTextures.clear();
		if (this.index == index) return;
		
		this.index = index;
		batchData = CommsObjGen.getBatchData(index);
	}
	
	public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool
	{
		var textureIndex:Int = getTextureIndex(renderable);
		if (textureIndex == -1) return false;
		
		renderable.textureIndex = textureIndex;
		
		if (renderTargetChanged(renderTarget)) return false;
		
		renderables.push(renderable);
		return true;
	}
	
	function getTextureIndex(renderable:ICoreRenderable) 
	{
		return batchTextures.getTextureIndex(renderable.coreTexture.textureId);
	}
	
	function renderTargetChanged(renderTarget:Int) 
	{
		if (this.renderTarget == renderTarget) return false;
		if (this.renderTarget != null) return true;
		
		this.renderTarget = renderTarget;
		return false;
	}
	
	inline function setBatchProps() 
	{
		//batchData.clearRenderTarget =						// Currently not set anywhere
		//batchData.height = 								// Not sure if this is needed
		//batchData.length = 								// Not sure if this is needed
		batchData.numItems = renderables.length;
		batchData.numTextures = batchTextures.textureIds.length;
		batchData.renderTargetId = renderTarget;
		batchData.startIndex = VertexWriter.VERTEX_COUNT;
		batchData.textureId1 = batchTextures.textureId1;
		batchData.textureId2 = batchTextures.textureId2;
		batchData.textureId3 = batchTextures.textureId3;
		batchData.textureId4 = batchTextures.textureId4;
		//batchData.width = 								// Not sure if this is needed
	}
	
	public function toString():String
	{
		return Type.getClassName(Type.getClass(this)) + "\nindex = " + index + "\nrenderTarget = " + renderTarget + " \nbatchTextures = " + batchTextures;
	}
}