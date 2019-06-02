package fuse.display.geometry;

/**
 * ...
 * @author P.J.Shand
 */
@:forward(length)
abstract Bounds(Array<Float>) {
	public var left(get, set):Float;
	public var top(get, set):Float;
	public var right(get, set):Float;
	public var bottom(get, set):Float;

	public function new() {
		this = [0, 0, 0, 0];
	}

	@:arrayAccess
	public inline function get(index:Int):Float {
		return this[index];
	}

	@:arrayAccess
	public inline function arrayWrite(index:Int, value:Float):Float {
		this[index] = value;
		return value;
	}

	// public inline function clear()
	// {
	// left = 0;
	// right = 0;
	// top = 0;
	// bottom = 0;
	// }

	function get_left():Float {
		return this[0];
	}

	function get_top():Float {
		return this[1];
	}

	function get_right():Float {
		return this[2];
	}

	function get_bottom():Float {
		return this[3];
	}

	function set_left(value:Float):Float {
		return this[0] = value;
	}

	function set_top(value:Float):Float {
		return this[1] = value;
	}

	function set_right(value:Float):Float {
		return this[2] = value;
	}

	function set_bottom(value:Float):Float {
		return this[3] = value;
	}
}
