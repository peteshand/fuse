package fuse.core.backend.util.transform;

import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.backend.display.TransformData;
import fuse.display.geometry.QuadData;
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
	
	//static var applyRotation:Int;
	//static var applyPosition:Int;
	static var coreDisplay:CoreDisplayObject;
	static var displayData:IDisplayData;
	static var localTransform:FastMatrix3;
	static var transformData:TransformData;
	static var quadData:QuadData;
	
	static var parentNonStatic:Bool;
	static var updateRotation:Bool;
	static var updatePosition:Bool;
	
	static var x:Float;
	static var y:Float;
	static var width:Float;
	static var height:Float;
	static var scaleX:Float;
	static var scaleY:Float;
	static var pivotX:Float;
	static var pivotY:Float;
	static var rotation:Float;
	static var temp:Float;
	static var temp1:Float;
	static var temp2:Float;
	static var tempPoint = new Point();
	static var tempArray:Array<Float>;
	static var PI:Float;
	
	static function __init__():Void
	{
		PI = Math.PI;
		clearMatrix = FastMatrix3.identity();
	}
	
	public function new() 
	{
		
	}
	
	public static function update(coreDisplay:CoreDisplayObject) 
	{
		WorkerTransformHelper.coreDisplay = coreDisplay;
		WorkerTransformHelper.localTransform = coreDisplay.transformData.localTransform;
		WorkerTransformHelper.quadData = coreDisplay.quadData;
		WorkerTransformHelper.displayData = coreDisplay.displayData;
		
		WorkerTransformHelper.x = coreDisplay.displayData.x;
		WorkerTransformHelper.y = coreDisplay.displayData.y;
		WorkerTransformHelper.width = coreDisplay.displayData.width;
		WorkerTransformHelper.height = coreDisplay.displayData.height;
		WorkerTransformHelper.scaleX = coreDisplay.displayData.scaleX;
		WorkerTransformHelper.scaleY = coreDisplay.displayData.scaleY;
		WorkerTransformHelper.pivotX = coreDisplay.displayData.pivotX;
		WorkerTransformHelper.pivotY = coreDisplay.displayData.pivotY;
		WorkerTransformHelper.rotation = coreDisplay.displayData.rotation;
		//trace(Json.stringify(coreDisplay.displayData));
		
		localTransform.setFrom(clearMatrix);
		
		WorkerTransformHelper.parentNonStatic = coreDisplay.parentNonStatic;
		WorkerTransformHelper.updateRotation = coreDisplay.updateRotation;
		WorkerTransformHelper.updatePosition = coreDisplay.updatePosition;
		
		WorkerTransformHelper.transformData = coreDisplay.transformData;
		
		//WorkerTransformHelper.setScale(localTransform, scaleX, scaleY, base, width, height);
		if (scaleX != 1 || scaleY != 1){
			WorkerTransformHelper.setScale(/*localTransform, scaleX, scaleY, width, height, width, height*/);
		}
		/*if (atlasItem != null && atlasItem.rotation == 90) {
			WorkerTransformHelper.setPosition(coreDisplay.isMoving, positionMatrix, localTransform, x + atlasItem.height, y);
			WorkerTransformHelper.setRotation(coreDisplay.isRotating, coreDisplay.isMoving, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation + atlasItem.rotation);
		}
		else {*/
			WorkerTransformHelper.setPosition();
			
			//if (coreDisplay.isRotating == 1) {
				//trace("coreDisplay.isRotating = " + coreDisplay.isRotating);
				//trace("coreDisplay.isMoving = " + coreDisplay.isMoving);
				//trace("rotation = " + rotation);
			//}
			
			WorkerTransformHelper.setRotation(/*coreDisplay.parentNonStatic, coreDisplay.updateRotation, coreDisplay.updatePosition, localTransform, coreDisplay.transformData.rotMatrix, coreDisplay.transformData.rotMatrix1, coreDisplay.transformData.rotMatrix2, coreDisplay.transformData.rotMatrix3, rotation*/);
		//}
		
		
		//trace(localTransform);
		Graphics.transformation.multmat(localTransform);
		// Move into pushTransform function
		//if (push) {
			////Graphics.pushTransformation(Graphics.transformation.multmat(localTransform));
			//Graphics.pushTransformation(localTransform);
		//}
		//coreDisplay.transformData.globalTransform.setFrom(localTransform);
		
		//multvecs(
			//coreDisplay.quadData, localTransform,
			//pivotX, pivotY, width, height
		//);
	//}
	//
	//inline static function multvecs(quadData:QuadData, localTransform:FastMatrix3, pivotX:Float, pivotY:Float, width:Float, height:Float) 
	//{
		multvec(localTransform, -pivotX, -pivotY + height);			// 0, 1
		displayData.bottomLeftX = quadData.bottomLeftX = tempPoint.x;
		displayData.bottomLeftY = quadData.bottomLeftY = tempPoint.y;
		
		multvec(localTransform, -pivotX, -pivotY);					// 2, 3
		displayData.topLeftX = quadData.topLeftX = tempPoint.x;
		displayData.topLeftY = quadData.topLeftY = tempPoint.y;
		
		multvec(localTransform, -pivotX + width, -pivotY);			// 4, 5
		displayData.topRightX = quadData.topRightX = tempPoint.x;
		displayData.topRightY = quadData.topRightY = tempPoint.y;
		
		multvec(localTransform, -pivotX + width, -pivotY + height);	// 6, 7
		displayData.bottomRightX = quadData.bottomRightX = tempPoint.x;
		displayData.bottomRightY = quadData.bottomRightY = tempPoint.y;
	}
	
	static function multvec(localTransform:FastMatrix3, x: Float, y:Float):Void
	{
		temp = localTransform._02 * x + localTransform._12 * y + localTransform._22;
		tempPoint.x = transformX((localTransform._00 * x + localTransform._10 * y + localTransform._20) / temp);
		tempPoint.y = transformY((localTransform._01 * x + localTransform._11 * y + localTransform._21) / temp);
	}
	
	inline static function setScale(/*localTransform:FastMatrix3, scaleX:Float, scaleY:Float, textureWidth:Float, textureHeight:Float, width:Float, height:Float*/) 
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
	
	inline static function setPosition() 
	{
		if (updatePosition || parentNonStatic) MatrixUtils.translation(transformData.positionMatrix, x, y);
		transformData.positionMatrix.multmat(localTransform);
	}
	
	inline static function setRotation(/*parentNonStatic:Bool, updateRotation:Bool, updatePosition:Bool, localTransform:FastMatrix3, rotMatrix:FastMatrix3, rotMatrix1:FastMatrix3, rotMatrix2:FastMatrix3, rotMatrix3:FastMatrix3, rotation:Float*/) 
	{
		if (updateRotation || parentNonStatic) {
			temp1 = rotation / 180 * PI;
			if (updatePosition || parentNonStatic){
				MatrixUtils.translation(transformData.rotMatrix1, localTransform._20, localTransform._21);
				MatrixUtils.rotateMatrix(transformData.rotMatrix2, temp1);
				MatrixUtils.translation(transformData.rotMatrix3, -localTransform._20, -localTransform._21);
				MatrixUtils.multMatrix(transformData.rotMatrix1, transformData.rotMatrix2, transformData.rotMatrix);
				MatrixUtils.multMatrix(transformData.rotMatrix, transformData.rotMatrix3, transformData.rotMatrix);
			}
			else {
				MatrixUtils.rotateMatrix(transformData.rotMatrix2, temp1);
				MatrixUtils.multMatrix(transformData.rotMatrix1, transformData.rotMatrix2, transformData.rotMatrix);
				MatrixUtils.multMatrix(transformData.rotMatrix, transformData.rotMatrix3, transformData.rotMatrix);
			}
		}
		transformData.rotMatrix.multmat(localTransform);
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