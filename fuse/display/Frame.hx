package fuse.display;

import mantle.util.composite.Composite;
import mantle.util.composite.CompositeMode;
import fuse.texture.ITexture;
import fuse.utils.Align;
import fuse.geom.Rectangle;

class Frame extends Sprite {
	var background:Quad;
	var image:Image;
	var frameWidth:Float = 100;
	var frameHeight:Float = 100;
	var frameX:Float = 0;
	var frameY:Float = 0;
	var compositeRect:Rectangle;

	@:isVar public var mode(default, set):CompositeMode = CompositeMode.LETTERBOX;
	public var contentWidth(get, never):Float;
	public var contentHeight(get, never):Float;
	@:isVar public var contentAlignH(default, set):Align = Align.CENTER;
	@:isVar public var contentAlignV(default, set):Align = Align.CENTER;
	@:isVar public var contentScale(default, set):Float = 1;
	@:isVar public var offsetX(default, set):Float = 0;
	@:isVar public var offsetY(default, set):Float = 0;

	public function new(width:Int, height:Int, texture:ITexture, backgroundColor:Null<UInt> = null) {
		super();

		if (backgroundColor != null) {
			background = new Quad(width, height, backgroundColor);
			addChild(background);
		}

		image = new Image(texture);
		addChild(image);

		texture.onUpdate.add(updateLayout);

		frameWidth = width;
		frameHeight = height;
	}

	override function get_width():Float {
		return frameWidth;
	}

	override function get_height():Float {
		return frameHeight;
	}

	function get_contentWidth():Float {
		return compositeRect.width;
	}

	function get_contentHeight():Float {
		return compositeRect.height;
	}

	override function set_width(value:Float):Float {
		background.width = frameWidth = value;
		updateLayout();
		return frameWidth;
	}

	override function set_height(value:Float):Float {
		background.height = frameHeight = value;
		updateLayout();
		return frameHeight;
	}

	function set_mode(value:CompositeMode):CompositeMode {
		mode = value;
		updateLayout();
		return mode;
	}

	function set_contentAlignH(value:Align):Align {
		contentAlignH = value;
		updateLayout();
		return contentAlignH;
	}

	function set_contentAlignV(value:Align):Align {
		contentAlignV = value;
		updateLayout();
		return contentAlignV;
	}

	function set_contentScale(value:Float):Float {
		contentScale = value;
		updateLayout();
		return contentScale;
	}

	function set_offsetX(value:Float):Float {
		offsetX = value;
		updateLayout();
		return offsetX;
	}

	function set_offsetY(value:Float):Float {
		offsetY = value;
		updateLayout();
		return offsetY;
	}

	function updateLayout() {
		compositeRect = Composite.fit(frameWidth, frameHeight, image.texture.width, image.texture.height, mode, contentAlignH, contentAlignV, contentScale);

		compositeRect.x += offsetX;
		compositeRect.y += offsetY;

		image.width = compositeRect.width;
		image.height = compositeRect.height;
		image.x = compositeRect.x;
		image.y = compositeRect.y;
		image.offsetU = 0;
		image.offsetV = 0;

		if (compositeRect.width > frameWidth) {
			if (compositeRect.x < 0) {
				image.x = 0;
				image.offsetU = -compositeRect.x / compositeRect.width;
			}
			if (compositeRect.width > frameWidth)
				image.width = frameWidth;
			image.scaleU = frameWidth / compositeRect.width;
		} else {
			image.scaleU = 1;
		}

		if (compositeRect.height > frameHeight) {
			if (compositeRect.y < 0) {
				image.y = 0;
				image.offsetV = -compositeRect.y / compositeRect.height;
			}
			if (compositeRect.height > frameHeight)
				image.height = frameHeight;
			image.scaleV = frameHeight / compositeRect.height;
		} else {
			image.scaleV = 1;
		}
	}
}
