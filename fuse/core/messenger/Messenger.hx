package fuse.core.messenger;

import fuse.core.messenger.message.ArrayMessage;
import fuse.core.messenger.message.IMessage;
import fuse.core.messenger.message.SingleValueMessage;

/**
 * ...
 * @author P.J.Shand
 */

class Messenger<T> implements IMessage<T>
{
	var message:IMessage<T>;
	
	public function new(id:Int, type:Dynamic, length:Int = 1) 
	{
		if (length == 1)	message = new SingleValueMessage<T>(id, type);
		else				message = new ArrayMessage<T>(id, type, length);
	}
	
	public function process() 
	{
		message.process();
	}
	
	public function listen(id:Int, Callback:T -> Void):Void
	{
		message.listen(id, Callback);
	}
	
	public function send(value:T):Void
	{
		message.send(value);
	}
}