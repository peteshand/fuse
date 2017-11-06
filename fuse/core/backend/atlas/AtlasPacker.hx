package fuse.core.backend.atlas;

import fuse.core.backend.Core;
import fuse.core.backend.atlas.render.AtlasPartitionRenderer;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.utils.GcoArray;
import fuse.core.backend.texture.TextureOrder;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.core.backend.texture.TextureRenderBatch;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse)
class AtlasPacker
{
	static public var NUM_ATLAS_DRAWS:Int = 0;
	var sheets:Array<SheetPacker> = [];
	var renderer = new AtlasPartitionRenderer();
	var index:Int = 0;
	
	public function new() 
	{
		var texturesPerBatch:Int = 4;
		for (i in 0...2) 
		{
			var j:Int = i * texturesPerBatch;
			sheets.push(new SheetPacker(i, AtlasBuffers.startIndex, texturesPerBatch));
		}
	}
	
	public function update() 
	{
		//clear();
		
		index = 0;
		if (Core.atlasDrawOrder.textureDefs.length > 0) {
			for (i in 0...sheets.length) 
			{
				index = sheets[i].pack(index);
				if (index >= Core.atlasDrawOrder.textureDefs.length) break;
			}
		}
	}
	
	//function clear() 
	//{
		//for (i in 0...sheets.length) 
		//{
			//sheets[i].clear();
		//}
	//}
	
	public function setVertexData() 
	{
		for (j in 0...sheets.length) 
		{
			sheets[j].setVertexData();
		}
	}
}