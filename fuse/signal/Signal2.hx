package fuse.signal;

/**
 * ...
 * @author P.J.Shand
 */
class Signal2<T1, T2> extends BaseSignal<T1 -> T2 -> Void>
{

	public function new() 
	{
		super();
		
	}
	
	public function dispatch(value1:T1, value2:T2)
	{
		sort();
		
		for (i in 0...items.length) 
		{
			var callback:T1 -> T2 -> Void = items[i].callback;
			callback(value1, value2);
		}
		
		autoRemove();
	}
}