package kea.util;
import kha.FastFloat;
import kha.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class MatrixUtils
{

	public function new() 
	{
		
	}
	
	public static inline function multMatrix(m1:FastMatrix3, m2:FastMatrix3, output:FastMatrix3):Void
	{	
		output._00 = m1._00 * m2._00 + m1._10 * m2._01 + m1._20 * m2._02;
		output._10 = m1._00 * m2._10 + m1._10 * m2._11 + m1._20 * m2._12;
		output._20 = m1._00 * m2._20 + m1._10 * m2._21 + m1._20 * m2._22;
		
		output._01 = m1._01 * m2._00 + m1._11 * m2._01 + m1._21 * m2._02;
		output._11 = m1._01 * m2._10 + m1._11 * m2._11 + m1._21 * m2._12;
		output._21 = m1._01 * m2._20 + m1._11 * m2._21 + m1._21 * m2._22;
		
		/*output._02 = m1._02 * m2._00 + m1._12 * m2._01 + m1._22 * m2._02;
		output._12 = m1._02 * m2._10 + m1._12 * m2._11 + m1._22 * m2._12;
		output._22 = m1._02 * m2._20 + m1._12 * m2._21 + m1._22 * m2._22;*/
	}
	
	public static inline function rotateMatrix(m:FastMatrix3, rotation: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			Math.cos(rotation), -Math.sin(rotation), 0,
			Math.sin(rotation), Math.cos(rotation), 0,
			0, 0, 1
		);
	}

	public static inline function translation(m:FastMatrix3, x: FastFloat, y: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			1, 0, x,
			0, 1, y,
			0, 0, 1
		);
	}

	inline static function setMatrix(m:FastMatrix3, _00:FastFloat, _10:FastFloat, _20:FastFloat, _01:FastFloat, _11:FastFloat, _21:FastFloat, _02:FastFloat, _12:FastFloat, _22:FastFloat):FastMatrix3
	{
		m._00 = _00;
		m._10 = _10;
		m._20 = _20;
		
		m._01 = _01;
		m._11 = _11;
		m._21 = _21;
		
		m._02 = _02;
		m._12 = _12;
		m._22 = _22;
		
		return m;
	}
}