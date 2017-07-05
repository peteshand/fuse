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

	public function new(_pooledType:Class<T>, len:Int)
	{
		this._pooledType = _pooledType;
		pool = new Array();
		counter = len;

		var i:Int = len;
		while(--i > -1)
		{
			pool[i] = Type.createInstance(_pooledType, [null]);
		}
	}

	public function request():T
	{
		if (counter == 0) {
			return Type.createInstance(_pooledType, [null]);
		}
		return pool[--counter];
	}

	public function release(s:T):Void
	{
		pool[counter++] = s;
	}
}