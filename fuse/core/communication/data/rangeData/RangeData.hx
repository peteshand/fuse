package fuse.core.communication.data.rangeData;

import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */
class RangeData implements IRangeData
{
	var objectId:ObjectId;
	@:isVar public var start(get, set):Int;
	@:isVar public var length(get, set):Int;
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
	}
	
	function get_start():Int	{ return start; }
	function get_length():Int	{ return length; }
	
	function set_start(value:Int):Int {
		return start = value;
	}
	
	function set_length(value:Int):Int {
		return length = value;
	}
}