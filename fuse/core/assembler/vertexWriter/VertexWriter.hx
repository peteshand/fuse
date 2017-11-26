package fuse.core.assembler.vertexWriter;
import fuse.core.assembler.batches.BatchAssembler;
import fuse.core.assembler.batches.batch.IBatch;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class VertexWriter
{
	public static var VERTEX_COUNT:Int;
	static var conductorData:ConductorData;
	
	public static function init() 
	{
		conductorData = new ConductorData();
	}
	
	static public function build() 
	{
		VertexData.OBJECT_POSITION = 0;
		VERTEX_COUNT = VertexData.basePosition;
		var numItems:Int = 0;
		var batches:GcoArray<IBatch> = BatchAssembler.batches;
		for (i in 0...batches.length) 
		{
			numItems += batches[i].renderables.length;
			batches[i].writeVertex();
		}
		
		//trace("batches.length = " + batches.length);
		conductorData.numberOfBatches = batches.length;
		conductorData.numberOfRenderables = numItems;
	}
	
}