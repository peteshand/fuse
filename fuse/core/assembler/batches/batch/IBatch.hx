package fuse.core.assembler.batches.batch;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.utils.GcoArray;

/**
 * @author P.J.Shand
 */
interface IBatch {
	var batchData:IBatchData;
	var index:Int;
	var renderTarget:Null<Int>;
	var renderables(get, null):GcoArray<ICoreRenderable>;
	var hasChanged(get, null):Bool;
	var active(get, null):Bool;
	function init(index:Int):Void;
	function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool;
	function writeVertex():Bool;
	function nextFrame():Void;
	// function updateHasChanged():Void;
}
