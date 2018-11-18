package fuse.core.communication.data.conductorData;

/**
 * @author P.J.Shand
 */
typedef IConductorData =
{
	frameIndex:Int,
	processIndex:Int,
	numberOfBatches:Int,
	numberOfRenderables:Int,
	busy:Int,
	renderTextureProcessIndex:Int,
	renderTextureCountIndex:Int,
	atlasTextureId1:Int,
	atlasTextureId2:Int,
	atlasTextureId3:Int,
	atlasTextureId4:Int,
	atlasTextureId5:Int,
	layerCacheTextureId1:Int,
	layerCacheTextureId2:Int,
	layerCacheTextureId3:Int,
	layerCacheTextureId4:Int,
	layerCacheTextureId5:Int,
	stageWidth:Int,
	stageHeight:Int,
	windowWidth:Int,
	windowHeight:Int,
	//isStatic:Int,
	frontIsStatic:Int,
	backIsStatic:Int,
	numTriangles:Int,
	highestNumTextures:Int,
	numRanges:Int
}