package fuse.signal;

/**
 * ...
 * @author P.J.Shand
 */
class Signal0 extends BaseSignal<Void -> Void>
{
	public function new() 
	{
		super();
	}
	
	public function dispatch()
	{
		sort();
		
		for (i in 0...items.length) 
		{
			var callback:Void -> Void = items[i].callback;
			callback();
		}
		
		autoRemove();
	}
}