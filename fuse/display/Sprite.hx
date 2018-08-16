package fuse.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.display.DisplayObjectContainer;

class Sprite extends DisplayObjectContainer
{
	public function new() {
		super();
		displayType = DisplayType.SPRITE;
	}
	
	//override function forceRedraw():Void
	//{
		//super.forceRedraw();
		//if (children != null){
			//for (i in 0...children.length) 
			//{
				//children[i].forceRedraw();
			//}		
		//}
	//}
}
