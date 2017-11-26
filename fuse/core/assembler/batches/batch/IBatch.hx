package fuse.core.assembler.batches.batch;

import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.utils.GcoArray;

/**
 * @author P.J.Shand
 */
interface IBatch 
{
	var index:Int;
	var renderTarget:Null<Int>;
	var renderables:GcoArray<ICoreRenderable>;
	function init(index:Int):Void;
	function add(renderable:ICoreRenderable, renderTarget:Int):Bool;
	function writeVertex():Void;
}