package fuse.utils;

import haxe.ds.ObjectMap;

/**
 * ...
 * @author P.J.Shand
 */
class ObjectPool<T>
{
	private var pool:Array<T>;
	private var counter:Int = 0;
	var _pooledType:Class<T>;
	var args:Array<Dynamic>;

	public function new(_pooledType:Class<T>, len:Int, args:Array<Dynamic>)
	{
		this.args = args;
		this._pooledType = _pooledType;
		pool = new Array();
		spawn(len);
	}

	public function request():T
	{
		//trace(["request counter = " + counter, pool.length]);
		
		if (counter == pool.length) {
			trace("Create New");
			pool[counter] = Type.createInstance(_pooledType, args);
			//return pool[counter++];
		}
		
		return pool[counter++];
	}

	public function release(s:T):Void
	{
		if (counter <= 0) return;
		//trace(["release counter = " + counter, pool.length]);
		pool[--counter] = s;
	}
	
	public function spawn(len:Int) 
	{
		var i:Int = counter + len;
		while(--i > counter - 1)
		{
			pool[i] = Type.createInstance(_pooledType, args);
		}
		
		//counter += len;
	}
	
	public function forceReuse():Void
	{
		counter = 0;// pool.length;
	}
}