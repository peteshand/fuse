package fuse.core.front.texture;

import flash.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
class BlankBmd extends BitmapData {
	public function new() {
		var _w:Int = 8;
		var _h:Int = 8;
		var color:UInt = 0x00000000;
		/*#if debug
			_w = 512;
			_h = 512;
			color = 0x11f2f2f2;
			#end */

		super(_w, _h, true, color);

		/*#if debug
			var divs:Int = 32;
			var size:Int = Math.floor(_w / divs);
			var rect:Rectangle = new Rectangle(0, 0, size, size);
			for (i in 0...divs) {
				for (j in 0...divs) {
					rect.x = i * size;
					rect.y = j * size;
					if ((i + j) % 2 == 0) {
						this.fillRect(rect, 0x11a59892);
					}
				}
			}
			#end */
	}
}
