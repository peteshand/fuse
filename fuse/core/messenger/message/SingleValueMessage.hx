package fuse.core.messenger.message;
import fuse.core.communication.memory.SharedMemory;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.messenger.MessageManager)
class SingleValueMessage<T> extends BaseMessage<T> implements IMessage<T>
{
	public function new(id:Int, type:Dynamic) 
	{
		super(id, type, 1);
		
		MessageManager.memoryBlock;
		MessageManager.messengers.set(id, this);
	}
	
	public function process():Void
	{
		var _typeIndex:Int = SharedMemory.memory.readInt();
		var _length:Int = SharedMemory.memory.readInt();
		
		
		receivedValue = readFunction();
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
		writeFunction(value);
	}
}