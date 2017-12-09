package fuse.core.backend.texture;

import fuse.core.backend.texture.TextureDef;
import fuse.utils.GcoArray;
/**
 * @author P.J.Shand
 */
typedef RenderBatchDef =
{
	index:Int,
	startIndex:Int,
	renderTargetId:Int,
	textureIdArray:GcoArray<Int>,
	textureDefs:GcoArray<TextureDef>,
	numItems:Int,
	?length:Int	
}