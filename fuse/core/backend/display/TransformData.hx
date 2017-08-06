package fuse.core.backend.display;
import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class TransformData
{
	public var localTransform:FastMatrix3;
	public var globalTransform:FastMatrix3;
	public var positionMatrix:FastMatrix3;
	public var rotMatrix:FastMatrix3;
	public var rotMatrix1:FastMatrix3;
	public var rotMatrix2:FastMatrix3;
	public var rotMatrix3:FastMatrix3;
	
	public function new() 
	{
		localTransform = FastMatrix3.identity();
		globalTransform = FastMatrix3.identity();
		positionMatrix = FastMatrix3.identity();
		rotMatrix = FastMatrix3.identity();
		rotMatrix1 = FastMatrix3.identity();
		rotMatrix2 = FastMatrix3.identity();
		rotMatrix3 = FastMatrix3.identity();
	}
}