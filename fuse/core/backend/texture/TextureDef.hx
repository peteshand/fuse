package fuse.core.backend.texture;

import fuse.core.communication.data.textureData.ITextureData;
/**
 * @author P.J.Shand
 */
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