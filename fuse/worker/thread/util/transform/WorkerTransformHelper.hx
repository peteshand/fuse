package fuse.worker.thread.util.transform;

import fuse.utils.MatrixUtils;
import fuse.worker.thread.display.WorkerDisplay;
import fuse.worker.thread.display.WorkerGraphics;
import kha.math.FastMatrix3;

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
	
	public static inline function update(workerDisplay:WorkerDisplay) 
	{
		/*if (alpha != WorkerGraphics.opacity) {
			WorkerGraphics.pushOpacity(WorkerGraphics.opacity * alpha);
			popAlpha = true;
		}*/
		//WorkerGraphics.color = color.value;
		
		
		
		WorkerTransformHelper.clear(workerDisplay.localTransform);
		
		//WorkerTransformHelper.setScale(localTransform, scaleX, scaleY, base, width, height);
		WorkerTransformHelper.setScale(workerDisplay.localTransform, workerDisplay.scaleX, workerDisplay.scaleY, workerDisplay.width, workerDisplay.height, workerDisplay.width, workerDisplay.height);
		
		/*if (atlasItem != null && atlasItem.rotation == 90) {
			WorkerTransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x + atlasItem.height, y);
			WorkerTransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation + atlasItem.rotation);
		}
		else {*/
			WorkerTransformHelper.setPosition(workerDisplay.applyPosition, workerDisplay.positionMatrix, workerDisplay.localTransform, workerDisplay.x, workerDisplay.y);
			
			
			WorkerTransformHelper.setRotation(workerDisplay.applyRotation, workerDisplay.applyPosition, workerDisplay.localTransform, workerDisplay.rotMatrix, workerDisplay.rotMatrix1, workerDisplay.rotMatrix2, workerDisplay.rotMatrix3, workerDisplay.rotation);
		//}
		
		WorkerGraphics.pushTransformation(workerDisplay.localTransform, workerDisplay.renderId);
		workerDisplay.globalTransform.setFrom(workerDisplay.localTransform);
		
		//WorkerGraphics.pushTransformation(WorkerGraphics.transformation.multmat(localTransform), objectId);
		//globalTransform.setFrom(WorkerGraphics.transformation);
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
	
	public inline static function setPosition(applyPosition:Int, positionMatrix:FastMatrix3, localTransform:FastMatrix3, x:Float, y:Float) 
	{
		if (applyPosition == 1) MatrixUtils.translation(positionMatrix, x, y);
		localTransform = positionMatrix.multmat(localTransform);
	}
	
	public inline static function setRotation(applyRotation:Int, applyPosition:Int, localTransform:FastMatrix3, rotMatrix:FastMatrix3, rotMatrix1:FastMatrix3, rotMatrix2:FastMatrix3, rotMatrix3:FastMatrix3, rotation:Float) 
	{
		if (applyRotation == 1) {
			if (applyPosition == 1){
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
	
	
	
}