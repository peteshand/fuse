package fuse.core.communication.data.displayData;

import fuse.display.BlendMode;
import fuse.utils.Color;
import fuse.texture.TextureId;

/**
 * @author P.J.Shand
 */
@:keep
typedef IDisplayData = {
	x:Float,
	y:Float,
	width:Float,
	height:Float,
	pivotX:Float,
	pivotY:Float,
	scaleX:Float,
	scaleY:Float,
	rotation:Float,
	alpha:Float,
	color:UInt,
	colorTL:UInt,
	colorTR:UInt,
	colorBL:UInt,
	colorBR:UInt,
	objectId:Int,
	textureId:TextureId,
	renderLayer:Int,
	renderTargetId:Int,
	visible:Int,
	blendMode:Int,
	offsetU:Float,
	offsetV:Float,
	scaleU:Float,
	scaleV:Float,
	shaderId:Int,
	bottomLeftX:Float,
	bottomLeftY:Float,
	topLeftX:Float,
	topLeftY:Float,
	topRightX:Float,
	topRightY:Float,
	bottomRightX:Float,
	bottomRightY:Float,
	edgeAA:Int
}
