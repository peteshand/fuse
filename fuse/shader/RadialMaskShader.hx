package fuse.shader;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.Vector;

class RadialMaskShader extends BaseShader {
	var id:Int;
	var data:Vector<Float>;

	@:isVar public var start(default, set):Float = 0;
	@:isVar public var end(default, set):Float = 0;
	@:isVar public var x(default, set):Float = 0.5;
	@:isVar public var y(default, set):Float = 0.5;

	static var count:Int = 0;

	public function new() {
		super();
		id = count++;
		data = new Vector<Float>();

		data[0] = 1;
		data[1] = 0;
		data[2] = Math.PI;
		data[3] = 2 * Math.PI;

		data[4] = 1e-10;
		data[5] = Math.PI / 2;
		data[6] = 0.5;
		data[7] = 0; // length

		data[8] = 0.5; // x
		data[9] = 0.5; // y
		data[10] = 0; // start
		data[11] = end = 360 / 180 * Math.PI; // end
	}

	function set_x(value:Float):Float {
		data[8] = value;
		onUpdate.dispatch();
		return x = value;
	}

	function set_y(value:Float):Float {
		data[9] = value;
		onUpdate.dispatch();
		return y = value;
	}

	function set_start(value:Float):Float {
		var value2 = (value) % 360;
		if (value2 < 0)
			value2 += 360;
		data[10] = (value2 / 180 * Math.PI);
		start = value;
		data[7] = (end - start) / 180 * Math.PI;
		trace("length = " + data[7]);
		onUpdate.dispatch();
		return start;
	}

	function set_end(value:Float):Float {
		// data[11] = (value / 180 * Math.PI) % (Math.PI * 2);
		var value2 = (value) % 360;
		if (value2 < 0)
			value2 += 360;
		data[11] = (value2 / 180 * Math.PI);
		end = value;
		data[7] = (end - start) / 180 * Math.PI;
		trace("length = " + data[7]);
		onUpdate.dispatch();
		return end;
	}

	override public function activate(context3D:Context3D):Void {
		context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 10, data, 3);
		hasChanged = false;
	}

	override public function fragmentString():String {
		var agal:String = "";

		agal += "div ft2.xy, v0.xy, v0.zw					\n";
		// agal += "sub ft2.xy, ft2.xy, fc11.zz				\n";
		agal += "sub ft2.xy, ft2.xy, fc12.xy				\n";

		agal += atan2(); // ft4.x = atan2(ft2.y, ft2.x)  Uses: ft3, ft4, ft5

		agal += "add ft4.x, ft4.x, fc10.z					\n";
		agal += "sub ft4.x, ft4.x, fc12.z					\n"; // set start

		agal += "div ft4.x, ft4.x, fc10.w					\n";
		agal += "frc ft4.x, ft4.x							\n";
		agal += "mul ft4.x, ft4.x, fc10.w					\n";

		// agal += "sub ft4.y, fc12.w, fc12.z				\n"; // calc length = end - start
		// set-if-less-than - destination = source1 < source2 ? 1 : 0, component-wise
		agal += "slt ft0.z, ft4.x, fc11.w				\n";

		agal += "mul ft1.xyzw, ft1.xyzw, ft0.zzzz			\n";

		return agal;
	}

	function atan2() {
		//
		return "add ft2.x, ft2.x, fc11.x            \n"
			+ // fudge to prevent div zero

			"div ft3.x, ft2.y, ft2.x            \n"
			+ // ft2.x = ydiff / xdiff
			"neg ft3.y, ft3.x                   \n"
			+ // ft2.y = -ydiff / xdiff

			"mul ft4.y, fc11.y, ft3.x            \n"
			+ // ft4.x = atan(ft2.x)
			"add ft4.z, fc10.x, ft3.x            \n"
			+ // atan(x) = Pi / 2 * x / (1 + x)
			"div ft5.x, ft4.y, ft4.z            \n"
			+ "mul ft4.y, fc11.7, ft3.y            \n"

			+ // ft4.y = atan(ft2.y)
			"add ft4.z, fc10.x, ft3.y            \n"
			+ // atan(x) = Pi / 2 * x / (1 + x)
			"div ft5.y, ft4.y, ft4.z            \n"
			+ "slt ft4.x, ft2.x, fc10.y            \n"

			+ // x < 0  ft4.x
			"slt ft4.y, ft2.y, fc10.y            \n"
			+ // y < 0  ft4.y
			"sub ft4.z, fc10.x, ft4.x            \n"
			+ // x >= 0  ft4.z
			"sub ft4.w, fc10.x, ft4.y            \n"
			+ // y >= 0  ft4.w

			"mul ft3.x, ft4.z, ft4.w            \n"
			+ // x > 0 && y > 0  ft3.x
			"mul ft3.y, ft4.x, ft4.w            \n"
			+ // x < 0 && y > 0  ft3.y
			"mul ft3.z, ft4.x, ft4.y            \n"
			+ // x < 0 && y < 0  ft3.z
			"mul ft3.w, ft4.z, ft4.y            \n"
			+ // x > 0 && y < 0  ft3.w

			"sub ft4.x, ft5.x, fc10.z            \n"
			+ // a - Pi  ft4.x
			"neg ft4.y, ft5.y                   \n"
			+ // -a      ft4.y
			"mov ft4.z, ft5.x                   \n"
			+ // a       ft4.z
			"sub ft4.w, fc10.z, ft5.y            \n"
			+ // Pi - a  ft4.w

			"mul ft4, ft4, ft3                  \n"
			+ // multiply grid of possibilities

			"add ft4.xy, ft4.xz, ft4.yw         \n"
			+ // add possibilities
			"add ft4.x, ft4.x, ft4.y            \n";
	}
}
