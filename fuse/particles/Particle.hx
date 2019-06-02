// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package fuse.particles;

import fuse.display.Image;
import fuse.display.BlendMode;
import fuse.texture.BaseTexture;

class Particle extends Image {
	@:isVar public var scale(default, set):Float = 1;
	public var currentTime:Float;
	public var totalTime:Float;

	static var COUNT:Int = 0;

	public var index:Int;

	public function new(texture:BaseTexture) {
		super(texture);

		index = COUNT++;
		this.alignPivot();
	}

	function set_scale(value:Float):Float {
		return scale = this.scaleX = this.scaleY = value;
	}
}
