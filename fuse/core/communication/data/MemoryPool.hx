package fuse.core.communication.data;
import openfl.errors.Error;

/**
 * ...
 * @author P.J.Shand
 */

class MemoryPool
{
	static var position:Int = 0;
	public var size:Int;
	public var start:Int;
	public var end:Int;
	
	//var memoryBlocks:Array<MemoryBlock> = [];
	
	public function new(size:Int) 
	{
		this.size = size;
		if (size == 10000) {
			trace("size = " + size);
		}
		start = position;
		end = start + size;
		position = end;
	}
	
	public function createMemoryBlock(blockSize:Int, index:Int):MemoryBlock
	{
		var startPosition:Int = start + (blockSize * index);
		if (startPosition + blockSize > end) {
			throw new Error("Block outside pool limit!, blockSize =" + blockSize + " index = " + index + " size = " + size);
			return null;
		}
		
		var memoryBlock:MemoryBlock = new MemoryBlock(blockSize, startPosition);
		//memoryBlocks.push(memoryBlock);
		return memoryBlock;
	}
}