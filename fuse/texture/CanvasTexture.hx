#if html5
package fuse.texture;

import js.html.CanvasElement;
import fuse.core.front.texture.FrontCanvasTexture;
import signal.Signal;

class CanvasTexture extends BaseTexture {
	var canvasTexture:FrontCanvasTexture;

	public function new(canvas:CanvasElement = null) {
		super();
		texture = canvasTexture = new FrontCanvasTexture(canvas);
	}

	public function update() {
		canvasTexture.update();
	}
}
#end
