package kea.display._private;
import kha.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class PrivateDisplayBase
{
	static var objectIdCount:Int = 0;
	
	public var objectId:Int;
	
	var localTransform:FastMatrix3;
	var globalTransform:FastMatrix3;
	var positionMatrix:FastMatrix3;
	var rotMatrix:FastMatrix3;
	var rotMatrix1:FastMatrix3;
	var rotMatrix2:FastMatrix3;
	var rotMatrix3:FastMatrix3;
	
	private function new() 
	{
		objectId = objectIdCount++;
		
		localTransform = FastMatrix3.identity();
		globalTransform = FastMatrix3.identity();
		positionMatrix = FastMatrix3.identity();
		rotMatrix = FastMatrix3.identity();
		rotMatrix1 = FastMatrix3.identity();
		rotMatrix2 = FastMatrix3.identity();
		rotMatrix3 = FastMatrix3.identity();
	}
	
}