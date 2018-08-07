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
	@:isVar public var clearRenderTarget(get, set):Int;
	@:isVar public var startIndex(get, set):Int = 0;
	@:isVar public var length(get, set):Int = 0;
	@:isVar public var blendMode(get, set):Int = 0;
	@:isVar public var shaderId(get, set):Int = 0;

	public var textureIds(get, null):Array<Int>;
	@:isVar public var textureId1(get, set):Int = 0;
	@:isVar public var textureId2(get, set):Int = 0;
	@:isVar public var textureId3(get, set):Int = 0;
	@:isVar public var textureId4(get, set):Int = 0;
	@:isVar public var textureId5(get, set):Int = 0;
	@:isVar public var textureId6(get, set):Int = 0;
	@:isVar public var textureId7(get, set):Int = 0;
	@:isVar public var textureId8(get, set):Int = 0;
	@:isVar public var numTextures(get, set):Int = 0;
	@:isVar public var numItems(get, set):Int = 0;
	@:isVar public var width(get, set):Int = 0;
	@:isVar public var height(get, set):Int = 0;
	@:isVar public var skip(get, set):Int = 0;
	var _textureIds:Array<Int> = [];
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
	}
	
	function get_renderTargetId():Int	{ return renderTargetId; }
	function get_clearRenderTarget():Int{ return clearRenderTarget; }
	function get_startIndex():Int		{ return startIndex; }
	function get_length():Int			{ return length; }
	function get_blendMode():Int		{ return blendMode; }
	function get_shaderId():Int			{ return shaderId; }
	
	function get_textureId1():Int		{ return textureId1; }
	function get_textureId2():Int		{ return textureId2; }
	function get_textureId3():Int		{ return textureId3; }
	function get_textureId4():Int		{ return textureId4; }
	function get_textureId5():Int		{ return textureId5; }
	function get_textureId6():Int		{ return textureId6; }
	function get_textureId7():Int		{ return textureId7; }
	function get_textureId8():Int		{ return textureId8; }
	function get_numTextures():Int		{ return numTextures; }
	function get_numItems():Int			{ return numItems; }
	function get_width():Int			{ return width; }
	function get_height():Int			{ return height; }
	function get_skip():Int				{ return skip; }
	
	function get_textureIds():Array<Int>
	{
		_textureIds[0] = textureId1;
		_textureIds[1] = textureId2;
		_textureIds[2] = textureId3;
		_textureIds[3] = textureId4;
		_textureIds[4] = textureId5;
		_textureIds[5] = textureId6;
		_textureIds[6] = textureId7;
		_textureIds[7] = textureId8;
		return _textureIds;
	}
	
	function set_renderTargetId(value:Int):Int {
		return renderTargetId = value;
	}
	
	function set_clearRenderTarget(value:Int):Int {
		return clearRenderTarget = value;
	}
	
	function set_startIndex(value:Int):Int {
		return startIndex = value;
	}
	
	function set_length(value:Int):Int {
		return length = value;
	}
	
	function set_blendMode(value:Int):Int {
		return blendMode = value;
	}

	function set_shaderId(value:Int):Int {
		return shaderId = value;
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
	
	function set_textureId5(value:Int):Int {
		return textureId5 = value;
	}
	
	function set_textureId6(value:Int):Int {
		return textureId6 = value;
	}
	
	function set_textureId7(value:Int):Int {
		return textureId7 = value;
	}
	
	function set_textureId8(value:Int):Int {
		return textureId8 = value;
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
	
	function set_skip(value:Int):Int {
		return skip = value;
	}
}