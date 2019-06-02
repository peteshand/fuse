package fuse.core.backend.texture;

import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.batchData.IBatchData;

/**
 * ...
 * @author P.J.Shand
 */
class TextureRenderBatch {
	static var batchDataArray:Array<IBatchData> = [];

	public function new() {}

	public static function getBatchData(objectId:Int):IBatchData {
		if (objectId >= batchDataArray.length) {
			var batchData:IBatchData = CommsObjGen.getBatchData(objectId);
			batchDataArray.push(batchData);
		}
		return batchDataArray[objectId];
	}
}
