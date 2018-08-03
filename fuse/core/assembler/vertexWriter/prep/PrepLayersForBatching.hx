package fuse.core.assembler.vertexWriter.prep;

import fuse.core.assembler.batches.BatchAssembler;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.data.rangeData.IRangeData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class PrepLayersForBatching
{
	static var conductorData:WorkerConductorData;
	
	public function new() 
	{
		
	}
	
	static public function build() 
	{
		if (conductorData == null) {
			conductorData = new WorkerConductorData();
		}
		
		var count:Int = 0;
		var batches:GcoArray<IBatch> = BatchAssembler.batches;
		var start:Int = 0;
		var end:Int = 0;
		var numRanges:Int = 0;
		
		for (i in 0...batches.length) 
		{
			if (batches[i].active) {
				if (batches[i].renderables.length > 0) {
					
					var rangeData:IRangeData = CommsObjGen.getRangeData(count++);
					rangeData.start = start;
					rangeData.length = batches[i].renderables.length;
					
					start += batches[i].renderables.length;
					numRanges++;
				}
			}
		}
		conductorData.numRanges = numRanges;
	}
}