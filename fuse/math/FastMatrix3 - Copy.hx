package fuse.math;

/**
 * Base off Kha FastMatrix3 Class.
 */
abstract FastMatrix3(Array<Float>) from Array<Float> {
	static var tempArray:Array<Float>;
	static var tempValue:Float;
	static var temp:FastMatrix3;
	static var temp1:FastMatrix3;

	public var _00(get, set):Float;
	public var _10(get, set):Float;
	public var _20(get, set):Float;
	public var _01(get, set):Float;
	public var _11(get, set):Float;
	public var _21(get, set):Float;
	public var _02(get, set):Float;
	public var _12(get, set):Float;
	public var _22(get, set):Float;

	static function __init__() {
		temp = [0, 0, 0, 0, 0, 0, 0, 0, 0];
	}

	public inline function new(_00:Float, _10:Float, _20:Float, _01:Float, _11:Float, _21:Float, _02:Float, _12:Float, _22:Float) {
		this = [_00, _10, _20, _01, _11, _21, _02, _12, _22];
	}

	public inline function setFrom(m:FastMatrix3):Void {
		temp1 = m;
		tempArray = this;
		tempArray[0] = temp1._00;
		tempArray[1] = temp1._10;
		tempArray[2] = temp1._20;
		tempArray[3] = temp1._01;
		tempArray[4] = temp1._11;
		tempArray[5] = temp1._21;
		tempArray[6] = temp1._02;
		tempArray[7] = temp1._12;
		tempArray[8] = temp1._22;
	}

	public static inline function identity():FastMatrix3 {
		return new FastMatrix3(1, 0, 0, 0, 1, 0, 0, 0, 1);
	}

	public function multmat(m:FastMatrix3):Void {
		tempValue = _00 * m._00 + _10 * m._01 + _20 * m._02;
		temp._00 = tempValue;
		tempValue = _00 * m._10 + _10 * m._11 + _20 * m._12;
		temp._10 = tempValue;
		tempValue = _00 * m._20 + _10 * m._21 + _20 * m._22;
		temp._20 = tempValue;

		tempValue = _01 * m._00 + _11 * m._01 + _21 * m._02;
		temp._01 = tempValue;
		tempValue = _01 * m._10 + _11 * m._11 + _21 * m._12;
		temp._11 = tempValue;
		tempValue = _01 * m._20 + _11 * m._21 + _21 * m._22;
		temp._21 = tempValue;

		tempValue = _02 * m._00 + _12 * m._01 + _22 * m._02;
		temp._02 = tempValue;
		tempValue = _02 * m._10 + _12 * m._11 + _22 * m._12;
		temp._12 = tempValue;
		tempValue = _02 * m._20 + _12 * m._21 + _22 * m._22;
		temp._22 = tempValue;

		m.setFrom(temp);

		// return m;
	}

	inline function get__00():Float {
		return this[0];
	}

	inline function get__10():Float {
		return this[1];
	}

	inline function get__20():Float {
		return this[2];
	}

	inline function get__01():Float {
		return this[3];
	}

	inline function get__11():Float {
		return this[4];
	}

	inline function get__21():Float {
		return this[5];
	}

	inline function get__02():Float {
		return this[6];
	}

	inline function get__12():Float {
		return this[7];
	}

	inline function get__22():Float {
		return this[8];
	}

	function set__00(value:Float):Float {
		this[0] = value;
		return value;
	}

	function set__10(value:Float):Float {
		this[1] = value;
		return value;
	}

	function set__20(value:Float):Float {
		this[2] = value;
		return value;
	}

	function set__01(value:Float):Float {
		this[3] = value;
		return value;
	}

	function set__11(value:Float):Float {
		this[4] = value;
		return value;
	}

	function set__21(value:Float):Float {
		this[5] = value;
		return value;
	}

	function set__02(value:Float):Float {
		this[6] = value;
		return value;
	}

	function set__12(value:Float):Float {
		this[7] = value;
		return value;
	}

	function set__22(value:Float):Float {
		this[8] = value;
		return value;
	}
}
