package fuse.math;

/**
 * Base off Kha FastMatrix3 Class.
 */
class FastMatrix3
{
	static var temp: FastMatrix3;
	
	static function __init__()
	{
		temp = new FastMatrix3(0,0,0,0,0,0,0,0,0);
	}
	
	private static inline var width: Int = 3;
	private static inline var height: Int = 3;

	public var _00:Float; public var _10:Float; public var _20:Float;
	public var _01:Float; public var _11:Float; public var _21:Float;
	public var _02:Float; public var _12:Float; public var _22:Float;

	public inline function new(_00:Float, _10:Float, _20:Float, _01:Float, _11:Float, _21:Float, _02:Float, _12:Float, _22:Float) {
		this._00 = _00; this._10 = _10; this._20 = _20;
		this._01 = _01; this._11 = _11; this._21 = _21;
		this._02 = _02; this._12 = _12; this._22 = _22;
	}
	
	@:extern public inline function setFrom(m:FastMatrix3):Void {
		this._00 = m._00; this._10 = m._10; this._20 = m._20;
		this._01 = m._01; this._11 = m._11; this._21 = m._21;
		this._02 = m._02; this._12 = m._12; this._22 = m._22;
	}
	
	@:extern public static inline function identity(): FastMatrix3 {
		return new FastMatrix3(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		);
	}
	
	@:extern public inline function multmat(m: FastMatrix3): FastMatrix3 {
		
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
}
