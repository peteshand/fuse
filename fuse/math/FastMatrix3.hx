package fuse.math;

/**
 * Base off Kha FastMatrix3 Class.
 */
abstract FastMatrix3(Array<Float>) from Array<Float>
{
	static var temp: FastMatrix3;
	
	public var _00(get, set):Float; 
	public var _10(get, set):Float;
	public var _20(get, set):Float;
	public var _01(get, set):Float;
	public var _11(get, set):Float;
	public var _21(get, set):Float;
	public var _02(get, set):Float;
	public var _12(get, set):Float;
	public var _22(get, set):Float;
	
	static function __init__()
	{
		temp = [0, 0, 0, 0, 0, 0, 0, 0, 0];
	}
	
	public inline function new(_00:Float, _10:Float, _20:Float, _01:Float, _11:Float, _21:Float, _02:Float, _12:Float, _22:Float) {
		
		this = [_00, _10, _20, _01, _11, _21, _02, _12, _22];
	}
	
	public inline function setFrom(m:FastMatrix3):Void {
		this[0] = m._00; 
		this[1] = m._10; 
		this[2] = m._20;
		this[3] = m._01; 
		this[4] = m._11; 
		this[5] = m._21;
		this[6] = m._02; 
		this[7] = m._12; 
		this[8] = m._22;
	}
	
	public static inline function identity(): FastMatrix3 {
		return new FastMatrix3(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		);
	}
	
	public inline function multmat(m: FastMatrix3): FastMatrix3 {
		
		temp._00 = _00 * m._00 + _10 * m._01 + _20 * m._02;
		temp._10 = _00 * m._10 + _10 * m._11 + _20 * m._12;
		temp._20 = _00 * m._20 + _10 * m._21 + _20 * m._22;
		
		temp._01 = _01 * m._00 + _11 * m._01 + _21 * m._02;
		temp._11 = _01 * m._10 + _11 * m._11 + _21 * m._12;
		temp._21 = _01 * m._20 + _11 * m._21 + _21 * m._22;
		
		temp._02 = _02 * m._00 + _12 * m._01 + _22 * m._02;
		temp._12 = _02 * m._10 + _12 * m._11 + _22 * m._12;
		temp._22 = _02 * m._20 + _12 * m._21 + _22 * m._22;
		
		m.setFrom(temp);
		
		return m;
	}
	
	inline function get__00():Float { return this[0]; }
	inline function get__10():Float { return this[1]; }
	inline function get__20():Float { return this[2]; }
	inline function get__01():Float { return this[3]; }
	inline function get__11():Float { return this[4]; }
	inline function get__21():Float { return this[5]; }
	inline function get__02():Float { return this[6]; }
	inline function get__12():Float { return this[7]; }
	inline function get__22():Float { return this[8]; }
	
	inline function set__00(value:Float):Float { return this[0] = value; }
	inline function set__10(value:Float):Float { return this[1] = value; }
	inline function set__20(value:Float):Float { return this[2] = value; }
	inline function set__01(value:Float):Float { return this[3] = value; }
	inline function set__11(value:Float):Float { return this[4] = value; }
	inline function set__21(value:Float):Float { return this[5] = value; }
	inline function set__02(value:Float):Float { return this[6] = value; }
	inline function set__12(value:Float):Float { return this[7] = value; }
	inline function set__22(value:Float):Float { return this[8] = value; }
	
}
