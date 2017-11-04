package fuse.core.communication.data.batchData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */
class BatchData implements IBatchData
{
	var objectId:Int;
	
	@:isVar public var renderTargetId(get, set):Int = 0;
	@:isVar public var startIndex(get, set):Int = 0;
	@:isVar public var length(get, set):Int = 0;
	
	public var textureIds(get, null):Array<Int>;
	@:isVar public var textureId1(get, set):Int = 0;
	@:isVar public var textureId2(get, set):Int = 0;
	@:isVar public var textureId3(get, set):Int = 0;
	@:isVar public var textureId4(get, set):Int = 0;
	@:isVar public var numTextures(get, set):Int = 0;
	@:isVar public var numItems(get, set):Int = 0;
	@:isVar public var width(get, set):Int = 0;
	@:isVar public var height(get, set):Int = 0;
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
	}
	
	function get_renderTargetId():Int	{ return renderTargetId; }
	function get_startIndex():Int		{ return startIndex; }
	function get_length():Int			{ return length; }
	function get_textureId1():Int		{ return textureId1; }
	function get_textureId2():Int		{ return textureId2; }
	function get_textureId3():Int		{ return textureId3; }
	function get_textureId4():Int		{ return textureId4; }
	function get_numTextures():Int		{ return numTextures; }
	function get_numItems():Int			{ return numItems; }
	function get_width():Int			{ return width; }
	function get_height():Int			{ return height; }
	
	function get_textureIds():Array<Int>
	{
		return [textureId1, textureId2, textureId3, textureId4];
	}
	
	
	function set_renderTargetId(value:Int):Int {
		return renderTargetId = value;
	}
	
	function set_startIndex(value:Int):Int {
		return startIndex = value;
	}
	
	function set_length(value:Int):Int {
		return length = value;
	}
	
	function set_textureId1(value:Int):Int {
		return textureId1 = value;
	}
	
	function set_textureId2(value:Int):Int {
		return textureId2 = value;
	}
	
	function set_textureId3(value:Int):Int {
		return textureId3 = value;
	}
	
	function set_textureId4(value:Int):Int {
		return textureId4 = value;
	}
	
	function set_numTextures(value:Int):Int {
		return numTextures = value;
	}
	
	function set_numItems(value:Int):Int {
		return numItems = value;
	}
	
	function set_width(value:Int):Int {
		return width = value;
	}
	
	function set_height(value:Int):Int {
		return height = value;
	}
}