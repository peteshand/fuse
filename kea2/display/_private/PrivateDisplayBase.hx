package kea2.display._private;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.displayData.IDisplayData;
import kea2.core.memory.data.vertexData.IVertexData;
import kha.math.FastMatrix3;
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
	
	//inline function get_objectId():Int 
	//{
		//return displayData.objectId;
	//}
	//
	//function set_objectId(value:Int):Int 
	//{
		//return displayData.objectId = value;
	//}
	//
	//inline function get_renderId():Int 
	//{
		//return displayData.renderId;
	//}
	//
	//function set_renderId(value:Int):Int 
	//{
		//return displayData.renderId = value;
	//}
}