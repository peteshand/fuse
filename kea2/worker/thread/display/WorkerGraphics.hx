package kea2.worker.thread.display;

import kea2.display._private.FastMatrix3Data;
import kea2.worker.communication.IWorkerComms;
import kea2.worker.data.WorkerSharedProperties;
import kha.math.FastMatrix3;
import openfl.Memory;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerGraphics
{
	public var transformation(get, set): FastMatrix3;
	var transformations: Array<FastMatrix3>;
	
	//var transformData:FastMatrix3Data;
	//public var vertexData:VertexData;
	//public var displayData:DisplayData;
	
	public function new(workerComms:IWorkerComms) 
	{
		//transformData = workerComms.getSharedProperty(WorkerSharedProperties.TRANSFORM_DATA);
		//transformData.endian = Endian.LITTLE_ENDIAN;
		
		//vertexData = workerComms.getSharedProperty(WorkerSharedProperties.VERTEX_DATA);
		//vertexData.endian = Endian.LITTLE_ENDIAN;
		
		//displayData = workerComms.getSharedProperty(WorkerSharedProperties.DISPLAY_DATA);
		//displayData.endian = Endian.LITTLE_ENDIAN;
		//DisplayData.displayData = displayData;
		
		//Memory.select(displayData);
		
		transformations = new Array<FastMatrix3>();
		transformations.push(FastMatrix3.identity());
		
		//transformation = FastMatrix3.identity();
	}
	
	public function pushTransformation(transformation:FastMatrix3, renderId:Int): Void {
		//setTransformation(transformation, renderId);
		transformations.push(transformation);
	}
	
	//inline function setTransformation(transformation:FastMatrix3, renderId:Int) 
	//{
		//if (renderId != -1){
			//FastMatrix3Data.renderId = renderId;
			//transformData._00 = transformation._00;
			//transformData._10 = transformation._10;
			//transformData._20 = transformation._20;
			//transformData._01 = transformation._01;
			//transformData._11 = transformation._11;
			//transformData._21 = transformation._21;
			//transformData._02 = transformation._02;
			//transformData._12 = transformation._12;
			//transformData._22 = transformation._22;
		//}
		//
	//}
	
	public function popTransformation(): FastMatrix3 {
		var ret = transformations.pop();
		//setTransformation(get_transformation());
		return ret;
	}
	
	public function buildData() 
	{
		//trace("buildData");
		//trace(transformations.length);
	}
	
	private inline function set_transformation(transformation: FastMatrix3): FastMatrix3 {
		//setTransformation(transformation);
		return transformations[transformations.length - 1] = transformation;
	}
	
	private inline function get_transformation(): FastMatrix3 {
		return transformations[transformations.length - 1];
	}
}