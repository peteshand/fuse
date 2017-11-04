package fuse.core.communication.data;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.batchData.WorkerBatchData;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.utils.WorkerInfo;

/**
 * ...
 * @author P.J.Shand
 */
class CommsObjGen
{
	static var displayDataGen:ObjGen<Dynamic>;
	static var batchDataGen:ObjGen<Dynamic>;
	
	public function new() 
	{
		
	}
	
	static inline function init() 
	{
		if (displayDataGen != null) return;
		
		if (WorkerInfo.usingWorkers) {
			displayDataGen = new ObjGen<IDisplayData>(WorkerDisplayData);
			batchDataGen = new ObjGen<IBatchData>(WorkerBatchData);
		}
		else {
			displayDataGen = new ObjGen<IDisplayData>(WorkerDisplayData);
			batchDataGen = new ObjGen<IBatchData>(WorkerBatchData);
		}
	}	
	
	static public function getDisplayData(id:Int) 
	{
		init();
		return displayDataGen.get(id);
	}	
	
	static public function getBatchData(id:Int) 
	{
		init();
		return batchDataGen.get(id);
	}
}

class ObjGen<T>
{
	var map = new Map<Int, T>();
	var GenClass:Class<Dynamic>;
	
	public function new(GenClass:Class<Dynamic>)
	{
		this.GenClass = GenClass;
	}
	
	public function get(id:Int)
	{
		var obj:T = map.get(id);
		if (obj == null) {
			obj = Type.createInstance(GenClass, [id]);
			map.set(id, obj);
		}
		return obj;
	}
}