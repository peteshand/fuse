package fuse.core.messenger.message;
import fuse.core.communication.memory.SharedMemory;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.messenger.MessageManager)
class ArrayMessage<T> extends BaseMessage<T> implements IMessage<T>
{
	var castArray:Array<Dynamic>;
	
	public function new(id:Int, type:Dynamic, length:Int = 1) 
	{
		super(id, type, length);
		
		MessageManager.memoryBlock;
		MessageManager.messengers.set(id, this);
		
		receivedValue = untyped [];
	}
	
	public function process():Void
	{
		var _typeIndex:Int = SharedMemory.memory.readInt();
		var _length:Int = SharedMemory.memory.readInt();
		
		castArray = [];
		for (j in 0..._length) 
		{
			castArray.push(readFunction());
		}
		receivedValue = untyped castArray;
		for (i in 0...callbacks.length) 
		{
			callbacks[i](receivedValue);
		}
	}
	
	public function listen(id:Int, Callback:T -> Void):Void
	{
		callbacks.push(Callback);
	}
	
	override public function send(value:T):Void
	{
		super.send(value);
		
		castArray = untyped value;
		//trace(a);
		for (i in 0...length) 
		{
			writeFunction(castArray[i]);
		}
	}
}