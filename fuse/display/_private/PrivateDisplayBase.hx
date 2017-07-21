package fuse.display._private;
import fuse.core.front.memory.data.displayData.DisplayData;
import fuse.core.front.memory.data.displayData.IDisplayData;
import fuse.core.front.memory.data.vertexData.IVertexData;
import fuse.math.FastMatrix3;
import openfl.geom.Matrix;

/**
 * ...
 * @author P.J.Shand
 */
class PrivateDisplayBase
{
	static var objectIdCount:Int = 0;
	public var objectId:Int;
	
	static var renderIdCount:Int = 0;
	public var renderId:Int = -1;
	
	public var parentId:Int = -1;
	
	public var vertexData:IVertexData;
	public var displayData:IDisplayData;
	
	var localTransform:FastMatrix3;
	var globalTransform:FastMatrix3;
	var positionMatrix:FastMatrix3;
	var rotMatrix:FastMatrix3;
	var rotMatrix1:FastMatrix3;
	var rotMatrix2:FastMatrix3;
	var rotMatrix3:FastMatrix3;
	
	private function new() 
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