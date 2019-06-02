package fuse.utils;

import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class MatrixUtils {
	static private var temp1:Float;
	static private var temp2:Float;
	static private var temp3:Float;
	static private var tempFastMatrix3:FastMatrix3;

	public function new() {}

	public static function multMatrix(m1:FastMatrix3, m2:FastMatrix3, output:FastMatrix3):Void {
		// temp1 = m1._00 * m2._00;
		// temp2 = m1._10 * m2._01;
		// temp3 = m1._20 * m2._02;
		// output._00 = temp1 + temp2 + temp3;
		//
		// temp1 = m1._00 * m2._10;
		// temp2 = m1._10 * m2._11;
		// temp3 = m1._20 * m2._12;
		// output._10 = temp1 + temp2 + temp3;
		//
		// temp1 = m1._00 * m2._20;
		// temp2 = m1._10 * m2._21;
		// temp3 = m1._20 * m2._22;
		// output._20 = temp1 + temp2 + temp3;
		//
		// temp1 = m1._01 * m2._00;
		// temp2 = m1._11 * m2._01;
		// temp3 = m1._21 * m2._02;
		// output._01 = temp1 + temp2 + temp3;
		//
		// temp1 = m1._01 * m2._10;
		// temp2 = m1._11 * m2._11;
		// temp3 = m1._21 * m2._12;
		// output._11 = temp1 + temp2 + temp3;
		//
		// temp1 = m1._01 * m2._20;
		// temp2 = m1._11 * m2._21;
		// temp3 = m1._21 * m2._22;
		// output._21 = temp1 + temp2 + temp3;

		output._00 = m1._00 * m2._00 + m1._10 * m2._01 + m1._20 * m2._02;
		output._10 = m1._00 * m2._10 + m1._10 * m2._11 + m1._20 * m2._12;
		output._20 = m1._00 * m2._20 + m1._10 * m2._21 + m1._20 * m2._22;

		output._01 = m1._01 * m2._00 + m1._11 * m2._01 + m1._21 * m2._02;
		output._11 = m1._01 * m2._10 + m1._11 * m2._11 + m1._21 * m2._12;
		output._21 = m1._01 * m2._20 + m1._11 * m2._21 + m1._21 * m2._22;
	}

	public static inline function rotateMatrix(m:FastMatrix3, rotation:Float):Void {
		temp1 = rotation;
		temp2 = Math.sin(temp1);
		temp3 = Math.cos(temp1);
		rotateMatrix2(m, temp2, temp3);
	}

	static inline function rotateMatrix2(m:FastMatrix3, sinRotation:Float, cosRotation:Float):Void {
		temp2 = sinRotation;
		temp3 = cosRotation;
		setMatrix(m, temp3, -temp2, 0, temp2, temp3, 0, 0, 0, 1);
	}

	public static inline function translation(m:FastMatrix3, x:Float, y:Float):Void {
		setMatrix(m, 1, 0, x, 0, 1, y, 0, 0, 1);
	}

	static function setMatrix(m:FastMatrix3, _00:Float, _10:Float, _20:Float, _01:Float, _11:Float, _21:Float, _02:Float, _12:Float, _22:Float):Void {
		m._00 = _00;
		m._10 = _10;
		m._20 = _20;

		m._01 = _01;
		m._11 = _11;
		m._21 = _21;

		m._02 = _02;
		m._12 = _12;
		m._22 = _22;
	}
}
