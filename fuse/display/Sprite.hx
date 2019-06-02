package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObjectContainer;

class Sprite extends DisplayObjectContainer {
	public function new() {
		super();
		displayType = DisplayType.SPRITE;
	}

	public function clone() {
		var _clone = new Sprite();
		copySpriteProps(this, _clone);
		copySpriteChildren(this, _clone);
		return _clone;
	}

	function copySpriteProps(from:Sprite, to:Sprite) {
		to.name = from.name;
		to.x = from.x;
		to.y = from.y;
		to.width = from.width;
		to.height = from.height;
		to.pivotX = from.pivotX;
		to.pivotY = from.pivotY;
		to.rotation = from.rotation;
		to.scaleX = from.scaleX;
		to.scaleY = from.scaleY;
		to.color = from.color;
		to.colorTL = from.colorTL;
		to.colorTR = from.colorTR;
		to.colorBL = from.colorBL;
		to.colorBR = from.colorBR;
		to.alpha = from.alpha;
		to.visible = from.visible;
		to.mask = from.mask;
	}

	function copySpriteChildren(from:Sprite, to:Sprite) {
		for (i in 0...from.children.length) {
			if (from.children[i].displayType == DisplayType.IMAGE) {
				to.addChild(cast(from.children[i], Image).clone());
			} else if (from.children[i].displayType == DisplayType.SCALE9_IMAGE) {
				to.addChild(cast(from.children[i], Scale9Image).clone());
			} else if (from.children[i].displayType == DisplayType.QUAD) {
				to.addChild(cast(from.children[i], Quad).clone());
			} else if (from.children[i].displayType == DisplayType.SPRITE) {
				to.addChild(cast(from.children[i], Sprite).clone());
			}
		}
	}
}
