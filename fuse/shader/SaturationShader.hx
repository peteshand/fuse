package fuse.shader;

import openfl.filters.ColorMatrixFilter;

class SaturationShader extends ColorMatrixShader {
	@:isVar public var saturation(default, set):Float = 0;

	public function new(saturation:Float = 0) {
		super();
		this.saturation = saturation;
	}

	function set_saturation(value:Float):Float {
		saturation = value;
		var negSat:Float = saturation * -0.5;
		var f:Array<Float> = [
			1 + saturation,         negSat,         negSat, 0, 0, // red
			        negSat, 1 + saturation,         negSat, 0, 0, // green
			        negSat,         negSat, 1 + saturation, 0, 0, // blue
			             0,              0,              0, 1, 0 // alpha
		];
		colorMatrixFilter = new ColorMatrixFilter(f);
		return value;
	}
}
