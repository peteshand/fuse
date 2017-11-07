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
		if (counter == 0) {
			//trace("Create New");
			return Type.createInstance(_pooledType, args);
		}
		return pool[--counter];
	}

	public function release(s:T):Void
	{
		pool[counter++] = s;
	}
	
	public function spawn(len:Int) 
	{
		var i:Int = counter + len;
		while(--i > counter - 1)
		{
			pool[i] = Type.createInstance(_pooledType, args);
		}
		
		counter += len;
	}
}