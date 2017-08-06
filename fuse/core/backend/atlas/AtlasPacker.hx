package fuse.core.backend.atlas;

import fuse.core.backend.Core;
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
	var textureUsageMap = new Map<Int, TextureUsage>();
	var newTextures:Array<TextureUsage> = [];
	
	var sheets:Array<SheetPacker> = [];
	//var conductorData:ConductorData = new ConductorData();
	static public var partitionRenderables:GcoArray<PartitionRenderable>;
	
	public function new() 
	{
		/*var textureIds:Array<Int> = [];
		if (conductorData.atlasTextureId1 != 0) textureIds.push(conductorData.atlasTextureId1);
		if (conductorData.atlasTextureId2 != 0) textureIds.push(conductorData.atlasTextureId2);
		if (conductorData.atlasTextureId3 != 0) textureIds.push(conductorData.atlasTextureId3);
		if (conductorData.atlasTextureId4 != 0) textureIds.push(conductorData.atlasTextureId4);
		if (conductorData.atlasTextureId5 != 0) textureIds.push(conductorData.atlasTextureId5);*/
		
		if (partitionRenderables == null) {
			partitionRenderables = new GcoArray<PartitionRenderable>([]);
		}
		for (i in 0...5) 
		{
			sheets.push(new SheetPacker(i, AtlasBuffers.startIndex + i));
		}
	}
	
	//public function update() 
	//{
		//for (i in 0...textureOrder.textureDefArray.length) 
		//{
			//var textureUsage:TextureUsage = textureUsageMap.get(textureOrder.textureDefArray[i].textureId);
			//trace("textureUsage.textureId = " + textureUsage.textureId);
			//trace([textureUsage.textureData.width, textureUsage.textureData.height, textureUsage.textureData.p2Width, textureUsage.textureData.p2Height]);
			//
			//
		//}
		///*while (newTextures.length > 0) 
		//{
			//var textureUsage:TextureUsage = newTextures.shift();
			//
		//}*/
	//}
	
	public function update() 
	{
		if (Core.atlasTextureDrawOrder.textureDefArray.length > 0) {
			partitionRenderables.clear();
			pack(0, 0);
			//setVertexData();
		}
		//trace("sheets = " + sheets);
	}
	
	function pack(sheetIndex:Int=0, startIndex:Int=0) 
	{
		//trace("sheetIndex = " + sheetIndex);
		//trace("startIndex = " + startIndex);
		
		if (sheetIndex >= sheets.length) return;
		
		var sheet:SheetPacker = sheets[sheetIndex];
		var endIndex:Int = sheet.pack(startIndex);
		//trace("endIndex = " + endIndex);
		
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
	
	public function registerTexture(textureId:Int):ITextureData
	{
		if (!textureUsageMap.exists(textureId)) {
			var textureUsage:TextureUsage = new TextureUsage(textureId);
			textureUsageMap.set(textureId, textureUsage);
			newTextures.push(textureUsage);
		}
		var textureUsage:TextureUsage = textureUsageMap.get(textureId);
		textureUsage.activeCount++;
		return textureUsage.textureData;
	}
	
	public function removeTexture(textureId:Int) 
	{
		if (textureUsageMap.exists(textureId)) {
			var textureUsage:TextureUsage = textureUsageMap.get(textureId);
			textureUsage.activeCount--;
			if (textureUsage.activeCount == 0) {
				textureUsageMap.remove(textureId);
			}
		}
	}
}

class TextureUsage
{
	public var textureId:Float;
	public var activeCount:Int = 0;
	public var textureData:ITextureData;
	
	public function new(textureId:Int)
	{
		this.textureId = textureId;
		textureData = new TextureData(textureId);
	}
}