package fuse.core.messenger.message;
import fuse.core.communication.memory.SharedMemory;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse.core.messenger.MessageManager)
class BaseMessage<T>
{
	var typeIndex:Int;
	var length:Int;
	var id:Int;
	var callbacks:Array<T -> Void> = [];
	var receivedValue:T;
	
	var writeFunction:T -> Void;
	var readFunction:Void -> T;
	
	public function new(id:Int, type:Dynamic, length:Int = 1) 
	{
		this.id = id;
		this.length = length;
		typeIndex = MessageManager.getTypeIndex(type);
		
		trace("typeIndex = " + typeIndex);
		
		if (typeIndex == 1) {
			writeFunction = untyped SharedMemory.memory.writeInt;
			readFunction = untyped SharedMemory.memory.readInt;
		}
		else if (typeIndex == 2) {
			writeFunction = untyped SharedMemory.memory.writeFloat;
			readFunction = untyped SharedMemory.memory.readFloat;
		}
	}
	
	public function send(value:T):Void
	{
		//trace("value = " + value);
		SharedMemory.memory.writeInt(id);
		SharedMemory.memory.writeInt(typeIndex);
		SharedMemory.memory.writeInt(length);
		// Write value in override
	}
}