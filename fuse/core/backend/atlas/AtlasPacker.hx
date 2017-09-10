package fuse.core.backend.atlas;

import fuse.core.backend.Core;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.front.atlas.AtlasBuffers;
import fuse.utils.GcoArray;
import fuse.core.backend.atlas.partition.PartitionRenderable;
import fuse.core.backend.texture.TextureOrder;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.backend.texture.TextureRenderBatch;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class AtlasPacker
{
	static public var NUM_ATLAS_DRAWS:Int = 0;
	//public var textureDataMap = new Map<Int, TextureData>();
	//var texturesMap = new Map<Int, CoreTexture>();
	//var newTextures:Array<CoreTexture> = [];
	
	var sheets:Array<SheetPacker> = [];
	static public var partitionRenderables:GcoArray<PartitionRenderable>;
	
	public function new() 
	{
		if (partitionRenderables == null) {
			partitionRenderables = new GcoArray<PartitionRenderable>([]);
		}
		for (i in 0...5) 
		{
			sheets.push(new SheetPacker(i, AtlasBuffers.startIndex + i));
		}
	}
	
	public function update() 
	{
		if (Core.atlasTextureDrawOrder.textureDefArray.length > 0) {
			partitionRenderables.clear();
			pack(0, 0);
		}
	}
	
	function pack(sheetIndex:Int=0, startIndex:Int=0) 
	{
		if (sheetIndex >= sheets.length) return;
		
		var sheet:SheetPacker = sheets[sheetIndex];
		var endIndex:Int = sheet.pack(startIndex);
		
		if (endIndex < Core.atlasTextureDrawOrder.textureDefArray.length) {
			pack(sheetIndex + 1, endIndex);
		}
	}
	
	public function setVertexData() 
	{
		for (i in 0...partitionRenderables.length) 
		{
			partitionRenderables[i].setVertexData();
		}
	}
	
	//public function registerTexture(textureId:Int):ITextureData
	//{
		//if (!texturesMap.exists(textureId)) {
			//var textureUsage:CoreTexture = new CoreTexture(textureId);
			//texturesMap.set(textureId, textureUsage);
			//newTextures.push(textureUsage);
		//}
		//var textureUsage:CoreTexture = texturesMap.get(textureId);
		//textureUsage.activeCount++;
		//return textureUsage.textureData;
	//}
	
	/*public function removeTexture(textureId:Int) 
	{
		if (texturesMap.exists(textureId)) {
			var textureUsage:CoreTexture = texturesMap.get(textureId);
			textureUsage.activeCount--;
			if (textureUsage.activeCount == 0) {
				texturesMap.remove(textureId);
			}
		}
	}*/
}