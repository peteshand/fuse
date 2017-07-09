package kea2.pool;

import haxe.ds.ObjectMap;

/**
 * ...
 * @author P.J.Shand
 */
class ObjectPool<T>
{
	private var pool:Array<T>;
	private var counter:Int;
	var _pooledType:Class<T>;
	var args:Array<Dynamic>;

	public function new(_pooledType:Class<T>, len:Int, args:Array<Dynamic>)
	{
		this.args = args;
		this._pooledType = _pooledType;
		pool = new Array();
		counter = len;

		var i:Int = len;
		while(--i > -1)
		{
			pool[i] = Type.createInstance(_pooledType, args);
		}
	}

	public function request():T
	{
		if (counter == 0) {
			trace("Create New");
			return Type.createInstance(_pooledType, args);
		}
		return pool[--counter];
	}

	public function release(s:T):Void
	{
		pool[counter++] = s;
	}
}