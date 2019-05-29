package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.core.front.texture.Textures;
import fuse.utils.Color;
import fuse.texture.BitmapTexture;
import fuse.core.front.texture.FrontDefaultTexture;

// import fuse.texture.DefaultTexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.DefaultTexture)
@:access(fuse.core.front.texture.FrontBitmapTexture)
@:access(fuse.core.front.texture.Textures)
class Quad extends Image {
	@:isVar public var directRender(default, set):Bool;

	var defaultTexture:FrontDefaultTexture;

	public function new(width:Int, height:Int, color:Color = 0xFFFFFFFF) {
		super(Textures.whiteTexture);

		if (color.alpha != 0xFF) {
			this.alpha = color.alpha / 0xFF;
			color.alpha = 0xFF;
		}

		defaultTexture = untyped Textures.whiteTexture.texture;

		this.color = color;
		this.width = width;
		this.height = height;

		displayType = DisplayType.QUAD;
	}

	override public function clone():Image {
		var _clone = super.clone();
		_clone.displayType = DisplayType.QUAD;
		return _clone;
	}

	function set_directRender(value:Bool):Bool {
		directRender = value;
		if (directRender) {
			this.texture = new BitmapTexture(defaultTexture.bitmapData);
			this.texture.directRender = true;
		} else {
			if (this.texture != null && this.texture != Textures.whiteTexture) {
				this.texture.dispose();
			}
			this.texture = Textures.whiteTexture;
		}
		return value;
	}
}
