package fuse.signal;

/**
 * ...
 * @author P.J.Shand
 */
class Signal1<T1> extends BaseSignal<T1 -> Void>
{

	public function new() 
	{
		super();
		
	}
	
	public function dispatch(value1:T1)
	{
		sort();
		
		for (i in 0...items.length) 
		{
			var callback:T1 -> Void = items[i].callback;
			callback(value1);
		}
		
		autoRemove();
	}
}