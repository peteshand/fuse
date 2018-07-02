package fuse.core.assembler.vertexWriter.prep;
import fuse.core.assembler.atlas.sheet.AtlasSheets;
import fuse.core.assembler.layers.generate.GenerateLayers;
import fuse.core.assembler.layers.sort.SortLayers;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.data.rangeData.IRangeData;
import fuse.core.communication.data.vertexData.VertexData;
import haxe.Json;

/**
 * ...
 * @author P.J.Shand
 */
class PrepLayersForBatching
{
	static var uploadRanges:Array<UploadRange> = [];
	static var currentUploadRange:UploadRange;
	static var currentStart:Int;
	static var currentIndex:Int;
	static var lastIndex:Int;
	static var lastPos:Int;
	static var conductorData:WorkerConductorData;
	static var uploadAll:Bool;
	
	public function new() 
	{
		
	}
	
	static public function build() 
	{
		if (conductorData == null) {
			conductorData = new WorkerConductorData();
		}
		//uploadRanges = [];
		currentStart = 0;
		currentIndex = 0;
		uploadAll = false;
		
		addAtlasRenderables();
		addLayerRenderables();
		addDirectRenderables();
		
		var count:Int = 0;
		if (lastPos == VertexData.OBJECT_POSITION && lastIndex == currentIndex && uploadAll == false) {
			for (i in 0...currentIndex) 
			{
				if (uploadRanges[i].changed) {
					var rangeData:IRangeData = CommsObjGen.getRangeData(count++);
					rangeData.start = uploadRanges[i].start;
					rangeData.length = uploadRanges[i].end + 1 - uploadRanges[i].start;
					//trace(["a", uploadRanges[i].start, uploadRanges[i].end]);
				}
			}
		}
		else {
			if (currentIndex > 0){
				var rangeData:IRangeData = CommsObjGen.getRangeData(count++);
				rangeData.start = uploadRanges[0].start;
				rangeData.length = uploadRanges[currentIndex - 1].end + 1 - uploadRanges[0].start;
				//trace([rangeData.start, rangeData.length]);
				//for (i in 0...currentIndex) 
				//{				
					//trace(["b", uploadRanges[i].start, uploadRanges[i].end]);
				//}
			}
		}
		
		conductorData.numRanges = count;
		lastIndex = currentIndex;
		lastPos = VertexData.OBJECT_POSITION;
	}
	
	static private function addAtlasRenderables() 
	{
		if (AtlasSheets.partitions.length > 0 && AtlasSheets.active) {
			currentUploadRange = getRange(1, 0);
			closeCurrentRange(AtlasSheets.partitions.length-1);
		}
	}
	
	static private function addLayerRenderables() 
	{
		//if (LayerBufferAssembler.STATE == LayerState.BAKE){
			if (GenerateLayers.layersGenerated == true && SortLayers.layers.length > 0) {
				for (j in 0...SortLayers.layers.length) {
					currentUploadRange = getRange(2, 0);
					closeCurrentRange(SortLayers.layers[j].renderables.length-1);
				}
			}
		//}
	}
	
	static private function addDirectRenderables() 
	{
		if (GenerateLayers.layers.length > 0) {
			for (i in 0...GenerateLayers.layers.length) {
				currentUploadRange = getRange(3, GenerateLayers.layers[i].isStatic);
				closeCurrentRange(GenerateLayers.layers[i].renderables.length-1);
			}
		}
	}
	
	static private function getRange(type:Int, isStatic:Int) 
	{
		if (uploadRanges.length <= currentIndex) {
			currentUploadRange = uploadRanges[currentIndex] = { index:currentIndex, start:currentStart, end:currentStart, changed:true } 
		}
		else {
			currentUploadRange = uploadRanges[currentIndex];
			currentUploadRange.changed = false;
		}
		currentIndex++;
		if (currentUploadRange.start != currentStart) {
			currentUploadRange.start = currentStart;
			currentUploadRange.changed = true;
			uploadAll = true;
		}
		if (currentUploadRange.type != type) {
			currentUploadRange.type = type;
			currentUploadRange.changed = true;
		}
		if (isStatic == 0/* || currentUploadRange.isStatic != isStatic*/) {
			//currentUploadRange.isStatic = isStatic;
			currentUploadRange.changed = true;
		}
		return currentUploadRange;
	}
	
	static private function closeCurrentRange(length:Int) 
	{
		if (currentUploadRange.end != currentUploadRange.start + length) {
			currentUploadRange.end = currentUploadRange.start + length;
			currentUploadRange.changed = true;
			uploadAll = true;
		}
		currentStart = currentUploadRange.end + 1;
		//trace(Json.stringify(currentUploadRange));
	}
}

typedef UploadRange =
{
	index:Int,
	start:Int,
	changed:Bool,
	end:Int,
	?type:Null<Int>/*,
	?isStatic:Null<Int>*/
}