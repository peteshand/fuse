package fuse.text.textDisplay.display;

import fuse.text.textDisplay.utils.Updater;
import fuse.display.Sprite;
import fuse.display.Quad;

class Border extends Sprite {
	public var position(default, set):BorderPosition;
	public var thickness(default, set):Float;
	public var borderColor(default, set):UInt;

	var top:Quad;
	var bottom:Quad;
	var left:Quad;
	var right:Quad;
	var updater:Updater;
	var _width:Float;
	var _height:Float;
	var _borderColor:UInt;

	public function new(width:Float = 100, height:Float = 100, color:UInt = 0xffffff, thickness:Float = 1, position:BorderPosition = BorderPosition.INSIDE) {
		super();

		updater = new Updater(update);

		// batchable = true;
		touchable = false;

		top = new Quad(100, 100, color);
		bottom = new Quad(100, 100, color);
		left = new Quad(100, 100, color);
		right = new Quad(100, 100, color);

		addChild(top);
		addChild(bottom);
		addChild(left);
		addChild(right);

		_width = width;
		_height = height;
		_borderColor = color;
		this.thickness = thickness;
		this.position = position;
	}

	function update() {
		// clear();

		top.color = _borderColor;
		bottom.color = _borderColor;
		left.color = _borderColor;
		right.color = _borderColor;

		var l:Float = 0;
		var t:Float = 0;
		var r:Float = _width;
		var b:Float = _height;

		switch (position) {
			case OUTSIDE:
				l -= thickness;
				t -= thickness;
				r += thickness;
				b += thickness;
			case CENTER:
				l -= thickness / 2;
				t -= thickness / 2;
				r += thickness / 2;
				b += thickness / 2;
			case INSIDE:
				// ignore
		}

		top.x = l;
		top.y = t;
		top.width = r - l;
		top.height = thickness;

		left.x = l;
		left.y = t + thickness;
		left.width = thickness;
		left.height = b - t - thickness * 2;

		bottom.x = l;
		bottom.y = b - thickness;
		bottom.width = r - l;
		bottom.height = thickness;

		right.x = r - thickness;
		right.y = t + thickness;
		right.width = thickness;
		right.height = b - t - thickness * 2;
	}

	override function get_width():Float {
		return _width;
	}

	override function set_width(value:Float):Float {
		if (_width == value)
			return value;
		_width = value;
		updater.markForUpdate();
		return value;
	}

	override function get_height():Float {
		return _height;
	}

	override function set_height(value:Float):Float {
		if (_height == value)
			return value;
		_height = value;
		updater.markForUpdate();
		return value;
	}

	function set_position(value:BorderPosition):BorderPosition {
		if (position == value)
			return value;
		position = value;
		updater.markForUpdate();
		return value;
	}

	function set_thickness(value:Float):Float {
		if (thickness == value)
			return value;
		thickness = value;
		updater.markForUpdate();
		return value;
	}

	function set_borderColor(value:UInt):UInt {
		if (_borderColor == value)
			return value;
		_borderColor = value;
		updater.markForUpdate();
		return value;
	}
}

@:enum abstract BorderPosition(String) {
	var INSIDE = "inside";
	var OUTSIDE = "outside";
	var CENTER = "center";
}
