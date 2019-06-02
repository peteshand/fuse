package fuse.core.communication.data.textureData;

import fuse.texture.TextureId;
import fuse.utils.ObjectId;

/**
 * @author P.J.Shand
 */
typedef TextureSizeData = {
	textureId:TextureId,
	objectId:ObjectId,
	x:Int,
	// x position in pixels on underlying texture
	y:Int,
	// y position in pixels on underlying texture
	width:Int,
	// width in pixels on underlying texture
	height:Int,
	// height in pixels on underlying texture
	p2Width:Int,
	// next power of 2 of width
	p2Height:Int,
	// next power of 2 of height
	offsetU:Float,
	offsetV:Float,
	scaleU:Float,
	scaleV:Float
}
