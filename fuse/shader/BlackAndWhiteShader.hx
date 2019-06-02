package fuse.shader;

import openfl.filters.ColorMatrixFilter;

class BlackAndWhiteShader extends ColorMatrixShader {
	public function new() {
		super(new ColorMatrixFilter([
			0.5, 0.5, 0.5, 0, 0, // red
			0.5, 0.5, 0.5, 0, 0, // green
			0.5, 0.5, 0.5, 0, 0, // blue
			  0,   0,   0, 1, 0 // alpha
		]));
	}
}
