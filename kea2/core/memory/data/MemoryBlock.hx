package kea2.core.memory.data;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class MemoryBlock
{
	static var memoryIdCount:Int = 0;
	public var memoryId:Int;
	public var size:Int;
	public var start:Int;
	public var end:Int;
	
	public function new(size:Int, startPosition:Int) 
	{
		this.size = size;
		start = startPosition;
		end = start + size;
		memoryId = memoryIdCount++;
	}
	
	public function dispose() 
	{
		
	}
	
	public inline function readFloat(offset:Int):Float 
	{
		return Memory.getFloat(start + offset);
	}
	
	public inline function readInt(offset:Int):Int 
	{
		return Memory.getI32(start + offset);
	}
	
	public inline function writeFloat(offset:Int, value:Float):Void 
	{
		Memory.setFloat(start + offset, value);
	}
	
	public inline function writeInt(offset:Int, value:Int):Void 
	{
		Memory.setI32(start + offset, value);
	}
}