package fuse.core.backend.util.transform;

import fuse.utils.MatrixUtils;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.displaylist.Graphics;
import fuse.math.FastMatrix3;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class WorkerTransformHelper
{
	static var clearMatrix:FastMatrix3;
	static function __init__():Void
	{
		clearMatrix = FastMatrix3.identity();
	}
	
	public function new() 
	{
		
	}
	
	public static inline function update(coreDisplay:CoreDisplayObject) 
	{
		//if (alpha != Graphics.opacity) {
			
			
			//popAlpha = true;
		//}
		//Graphics.color = color.value;
		
		var applyRotation:Int = 0;
		var applyPosition:Int = 0;
		if (coreDisplay.isStatic == 0) applyRotation = 1;
		if (coreDisplay.isStatic == 0) applyPosition = 1;
		
		var x:Float = coreDisplay.displayData.x;
		var y:Float = coreDisplay.displayData.y;
		var width:Float = coreDisplay.displayData.width;
		var height:Float = coreDisplay.displayData.height;
		var scaleX:Float = coreDisplay.displayData.scaleX;
		var scaleY:Float = coreDisplay.displayData.scaleY;
		var pivotX:Float = coreDisplay.displayData.pivotX;
		var pivotY:Float = coreDisplay.displayData.pivotY;
		var rotation:Float = coreDisplay.displayData.rotation;
		
		
		WorkerTransformHelper.clear(coreDisplay.transformData.localTransform);
		
		//WorkerTransformHelper.setScale(localTransform, scaleX, scaleY, base, width, height);
		WorkerTransformHelper.setScale(coreDisplay.transformData.localTransform, scaleX, scaleY, width, height, width, height);
		
		/*if (atlasItem != null && atlasItem.rotation == 90) {
			WorkerTransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x + atlasItem.height, y);
			WorkerTransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation + atlasItem.rotation);
		}
		else {*/
			WorkerTransformHelper.setPosition(coreDisplay.parentNonStatic, applyPosition, coreDisplay.transformData.positionMatrix, coreDisplay.transformData.localTransform, x, y);
			
			
			WorkerTransformHelper.setRotation(coreDisplay.parentNonStatic, applyRotation, applyPosition, coreDisplay.transformData.localTransform, coreDisplay.transformData.rotMatrix, coreDisplay.transformData.rotMatrix1, coreDisplay.transformData.rotMatrix2, coreDisplay.transformData.rotMatrix3, rotation);
		//}
		
		Graphics.transformation.multmat(coreDisplay.transformData.localTransform);
		// Move into pushTransform function
		//if (push) {
			////Graphics.pushTransformation(Graphics.transformation.multmat(coreDisplay.transformData.localTransform));
			//Graphics.pushTransformation(coreDisplay.transformData.localTransform);
		//}
		//coreDisplay.transformData.globalTransform.setFrom(coreDisplay.transformData.localTransform);
		
		multvecs(
			coreDisplay, coreDisplay.transformData.localTransform,
			pivotX, pivotY, width, height
		);
	}
	
	public static inline function multvecs(coreDisplay:CoreDisplayObject, localTransform:FastMatrix3, pivotX:Float, pivotY:Float, width:Float, height:Float) 
	{
		multvec(coreDisplay, "bottomLeftX", "bottomLeftY", localTransform, -pivotX, -pivotY + height);
		multvec(coreDisplay, "topLeftX", "topLeftY", localTransform, -pivotX, -pivotY);
		multvec(coreDisplay, "topRightX", "topRightY", localTransform, -pivotX + width, -pivotY);
		multvec(coreDisplay, "bottomRightX", "bottomRightY", localTransform, -pivotX + width, -pivotY + height);
	}
	
	public static inline function multvec(coreDisplay:CoreDisplayObject, outputX:String, outputY:String, localTransform:FastMatrix3, x: Float, y:Float):Void untyped
	{
		var w:Float = localTransform._02 * x + localTransform._12 * y + localTransform._22;
		coreDisplay[outputX] = transformX((localTransform._00 * x + localTransform._10 * y + localTransform._20) / w);
		coreDisplay[outputY] = transformY((localTransform._01 * x + localTransform._11 * y + localTransform._21) / w);
	}
	
	public inline static function clear(localTransform:FastMatrix3) 
	{
		localTransform.setFrom(clearMatrix);
	}
	
	public inline static function setScale(localTransform:FastMatrix3, scaleX:Float, scaleY:Float, textureWidth:Float, textureHeight:Float, width:Float, height:Float) 
	{
		/*if (base != null) {
			localTransform._00 = scaleX * (width / textureWidth);
			localTransform._11 = scaleY * (height / textureHeight);
		}
		else {*/
			localTransform._00 = scaleX;
			localTransform._11 = scaleY;
		//}
	}
	
	public inline static function setPosition(parentNonStatic:Bool, applyPosition:Int, positionMatrix:FastMatrix3, localTransform:FastMatrix3, x:Float, y:Float) 
	{
		if (applyPosition == 1 || parentNonStatic) MatrixUtils.translation(positionMatrix, x, y);
		localTransform = positionMatrix.multmat(localTransform);
	}
	
	public inline static function setRotation(parentNonStatic:Bool, applyRotation:Int, applyPosition:Int, localTransform:FastMatrix3, rotMatrix:FastMatrix3, rotMatrix1:FastMatrix3, rotMatrix2:FastMatrix3, rotMatrix3:FastMatrix3, rotation:Float) 
	{
		if (applyRotation == 1 || parentNonStatic) {
			if (applyPosition == 1 || parentNonStatic){
				rotMatrix1 = MatrixUtils.translation(rotMatrix1, localTransform._20, localTransform._21);
				rotMatrix2 = MatrixUtils.rotateMatrix(rotMatrix2, rotation / 180 * Math.PI);
				rotMatrix3 = MatrixUtils.translation(rotMatrix3, -localTransform._20, -localTransform._21);
				MatrixUtils.multMatrix(rotMatrix1, rotMatrix2, rotMatrix);
				MatrixUtils.multMatrix(rotMatrix, rotMatrix3, rotMatrix);
			}
			else {
				rotMatrix2 = MatrixUtils.rotateMatrix(rotMatrix2, rotation / 180 * Math.PI);
				MatrixUtils.multMatrix(rotMatrix1, rotMatrix2, rotMatrix);
				MatrixUtils.multMatrix(rotMatrix, rotMatrix3, rotMatrix);
			}
		}
		localTransform = rotMatrix.multmat(localTransform);
	}
	
	static inline function transformX(x:Float):Float 
	{
		return ((x / Core.STAGE_WIDTH) * 2) - 1;
	}
	
	static inline function transformY(y:Float):Float
	{
		return 1 - ((y / Core.STAGE_HEIGHT) * 2);
	}
}