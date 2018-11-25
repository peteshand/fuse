package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObjectContainer;

class Sprite extends DisplayObjectContainer
{
	public function new() {
		super();
		displayType = DisplayType.SPRITE;
	}
	
	public function clone()
	{
		var _clone = new Sprite();
		_clone.name = this.name;
		_clone.x = this.x;
		_clone.y = this.y;
		_clone.width = this.width;
		_clone.height = this.height;
		_clone.pivotX = this.pivotX;
		_clone.pivotY = this.pivotY;
		_clone.rotation = this.rotation;
		_clone.scaleX = this.scaleX;
		_clone.scaleY = this.scaleY;
		_clone.color = this.color;
		_clone.colorTL = this.colorTL;
		_clone.colorTR = this.colorTR;
		_clone.colorBL = this.colorBL;
		_clone.colorBR = this.colorBR;
		_clone.alpha = this.alpha;
		_clone.visible = this.visible;
		_clone.mask = this.mask;
		for (i in 0...children.length) 
		{
			if (children[i].displayType == DisplayType.IMAGE){
				_clone.addChild(cast(children[i], Image).clone());
			} else if (children[i].displayType == DisplayType.QUAD){
				_clone.addChild(cast(children[i], Quad).clone());
			} else if (children[i].displayType == DisplayType.SPRITE){
				_clone.addChild(cast(children[i], Sprite).clone());
			}
		}
		return _clone;
	}
}
