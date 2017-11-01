package fuse.core.messenger.message;

/**
 * @author P.J.Shand
 */
interface IMessage<T>
{
	function process():Void;
	function listen(id:Int, Callback:T -> Void):Void;
	function send(value:T):Void;
}