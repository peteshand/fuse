package fuse.core.communication.data;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.batchData.WorkerBatchData;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.core.utils.WorkerInfo;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class CommsObjGen
{
	static var displayDataGen:ObjGen<Dynamic>;
	static var batchDataGen:ObjGen<Dynamic>;
	static var textureDataGen:ObjGen<Dynamic>;
	
	public function new() 
	{
		
	}
	
	static inline function init() 
	{
		if (displayDataGen != null) return;
		
		if (WorkerInfo.usingWorkers) {
			displayDataGen = new ObjGen<IDisplayData>(WorkerDisplayData);
			batchDataGen = new ObjGen<IBatchData>(WorkerBatchData);
			textureDataGen = new ObjGen<IBatchData>(WorkerTextureData);
		}
		else {
			displayDataGen = new ObjGen<IDisplayData>(DisplayData);
			batchDataGen = new ObjGen<IBatchData>(BatchData);
			textureDataGen = new ObjGen<IBatchData>(TextureData);
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
	
	static public function getTextureData(id:Int) 
	{
		init();
		return textureDataGen.get(id);
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