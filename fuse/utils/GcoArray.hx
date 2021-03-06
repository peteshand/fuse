package fuse.utils;

import haxe.ds.ObjectMap;

/**
 * ...
 * @author P.J.Shand
 */
@:forward(sort, splice, insert, dispose, indexOf)
abstract GcoArray<T>(GcoArrayBase<T>) {
	var index(get, never):Int;

	public var length(get, set):Int;

	public function new(base:Array<T> = null) {
		this = new GcoArrayBase<T>(base);
	}

	@:arrayAccess
	public inline function get(i:Int):T {
		return this.base[i];
	}

	@:arrayAccess
	public inline function set(i:Int, value:T):T {
		if (this.length <= i)
			this.length = i + 1;
		return this.base[i] = value;
	}

	public inline function push(value:T):Void {
		this.base[this.length] = value;
		this.length = this.length + 1;
	}

	public function clear() {
		this.length = 0;
	}

	public function pop():T {
		var lastIndex:Int = this.length - 1;
		if (lastIndex <= 0)
			return null;
		var temp:T = this.base[lastIndex];
		this.length = lastIndex;
		return this.base[lastIndex];
	}

	inline function get_index():Int {
		return this.length - 1;
	}

	inline function get_length():Int {
		return this.length;
	}

	inline function set_length(value:Int):Int {
		this.length = value;
		return value;
	}

	public inline function copyTo(toArray:GcoArray<T>) {
		toArray.clear();
		for (i in 0...length) {
			toArray[i] = this.base[i];
		}
	}
}

class GcoArrayBase<T> {
	public var base:Array<T>;
	public var length:Int = 0;

	public function new(base:Array<T> = null) {
		if (base == null)
			this.base = [];
		else
			this.base = base;
	}

	public function sort(f:T->T->Int):Void {
		if (length != base.length)
			base.splice(length, base.length - length);
		base.sort(f);
	}

	public function splice(pos:Int, len:Int):Array<T> {
		length -= len; // will cause issues if you splice more value than what are available in the array
		return base.splice(pos, len);
	}

	public function insert(index:Int, value:T) {
		base.insert(index, value);
		length++;
	}

	public function indexOf(x:T, ?fromIndex:Int):Int {
		for (i in 0...length)
			if (base[i] == x)
				return i;
		return -1;
	}

	public function toString():String {
		return base.toString();
	}

	public function dispose() {
		base = null;
		length = 0;
	}
}
