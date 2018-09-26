package fuse.core.communication.data;

import fuse.core.communication.data.textureData.ITextureData;
import fuse.utils.ObjectId;
import fuse.texture.TextureId;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.data.batchData.WorkerBatchData;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.rangeData.IRangeData;
import fuse.core.communication.data.rangeData.RangeData;
import fuse.core.communication.data.rangeData.WorkerRangeData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.info.WorkerInfo;

/**
 * ...
 * @author P.J.Shand
 */

class CommsObjGen
{
	static var displayDataGen:ObjGen<Dynamic>;
	static var batchDataGen:ObjGen<Dynamic>;
	static var rangeDataGen:ObjGen<Dynamic>;
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
			rangeDataGen = new ObjGen<IRangeData>(WorkerRangeData);
			textureDataGen = new ObjGen<IBatchData>(WorkerTextureData);
		}
		else {
			displayDataGen = new ObjGen<IDisplayData>(DisplayData);
			batchDataGen = new ObjGen<IBatchData>(BatchData);
			rangeDataGen = new ObjGen<IRangeData>(RangeData);
			textureDataGen = new ObjGen<IBatchData>(TextureData);
		}
	}	
	
	static public function getDisplayData(id:Int) 
	{
		init();
		var displayData:IDisplayData = displayDataGen.get(id);
		//displayData.isStatic = 0;
		//displayData.isMoving = 1;
		return displayData;
	}	
	
	static public function getBatchData(id:Int) 
	{
		init();
		return batchDataGen.get(id);
	}	
	
	static public function getRangeData(id:Int) 
	{
		init();
		return rangeDataGen.get(id);
	}	
	
	static public function getTextureData(objectId:ObjectId, textureId:TextureId) 
	{
		init();
		var textureData:ITextureData = textureDataGen.get(objectId);
		textureData.textureId = textureId;
		textureData.baseData.textureId = textureId;
		textureData.atlasData.textureId = textureId;
		//trace([textureData.textureId, textureData.atlasData.objectId]);

		
		return textureData;
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