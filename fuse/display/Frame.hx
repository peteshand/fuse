package fuse.display;

import fuse.utils.composite.Composite;
import fuse.utils.composite.CompositeMode;
import fuse.texture.ITexture;
import fuse.utils.Align;
import fuse.geom.Rectangle;
import color.Color;

class Frame extends Sprite {
	var background:Quad;
	var image:Image;
	var frameWidth:Int = 100;
	var frameHeight:Int = 100;
	var frameX:Float = 0;
	var frameY:Float = 0;
	var compositeRect:Rectangle;
	var backgroundColor:Null<UInt>;

	@:isVar public var texture(default, set):ITexture;

	@:isVar public var mode(default, set):CompositeMode = CompositeMode.LETTERBOX;
	public var contentWidth(get, never):Float;
	public var contentHeight(get, never):Float;
	@:isVar public var contentAlignH(default, set):Align = Align.CENTER;
	@:isVar public var contentAlignV(default, set):Align = Align.CENTER;
	@:isVar public var contentScale(default, set):Float = 1;
	@:isVar public var offsetX(default, set):Float = 0;
	@:isVar public var offsetY(default, set):Float = 0;

	@:isVar public var offsetU(default, set):Float = 0;
	@:isVar public var offsetV(default, set):Float = 0;
	@:isVar public var scaleU(default, set):Float = 1;
	@:isVar public var scaleV(default, set):Float = 1;

	public function new(width:Int, height:Int, texture:ITexture, backgroundColor:Null<UInt> = null) {
		super();

		this.backgroundColor = backgroundColor;
		if (backgroundColor != null) {
			background = new Quad(width, height, backgroundColor);
			addChild(background);
		}

		image = new Image(texture);
		addChild(image);
		this.texture = texture;

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
		frameWidth = Math.round(value);
		if (background != null) {
			background.width = frameWidth;
		}
		updateLayout();
		return frameWidth;
	}

	override function set_height(value:Float):Float {
		frameHeight = Math.round(value);
		if (background != null) {
			background.height = frameHeight;
		}
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
		image.offsetU = offsetU;
		image.offsetV = offsetV;

		if (compositeRect.width > frameWidth) {
			if (compositeRect.x < 0) {
				image.x = 0;
				image.offsetU = (offsetU * frameWidth / compositeRect.width) - (compositeRect.x / compositeRect.width);
			}
			if (compositeRect.width > frameWidth)
				image.width = frameWidth;
			image.scaleU = scaleU * (frameWidth / compositeRect.width);
		} else {
			image.scaleU = scaleU;
		}

		if (compositeRect.height > frameHeight) {
			// if (compositeRect.y < 0) {
			image.y = 0;
			image.offsetV = (offsetV * frameHeight / compositeRect.height) - (compositeRect.y / compositeRect.height);
			// }
			if (compositeRect.height > frameHeight)
				image.height = frameHeight;
			image.scaleV = scaleV * (frameHeight / compositeRect.height);
		} else {
			image.scaleV = scaleV;
		}
	}

	override public function clone():Sprite {
		var _clone = new Frame(frameWidth, frameHeight, image.texture, backgroundColor);
		copySpriteProps(this, _clone);
		_clone.mode = this.mode;
		_clone.contentAlignH = this.contentAlignH;
		_clone.contentAlignV = this.contentAlignV;
		_clone.contentScale = this.contentScale;
		_clone.offsetX = this.offsetX;
		_clone.offsetY = this.offsetY;
		// copySpriteChildren(this, _clone);
		return cast(_clone, Sprite);
	}

	override public function dispose() {
		if (background != null) {
			if (background.parent != null) {
				background.parent.removeChild(background);
				background = null;
			}
		}
		if (image != null) {
			if (image.parent != null) {
				image.parent.removeChild(image);
				image.dispose();
				image = null;
			}
		}
		if (texture != null) {
			texture.onUpdate.remove(updateLayout);
			texture = null;
		}

		super.dispose();
	}

	override function updateAlignmentX() {
		if (horizontalAlign != null) {
			pivotX = Math.round(scaleX * frameWidth * cast(horizontalAlign, Float));
		}
	}

	override function updateAlignmentY() {
		if (verticalAlign != null) {
			pivotY = Math.round(scaleY * frameHeight * cast(verticalAlign, Float));
		}
	}

	function set_texture(value:ITexture):ITexture {
		if (texture != null) {
			texture.onUpdate.remove(updateLayout);
		}
		image.texture = texture = value;
		if (texture != null) {
			texture.onUpdate.add(updateLayout);
		}
		return texture;
	}

	function set_offsetU(value:Float):Float {
		if (offsetU != value) {
			offsetU = value;
			updateLayout();
		}
		return value;
	}

	function set_offsetV(value:Float):Float {
		if (offsetV != value) {
			offsetV = value;
			updateLayout();
		}
		return value;
	}

	function set_scaleU(value:Float):Float {
		if (scaleU != value) {
			scaleU = value;
			updateLayout();
		}
		return value;
	}

	function set_scaleV(value:Float):Float {
		if (scaleV != value) {
			scaleV = value;
			updateLayout();
		}
		return value;
	}

	override function set_color(value:Color):Color {
		super.set_color(value);
		if (image != null)
			image.color = value;
		return value;
	}
}
