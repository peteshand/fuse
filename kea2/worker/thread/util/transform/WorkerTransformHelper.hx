package kea2.worker.thread.util.transform;
import kea.texture.Texture;
import kea.util.MatrixUtils;
import kha.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
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
	
	public static inline function clear(localTransform:FastMatrix3) 
	{
		localTransform.setFrom(clearMatrix);
	}
	
	public static inline function setScale(localTransform:FastMatrix3, scaleX:Float, scaleY:Float, textureWidth:Float, textureHeight:Float, width:Float, height:Float) 
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
	
	public static inline function setPosition(applyPosition:Bool, positionMatrix:FastMatrix3, localTransform:FastMatrix3, x:Float, y:Float) 
	{
		if (applyPosition) MatrixUtils.translation(positionMatrix, x, y);
		localTransform = positionMatrix.multmat(localTransform);
	}
	
	public static inline function setRotation(applyRotation:Bool, applyPosition:Bool, localTransform:FastMatrix3, rotMatrix:FastMatrix3, rotMatrix1:FastMatrix3, rotMatrix2:FastMatrix3, rotMatrix3:FastMatrix3, rotation:Float) 
	{
		if (applyRotation) {
			if (applyPosition){
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