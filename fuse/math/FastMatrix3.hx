package fuse.math;

/**
 * Base off Kha FastMatrix3 Class.
 */
class FastMatrix3
{
	//static var tempArray: Array<Float>;
	static var tempValue: Float;
	static var temp: FastMatrix3;
	static var temp1: FastMatrix3;
	static var temp2: FastMatrix3;
	
	public var _00:Float = 0; 
	public var _10:Float = 0;
	public var _20:Float = 0;
	public var _01:Float = 0;
	public var _11:Float = 0;
	public var _21:Float = 0;
	public var _02:Float = 0;
	public var _12:Float = 0;
	public var _22:Float = 0;
	
	static function __init__()
	{
		temp = new FastMatrix3(0, 0, 0, 0, 0, 0, 0, 0, 0);
	}
	
	public inline function new(_00:Float, _10:Float, _20:Float, _01:Float, _11:Float, _21:Float, _02:Float, _12:Float, _22:Float) {
		this._00 = _00;
		this._10 = _10;
		this._20 = _20;
		
		this._01 = _01;
		this._11 = _11;
		this._21 = _21;
		
		this._02 = _02;
		this._12 = _12;
		this._22 = _22;
	}
	
	public inline function setFrom(m:FastMatrix3):Void {
		temp1 = m;
		temp2 = this;
		temp2._00 = temp1._00; 
		temp2._10 = temp1._10; 
		temp2._20 = temp1._20;
		temp2._01 = temp1._01; 
		temp2._11 = temp1._11; 
		temp2._21 = temp1._21;
		temp2._02 = temp1._02; 
		temp2._12 = temp1._12; 
		temp2._22 = temp1._22;
	}
	
	public static inline function identity(): FastMatrix3 {
		return new FastMatrix3(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		);
	}
	
	public function multmat(m: FastMatrix3): Void {
		
		tempValue = _00 * m._00 + _10 * m._01 + _20 * m._02; temp._00 = tempValue;
		tempValue = _00 * m._10 + _10 * m._11 + _20 * m._12; temp._10 = tempValue;
		tempValue = _00 * m._20 + _10 * m._21 + _20 * m._22; temp._20 = tempValue;
		
		tempValue = _01 * m._00 + _11 * m._01 + _21 * m._02; temp._01 = tempValue;
		tempValue = _01 * m._10 + _11 * m._11 + _21 * m._12; temp._11 = tempValue;
		tempValue = _01 * m._20 + _11 * m._21 + _21 * m._22; temp._21 = tempValue;
		
		tempValue = _02 * m._00 + _12 * m._01 + _22 * m._02; temp._02 = tempValue;
		tempValue = _02 * m._10 + _12 * m._11 + _22 * m._12; temp._12 = tempValue;
		tempValue = _02 * m._20 + _12 * m._21 + _22 * m._22; temp._22 = tempValue;
		
		m.setFrom(temp);
		
		//return m;
	}
	
	//inline function get__00():Float { return this[0]; }
	//inline function get__10():Float { return this[1]; }
	//inline function get__20():Float { return this[2]; }
	//inline function get__01():Float { return this[3]; }
	//inline function get__11():Float { return this[4]; }
	//inline function get__21():Float { return this[5]; }
	//inline function get__02():Float { return this[6]; }
	//inline function get__12():Float { return this[7]; }
	//inline function get__22():Float { return this[8]; }
	//
	//function set__00(value:Float):Float { this[0] = value; return value; }
	//function set__10(value:Float):Float { this[1] = value; return value; }
	//function set__20(value:Float):Float { this[2] = value; return value; }
	//function set__01(value:Float):Float { this[3] = value; return value; }
	//function set__11(value:Float):Float { this[4] = value; return value; }
	//function set__21(value:Float):Float { this[5] = value; return value; }
	//function set__02(value:Float):Float { this[6] = value; return value; }
	//function set__12(value:Float):Float { this[7] = value; return value; }
	//function set__22(value:Float):Float { this[8] = value; return value; }
	function toString():String
	{
		return _00 + ", " + _10 + ", " + _20 + ", " + _01 + ", " + _11 + ", " + _21 + ", " + _02 + ", " + _12 + ", " + _22;
	}
}
