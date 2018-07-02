package fuse.core.assembler.vertexWriter;
import fuse.core.assembler.batches.BatchAssembler;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.assembler.vertexWriter.prep.PrepLayersForBatching;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class VertexWriter
{
	public static var VERTEX_COUNT:Int;
	static var conductorData:WorkerConductorData;
	
	public static function init() 
	{
		conductorData = new WorkerConductorData();
	}
	
	static public function build() 
	{
		VertexData.OBJECT_POSITION = 0;
		VERTEX_COUNT = VertexData.basePosition;
		var numItems:Int = 0;
		var batches:GcoArray<IBatch> = BatchAssembler.batches;
		var numBatches:Int = 0;
		
		for (i in 0...batches.length) 
		{
			var active:Bool = batches[i].writeVertex();
			if (active) {
				numItems += batches[i].renderables.length;		
			}
			numBatches++;
		}
		
		//trace("batches.length = " + batches.length);
		conductorData.numberOfBatches = numBatches;
		conductorData.numberOfRenderables = numItems;
		
		PrepLayersForBatching.build();
	}
}