package notifier;

import signal.Signal;

@:forward(length, base, concat, join, pop, push, reverse, shift, slice, sort, splice, unshift, insert, arrayRemove, indexOf, lastIndexOf, iterator, map,
	filter, resize, add, addOnce, addWithPriority, addOnceWithPriority, remove, removeAll, dispatch)
abstract ArrayNotifier<T>(BaseArrayNotifier<T>) {
	public inline function new(?value:Array<T>, ?id:String) {
		this = new BaseArrayNotifier(value, id);
	}

	@:arrayAccess function get(k:Int) {
		return this.base[k];
		// return this.charAt(k);
	}
	/*@:arrayAccess function getInt2(k:Int) {
		return this.charAt(k).toUpperCase();
	}*/
}

class BaseArrayNotifier<T> extends Signal {
	public var base:Array<T>;

	public function new(?v:Array<T>, ?id:String) {
		if (v == null)
			base = [];
		else
			base = v;
		super();
	}

	public var length(get, null):Int;

	function get_length():Int {
		return base.length;
	}

	public function concat(a:Array<T>):Array<T> {
		var r = base.concat(a);
		this.dispatch();
		return r;
	}

	public function join(sep:String):String {
		var r = base.join(sep);
		this.dispatch();
		return r;
	}

	public function pop():Null<T> {
		var r = base.pop();
		this.dispatch();
		return r;
	}

	public function push(x:T):Int {
		var r = base.push(x);
		this.dispatch();
		return r;
	}

	public function reverse():Void {
		base.reverse();
		this.dispatch();
	}

	public function shift():Null<T> {
		var r = base.shift();
		this.dispatch();
		return r;
	}

	public function slice(pos:Int, ?end:Int):Array<T> {
		var r = base.slice(pos, end);
		this.dispatch();
		return r;
	}

	public function sort(f:T->T->Int):Void {
		base.sort(f);
		this.dispatch();
	}

	public function splice(pos:Int, len:Int):Array<T> {
		var r = base.splice(pos, len);
		this.dispatch();
		return r;
	}

	public function unshift(x:T):Void {
		base.unshift(x);
		this.dispatch();
	}

	public function insert(pos:Int, x:T):Void {
		base.insert(pos, x);
		this.dispatch();
	}

	public function arrayRemove(x:T):Bool {
		var r:Bool = base.remove(x);
		this.dispatch();
		return r;
	}

	public function indexOf(x:T, ?fromIndex:Int):Int {
		return base.indexOf(x, fromIndex);
	}

	public function lastIndexOf(x:T, ?fromIndex:Int):Int {
		return base.lastIndexOf(x, fromIndex);
	}

	public function iterator():Iterator<T> {
		return base.iterator();
	}

	public function map<S>(f:T->S):Array<S> {
		return base.map(f);
	}

	public function filter(f:T->Bool):Array<T> {
		return base.filter(f);
	}

	public function resize(len:Int):Void {
		base.resize(len);
		this.dispatch();
	}
}
